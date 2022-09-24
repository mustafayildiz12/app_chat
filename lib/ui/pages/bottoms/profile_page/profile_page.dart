import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/provider/theme_provider.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/ui/pages/bottoms/profile_page/user_image_collection.dart';
import 'package:app_chat/ui/product/loading_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: GestureDetector(
                          onTap: () async {
                            await _UpdateUserNameDialog(
                              userProvider: userProvider,
                              newUsername: newUsername,
                            ).show(context);
                          },
                          child: const Text("Change Username")),
                    ),
                    PopupMenuItem(
                      value: 2,
                      onTap: () {
                        UserService().logout(context);
                      },
                      child: const Text("Sign Out"),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Text(themeChange.darkTheme
                              ? 'Dark Theme'
                              : 'Light Theme'),
                          Checkbox(
                              value: themeChange.darkTheme,
                              onChanged: (value) {
                                themeChange.darkTheme = value!;
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserImageCollection()));
                          },
                          child: const Text('My Collection')),
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
                height: Screen.height(context) * 3,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Card(
                  child: ListTile(
                    onTap: (){
                      
                    },
                    subtitle: Text(
                        userProvider.usermodel!.myFollowers.length.toString()),
                    title: const Text("Takip Edilen Kişi Sayısı"),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Card(
                  child: ListTile(
                    subtitle: Text(
                        userProvider.usermodel!.myCollection.length.toString()),
                    title: const Text("Koleksiyon Syısı"),
                  ),
                ),
              ),
              SizedBox(
                height: Screen.height(context) * 3,
              ),
              Visibility(
                visible: isLoading,
                child: LoadingButton(
                    onPressed: () async {
                      if (pickedFile != null) {
                        imagePath =
                            'images/${userProvider.usermodel!.email}/profileImage.png';

                        await uploadFile(context);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    title: "Save"),
              ),
              if (userProvider.usermodel!.myCollection.isNotEmpty)
                CarouselSlider.builder(
                  itemCount: userProvider.usermodel!.myCollection.length,
                  options: CarouselOptions(autoPlay: true),
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      SizedBox(
                    height: Screen.height(context) * 25,
                    child: Image.network(
                      userProvider.usermodel!.myCollection[itemIndex],
                      fit: BoxFit.fitHeight,
                      loadingBuilder: (context, child, loadingProgress) {
                        final totalBytes = loadingProgress?.expectedTotalBytes;
                        final bytesLoaded =
                            loadingProgress?.cumulativeBytesLoaded;
                        if (totalBytes != null && bytesLoaded != null) {
                          return const CupertinoActivityIndicator(
                              //  value: bytesLoaded / totalBytes,
                              );
                        } else {
                          return child;
                        }
                      },
                    ),
                  ),
                )
              else
                const Text('Your Collection is empty'),
            ],
          ),
        ),
      ),
    );
  }
}

extension SettingsDialogExtension on _UpdateUserNameDialog {
  show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}
