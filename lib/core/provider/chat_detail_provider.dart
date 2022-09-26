import 'dart:io';

import 'package:app_chat/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/helpers/my_image_picker.dart';
import '../models/message_model.dart';
import '../service/chat_service.dart';
import '../service/database_service.dart';

class ChatDetailProvider extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<Message> readedMessages = [];

  File? imageToUpload;

  bool recordingStarted = false;
  bool showTextfield = true;
  bool showRecordingButtons = false;
  bool showVoiceRecord = false;

  UserMetadata? opponent;

  File? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;
  String imageUrl = '';
  String imagePath = '';
  bool isLoading = false;
  bool isSendingImage = false;

  Future uploadFile(BuildContext context, String chatID) async {
    final file = File(pickedFile?.path ?? '');

    final ref = FirebaseStorage.instance.ref().child(imagePath);

    uploadTask = ref.putFile(file, SettableMetadata(contentType: 'image/png'));

    final snapshot = await uploadTask!.whenComplete(() {});

    imageUrl = await snapshot.ref.getDownloadURL();
    //  print('image' + imageUrl);

    uploadTask = null;
    notify();
  }

  Future selectImageFromGallery() async {
    File? result;
    try {
      result = await MyImagePicker.pickImage();
    } catch (e) {
      print('error$e');
    }
    print(result!.path);
    if (result == null) return;

    pickedFile = File(result.path);
    notify();
  }

  Future selectImageFromCamera() async {
    File? result;
    try {
      result = await MyImagePicker.takePicture();
    } catch (e) {
      print('error$e');
    }
    print(result!.path);
    if (result == null) return;

    pickedFile = File(result.path);
    notify();
  }

  Stream chatStream(String chatID) {
    return DatabaseService().chatStream(chatID);
  }

  void scrollToBottom() {
    if (scrollController.positions.isNotEmpty) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }

  void toggleRecording() {
    if (recordingStarted) {
      endRecording();
    } else {
      startRecording();
    }
    notifyListeners();
  }

  Future<void> startRecording() async {
    recordingStarted = true;
    showTextfield = false;
    await Future.delayed(const Duration(milliseconds: 100));
    showRecordingButtons = true;
    notifyListeners();
  }

  Future<void> endRecording() async {
    recordingStarted = false;
    showRecordingButtons = false;
    await Future.delayed(const Duration(milliseconds: 300));
    showTextfield = true;
    notifyListeners();
  }

  Future<void> sendMessage(
    BuildContext context, {
    required String chatID,
    required UserModel chatUser,
    required String message,
    required void Function(String) onNewChatID,
    required String type,

    //  bool isVoice = false,
  }) async {
    controller.clear();
    await ChatService().sendMessage(
      context,
      chatUser: chatUser,
      message: message,
      type: type,
      // onNewChatID: onNewChatID,
      chatID: chatID,

      // isVoice: is
      //  isVoice: isVoice);
    );
    const Duration(milliseconds: 300);
    if (scrollController.positions.isNotEmpty) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 100), curve: Curves.bounceIn);
    }
  }

  Future<void> setSeen(Message message, String chatID) async {
    message.seen = true;
    await DatabaseService().setSeen(message, chatID);
    readedMessages.add(message);
  }

/*
  void toggleRecording() {
    if (recordingStarted) {
      endRecording();
    } else {
      startRecording();
    }
    notifyListeners();
  }

  Future<void> startRecording() async {
    recordingStarted = true;
    showTextfield = false;
    await Future.delayed(const Duration(milliseconds: 100));
    showRecordingButtons = true;
    notifyListeners();
  }

  Future<void> endRecording() async {
    recordingStarted = false;
    showRecordingButtons = false;
    await Future.delayed(const Duration(milliseconds: 300));
    showTextfield = true;
    notifyListeners();
  }

  Future<void> openOtherOptions(context, {required Function(bool isVideo) onImageSelected}) async {
    String otherOption = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => OtherOptions(),
    );
    if (otherOption == 'camera') {
      imageToUpload = await MyImagePicker.takePicture();
      print(imageToUpload.toString());
    } else if (otherOption == 'gallery') {
      imageToUpload = await MyImagePicker.pickImage();
      print(imageToUpload.toString());
    } else if (otherOption == 'video') {
      imageToUpload = await MyImagePicker.pickVideo();
      print(imageToUpload.toString());
    }
    if (imageToUpload != null) {
      bool? send = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmMedia(media: imageToUpload!, otherOption: otherOption),
        ),
      );

      if (send == true) {
        onImageSelected(otherOption == 'video');
      }
    }
  }
 */

  void notify() {
    notifyListeners();
  }
}
