import 'dart:io';

import 'package:app_chat/core/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/helpers/my_image_picker.dart';

class UploadImageProvider extends ChangeNotifier {
  bool isCollectionLoaded = false;
  bool isProfileLoaded = false;
  bool isProfileLoading = false;

  final ImagePicker imagePicker = ImagePicker();
  UploadTask? uploadmultiTask;
  String? imageMultiUrl;
  String imageMultiPath = '';
  List<XFile>? imageFileList = [];

  File? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;
  String imageUrl = '';
  String imagePath = '';

  Future uploadFile(BuildContext context) async {
    final file = File(pickedFile?.path ?? '');
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    final DatabaseReference firebaseDatabase = FirebaseDatabase.instance
        .ref("users")
        .child(userProvider.usermodel!.uid);

    uploadTask = ref.putFile(file, SettableMetadata(contentType: 'image/png'));

    final snapshot = await uploadTask!.whenComplete(() {});

    imageUrl = await snapshot.ref.getDownloadURL();

    await firebaseDatabase.update({
      "profileImage": imageUrl,
    });
    userProvider.usermodel!.profileImage = imageUrl;
    userProvider.notify();

    uploadTask = null;
    notify();
  }

  Future selectImage() async {
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

  void checkCollectionLoaded() {
    isCollectionLoaded = !isCollectionLoaded;
    notify();
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    notify();
  }

  Future uploadmultiFile(String path) async {
    final file = File(path);

    final ref = FirebaseStorage.instance.ref().child(imageMultiPath);

    uploadmultiTask = ref.putFile(file);

    final snapshot = await uploadmultiTask!.whenComplete(() {});

    imageMultiUrl = await snapshot.ref.getDownloadURL();

    uploadmultiTask = null;
    notify();
  }

  void uploadSelectedImagesToFirebase(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    checkCollectionLoaded();
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users")
        .child(userProvider.usermodel!.uid);

    for (int i = 0; i < imageFileList!.length; i++) {
      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      imageMultiPath =
          'images/${userProvider.usermodel!.email}/collection/$id.png';

      await uploadmultiFile(imageFileList![i].path);
      userProvider.usermodel!.myCollection.add(imageMultiUrl);
      notify();

      await ref.update({
        "myCollection": userProvider.usermodel!.myCollection,
      });
    }

    imageFileList = [];
    checkCollectionLoaded();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Images successfully uploaded"),
    ));
  }

  void notify() {
    notifyListeners();
  }
}
