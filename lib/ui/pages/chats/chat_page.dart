import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/service/chat_service.dart';
import 'package:app_chat/ui/pages/chats/message_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';
import '../../../core/service/database_service.dart';
import '../../../utils/helpers/my_image_picker.dart';

class ChatPage extends StatefulWidget {
  final UserModel getDetails;
  const ChatPage({required this.getDetails, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chat = TextEditingController();

  File? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;
  String imageUrl = '';
  String imagePath = '';
  bool isLoading = false;

  Future uploadFile(BuildContext context, String chatID) async {
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
      appBar: AppBar(
        title: Text(widget.getDetails.username),
        leading: widget.getDetails.profileImage != ""
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: Screen.height(context) * 3,
                  backgroundImage:
                      NetworkImage(widget.getDetails.profileImage!),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: Screen.height(context) * 3,
                  child: const Icon(Icons.flutter_dash),
                ),
              ),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(userProvider.usermodel!.myFollowers
                              .contains(widget.getDetails.uid)
                          ? "Takibi Bırak"
                          : "Takip Et"),
                      onTap: () async {
                        final DatabaseReference ref = FirebaseDatabase.instance
                            .ref("users")
                            .child(userProvider.usermodel!.uid);
                        if (userProvider.usermodel!.myFollowers
                            .contains(widget.getDetails.uid)) {
                          userProvider.usermodel!.myFollowers
                              .remove(widget.getDetails.uid);
                          userProvider.notify();
                          await ref.update({
                            "myFollowers": userProvider.usermodel!.myFollowers,
                          });
                          print(1.1);
                        } else {
                          userProvider.usermodel!.myFollowers
                              .add(widget.getDetails.uid);
                          userProvider.notify();
                          await ref.update({
                            "myFollowers": userProvider.usermodel!.myFollowers,
                          });
                          print(2.1);
                        }
                      },
                    )
                  ])
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: DatabaseService().chatStream(
                  '${userProvider.usermodel!.uid}${widget.getDetails.uid}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    var data = (snapshot.data as DatabaseEvent).snapshot.value;
                    if (data != null) {
                      Map dataMap = data as Map;
                      final chatID = dataMap['chatID'];
                      return Column(
                        children: [
                          Expanded(
                            child: MessagesList(
                              chatID: chatID,
                              myUser: userProvider.usermodel!,
                            ),
                          ),
                          pickedFile != null
                              ? Image.file(
                                  pickedFile!,
                                  height: Screen.width(context) * 50,
                                  width: Screen.width(context) * 50,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox()
                        ],
                      );
                    } else {
                      return const Center(child: Text("Henüz mesaj yok"));
                    }
                  } else {
                    return const Center(child: Text("Henüz mesaj yok"));
                  }
                } else {
                  return const Center(child: Text("Henüz mesaj yok"));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _chat,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () async {
                            selectImage();
                            setState(() {
                              isLoading = true;
                            });
                          },
                          icon: const Icon(Icons.photo_camera),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      onPressed: () async {
                        if (_chat.text.isNotEmpty) {
                          await ChatService().sendMessage(context,
                              chatUser: widget.getDetails,
                              message: _chat.text,
                              chatID:
                                  '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                          _chat.clear();
                        }

                        if (pickedFile != null) {
                          imagePath =
                              'images/${userProvider.usermodel!.email}/chatImages/${userProvider.usermodel!.uid}${widget.getDetails.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
                          await uploadFile(context,
                              '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                          setState(() {
                            isLoading = false;
                            pickedFile = null;
                          });
                          await ChatService().sendMessage(context,
                              chatUser: widget.getDetails,
                              message: imageUrl,
                              chatID:
                                  '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                          print(2.3);
                          
                        }
                      },
                      icon: const Icon(Icons.send_sharp),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
