import 'dart:io';

import 'package:app_chat/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../utils/helpers/my_image_picker.dart';
import '../models/message_model.dart';
import '../service/chat_service.dart';
import '../service/database_service.dart';

class ChatDetailProvider extends ChangeNotifier {
  TextEditingController chatController = TextEditingController();
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

  // ignore: unnecessary_new
  Location location = new Location();

  final bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

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
  }) async {
    chatController.clear();
    await ChatService().sendMessage(
      context,
      chatUser: chatUser,
      message: message,
      type: type,
      chatID: chatID,
    );
    const Duration(milliseconds: 100);
    if (scrollController.positions.isNotEmpty) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 50), curve: Curves.bounceIn);
    }
  }

  Future<void> setSeen(Message message, String chatID) async {
    message.seen = true;
    await DatabaseService().setSeen(message, chatID);
    readedMessages.add(message);
  }

  Future<bool> setupLocation() async {
    location;
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    notify();

    return true;
  }

  sendLocation(BuildContext context) async {
    final canSendLocation = await setupLocation();
    if (canSendLocation != true) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "We can't access your location at this time. Did you allow location access?"),
        ),
      );
    }

    // ignore: use_build_context_synchronously

    return;
  }

  void notify() {
    notifyListeners();
  }
}
