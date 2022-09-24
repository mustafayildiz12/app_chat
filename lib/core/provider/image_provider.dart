import 'dart:io';

import 'package:app_chat/core/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadImageProvider extends ChangeNotifier {
  bool isCollectionLoaded = false;

  final ImagePicker imagePicker = ImagePicker();
  UploadTask? uploadTask;
  String? imageUrl;
  String imagePath = '';
  List<XFile>? imageFileList = [];

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

  Future uploadFile(String path) async {
    final file = File(path);

    final ref = FirebaseStorage.instance.ref().child(imagePath);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    imageUrl = await snapshot.ref.getDownloadURL();

    uploadTask = null;
    notify();
  }

  void uploadSelectedImagesToFirebase(BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    checkCollectionLoaded();
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users")
        .child(userProvider.usermodel!.uid);

    for (int i = 0; i < imageFileList!.length; i++) {
      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      imagePath =
          'images/${userProvider.usermodel!.email}/collection/$id/$i.png';

      await uploadFile(imageFileList![i].path);
      userProvider.usermodel!.myCollection.add(imageUrl);
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
