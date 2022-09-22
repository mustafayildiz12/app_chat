import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../utils/helpers/voice_enums.dart';

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
