import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserImageCollection extends StatefulWidget {
  const UserImageCollection({Key? key}) : super(key: key);

  @override
  State<UserImageCollection> createState() => _UserImageCollectionState();
}

class _UserImageCollectionState extends State<UserImageCollection> {
  final ImagePicker imagePicker = ImagePicker();
  UploadTask? uploadTask;
  List<XFile>? imageFileList = [];
  String? imageUrl;
  bool isLoaded = false;
  String imagePath = '';

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    setState(() {});
  }

  Future uploadFile(String path) async {
    final file = File(path);

    final ref = FirebaseStorage.instance.ref().child(imagePath);

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {
      setState(() {});
    });

    imageUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: imageFileList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(File(imageFileList![index].path),
                          height: Screen.height(context) * 20,
                          fit: BoxFit.fitHeight));
                }),
          )),
          TextButton(
              onPressed: () {
                selectImages();
              },
              child: const Text("Add Image")),
          SizedBox(height: Screen.height(context) * 10),
          Visibility(
            visible: imageFileList!.isNotEmpty,
            child: ElevatedButton(
                onPressed: () async {
                  DatabaseReference ref = FirebaseDatabase.instance
                      .ref("users")
                      .child(userProvider.usermodel!.uid);

                  isLoaded = !isLoaded;
                  for (int i = 0; i < imageFileList!.length; i++) {
                    imagePath =
                        'images/${userProvider.usermodel!.email}/collection/${userProvider.usermodel!.uid}/$i.png';

                    await uploadFile(imageFileList![i].path);
                    userProvider.usermodel!.myCollection.add(imageUrl);
                    userProvider.notify();

                    await ref.update({
                      "myCollection": userProvider.usermodel!.myCollection,
                    }).then((value) {});
                  }

                  userProvider.notify();

                  /*
                  DataSnapshot dataSnapshot = await ref.get();
                  if (dataSnapshot.exists) {
                    Map data = dataSnapshot.value as Map;
                    data['key'] = dataSnapshot.key;
                    userProvider.usermodel!.myCollection = data['myCollection'];

                    userProvider.notify();

                    isLoaded = !isLoaded;
                   
                  }
                   */
                  // ignore: use_build_context_synchronously
                  setState(() {
                    imageFileList = [];
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Images successfully uploaded"),
                  ));
                },
                child: const Text('Save Changes')),
          ),
          SizedBox(height: Screen.height(context) * 2),
        ],
      ),
    );
  }
}
