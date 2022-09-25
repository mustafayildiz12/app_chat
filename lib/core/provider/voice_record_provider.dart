import 'dart:async';
import 'dart:io';

import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/provider/chat_detail_provider.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../utils/helpers/voice_enums.dart';
import '../service/chat_service.dart';
import '../service/storage_service.dart';

class VoiceRecordProvider extends ChangeNotifier {
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  Codec codec = Codec.aacMP4;
  Media media = Media.file;
  StreamController<Food>? recordingDataController;
  StreamSubscription? recorderSubscription;
  bool isRecording = false;
  bool recordingEnded = false;
  String recorderTxt = '00:00';
  List<String?> path = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  Future<void> init() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await recorderModule.openRecorder();
    await recorderModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
    await initializeDateFormatting();
  }

  Future sendVoiceMessage(BuildContext context, UserModel getDetails) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ChatDetailProvider chatDetailProvider =
        Provider.of<ChatDetailProvider>(context, listen: false);
    if (recordingEnded) {
      String? audioFilePath;

      if (await fileExists(path[codec.index]!)) {
        audioFilePath = path[codec.index];
        print('audioFilePath: $audioFilePath');
        File recordFile = File(audioFilePath!);
        String voicePath = await StorageService().sendVoiceRecord(
            uid: userProvider.usermodel!.uid, recordFile: recordFile);
        print('voicePath: $voicePath');
        // ignore: use_build_context_synchronously
        await ChatService().sendMessage(context,
            message: voicePath,
            chatID: '${userProvider.usermodel!.uid}${getDetails.uid}',
            chatUser: getDetails,
            type: 'voice');
      }
      chatDetailProvider.showVoiceRecord = !chatDetailProvider.showVoiceRecord;
      isRecording = false;
      recordingEnded = false;
      recorderTxt = '00:00';
      chatDetailProvider.notify;

      notifyListeners();
    } else {
      if (isRecording) {
        await stopRecorder();
      } else {
        await startRecorder();
      }
    }
  }

  Future<void> startRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    var savePath = '';
    var tempDir = await getTemporaryDirectory();
    savePath = '${tempDir.path}/flutter_sound${ext[codec.index]}';

    await recorderModule.startRecorder(
      toFile: savePath,
      codec: codec,
      bitRate: 32500,
      numChannels: 1,
      sampleRate: 44100,
    );

    // durationForAndroid = Duration.zero;
    // startTimer();

    recorderModule.logger.d('startRecorder');

    recorderSubscription = recorderModule.onProgress!.listen((e) {
      Duration duration = e.duration;
      recorderTxt = duration.durationToString();
      notifyListeners();
    });

    isRecording = true;
    path[codec.index] = savePath;
    notifyListeners();
  }

  Future<void> stopRecorder() async {
    await recorderModule.stopRecorder();
    // if (Platform.isAndroid) {
    //   stopTimer();
    // }

    recorderModule.logger.d('stopRecorder');
    if (recorderSubscription != null) {
      recorderSubscription!.cancel();
      recorderSubscription = null;
    }

    isRecording = false;
    recordingEnded = true;
    notifyListeners();
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }
}

extension DurationToString on Duration {
  String durationToString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
