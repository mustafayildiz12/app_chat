import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/ui/product/loading_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/repostiroy/user_repository.dart';
import '../../../../utils/helpers/my_image_picker.dart';

part 'update_username_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;
  String imageUrl = '';
  String imagePath = '';
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController newUsername = TextEditingController();

  Future uploadFile(BuildContext context) async {
    final file = File(pickedFile?.path ?? '');
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    final DatabaseReference firebaseDatabase =
        FirebaseDatabase.instance.ref("users").child(auth.currentUser!.uid);

    setState(() {
      uploadTask =
          ref.putFile(file, SettableMetadata(contentType: 'image/png'));
    });
    final snapshot = await uploadTask!.whenComplete(() {
      setState(() {});
    });

    imageUrl = await snapshot.ref.getDownloadURL();
    //  print('image' + imageUrl);

    await firebaseDatabase.update({
      "profileImage": imageUrl,
    });
    userProvider.usermodel!.profileImage = imageUrl;
    userProvider.notify();

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
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return _UpdateUserNameDialog(
                                  newUsername: newUsername,
                                  userProvider: userProvider);
                            });
                      },
                      child: const Text("Change Username"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      onTap: () {
                        UserService().logout(context);
                      },
                      child: const Text("Sign Out"),
                    )
                  ])
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
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
                      : userProvider.usermodel!.profileImage != ''
                          ? CircleAvatar(
                              radius: Screen.width(context) * 25,
                              backgroundImage: NetworkImage(
                                  userProvider.usermodel!.profileImage!),
                            )
                          : CircleAvatar(
                              radius: Screen.width(context) * 25,
                              backgroundColor: Colors.amber,
                            ),
                  Positioned(
                    bottom: -Screen.height(context) * 1,
                    right: Screen.width(context) * 5,
                    child: IconButton(
                        onPressed: () async {
                          await selectImage();
                          setState(() {
                            isLoading = true;
                          });
                        },
                        icon: const Icon(
                          Icons.photo_camera,
                          color: Colors.blue,
                          size: 32,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: Screen.height(context) * 5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Card(
                  child: ListTile(
                    title: Text(userProvider.usermodel!.username),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Card(
                  child: ListTile(
                    title: Text(userProvider.usermodel!.email),
                  ),
                ),
              ),
              SizedBox(
                height: Screen.height(context) * 5,
              ),
              Visibility(
                visible: isLoading,
                child: LoadingButton(
                    onPressed: () async {
                      if (pickedFile != null) {
                        imagePath =
                            'images/${userProvider.usermodel!.email}/profileImage.png';

                        await uploadFile(context);
                      }
                    },
                    title: "Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
