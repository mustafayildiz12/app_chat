import 'package:app_chat/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/chat_service.dart';
import '../service/database_service.dart';

class ChatDetailProvider extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

//  List<Message> readedMessages = [];

//  File? imageToUpload;

  bool recordingStarted = false;
  bool showTextfield = true;
  bool showRecordingButtons = false;
  bool showVoiceRecord = false;

  UserMetadata? opponent;

  Stream chatStream(String chatID) {
    return DatabaseService().chatStream(chatID);
  }

  void scrollToBottom() {
    if (scrollController.positions.isNotEmpty) scrollController.jumpTo(scrollController.position.minScrollExtent);
  }

/*
  Future<void> removeAnonym(String chatID) async {
    await DatabaseService().removeAnonym(chatID);
  }

  
 */

  Future<void> sendMessage(
    BuildContext context, {
   required String chatID,
    required UserModel chatUser,
    required String message,
    required void Function(String) onNewChatID,
    bool isImage = false,
    bool isVideo = false,
    bool isVoice = false,
  }) async {
    controller.clear();
    await ChatService().sendMessage(context,
        chatUser: chatUser,
        message: message,
       // onNewChatID: onNewChatID,
        chatID: chatID,
      //  isImage: isImage,
      //  isVideo: isVideo,
      //  isVoice: isVoice);
    );
    const Duration(milliseconds: 300);
    if (scrollController.positions.isNotEmpty) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 100), curve: Curves.bounceIn);
    }
  }

/*
  Future<void> setSeen(Message message, String chatID) async {
    message.seen = true;
    await DatabaseService().setSeen(message, chatID);
    readedMessages.add(message);
  }
 */

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