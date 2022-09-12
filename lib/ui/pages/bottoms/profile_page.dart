import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/ui/product/loading_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/repostiroy/user_repository.dart';
import '../../../utils/helpers/my_image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;
  bool isImageLoaded = false;
  String imageUrl = '';
  String imagePath = '';
  bool isLoading = false;

  Future uploadFile() async {
    final file = File(pickedFile?.path ?? '');

    final ref = FirebaseStorage.instance.ref().child(imagePath);

    setState(() {
      uploadTask =
          ref.putFile(file, SettableMetadata(contentType: 'image/png'));
    });
    final snapshot = await uploadTask!.whenComplete(() {
      setState(() {});
    });

    imageUrl = await snapshot.ref.getDownloadURL();
    //  print('image' + imageUrl);

    setState(() {
      uploadTask = null;
    });
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

    setState(() {
      pickedFile = File(result!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.exit_to_app_sharp),
          onPressed: () {
        UserService().logout(context);
      }),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: Screen.height(context) * 5,
            ),
            Stack(
              children: [
                pickedFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          pickedFile!,
                          height: Screen.width(context) * 50,
                          width: Screen.width(context) * 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: Screen.width(context) * 25,
                        backgroundImage:
                            NetworkImage(userProvider.usermodel!.profileImage!),
                      ),
                Positioned(
                  bottom: -Screen.height(context) * 2,
                  right: Screen.width(context) * 5,
                  child: IconButton(
                      onPressed: () async {
                       await selectImage();
                      //   print(userProvider.usermodel);
                      },
                      icon: const Icon(
                        Icons.photo_camera,
                        color: Colors.blue,
                        size: 30,
                      )),
                )
              ],
            ),
            SizedBox(
              height: Screen.height(context) * 5,
            ),
            LoadingButton(
                onPressed: () async {
                  if (pickedFile != null) {
                    DatabaseReference ref = FirebaseDatabase.instance
                        .ref("users")
                        .child(userProvider.usermodel!.uid);
                    imagePath =
                        'images/${userProvider.usermodel!.email}/profileImage.png';

                  
                    await uploadFile();
                    await ref.update({
                      "profileImage": imageUrl,
                    });
                      userProvider.usermodel!.profileImage = imageUrl;
                    userProvider.notify();
                  }
                },
                title: "Save")
          ],
        ),
      ),
    );
  }
}
