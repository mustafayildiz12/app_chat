import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/provider/chat_detail_provider.dart';
import 'package:app_chat/core/service/chat_service.dart';
import 'package:app_chat/ui/pages/chats/message_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';
import '../../../core/provider/voice_record_provider.dart';
import '../../../core/service/database_service.dart';
import '../../../core/service/storage_service.dart';
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

  final ValueNotifier<bool> isSendingImage = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    voiceRecorderInit();
    //  getData();
  }

  void voiceRecorderInit() {
    VoiceRecordProvider voiceRecordProvider =
        Provider.of<VoiceRecordProvider>(context, listen: false);
    voiceRecordProvider.init();
  }

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
    VoiceRecordProvider voiceRecordProvider =
        Provider.of<VoiceRecordProvider>(context);
    ChatDetailProvider chatDetailProvider =
        Provider.of<ChatDetailProvider>(context);
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
                      final sawMessageId =
                          '${widget.getDetails.uid}${userProvider.usermodel!.uid}';
                      return Column(
                        children: [
                          Expanded(
                            child: MessagesList(
                              sawMessageId: sawMessageId,
                              chatID: chatID,
                              chatDetailProvider: chatDetailProvider,
                              myUser: userProvider.usermodel!,
                            ),
                          ),
                          pickedFile != null
                              ? Stack(
                                  children: [
                                    Image.file(
                                      pickedFile!,
                                      height: Screen.width(context) * 50,
                                      width: Screen.width(context) * 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                        top: 1,
                                        right: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              pickedFile = null;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            child:
                                                const Icon(Icons.close_sharp),
                                          ),
                                        ))
                                  ],
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
          if (chatDetailProvider.showVoiceRecord)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      chatDetailProvider.showVoiceRecord =
                          !chatDetailProvider.showVoiceRecord;
                      chatDetailProvider.notify();
                    },
                    child: const Icon(Icons.close),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.pink,
                    child: Center(
                      child: Text(voiceRecordProvider.recorderTxt),
                    ),
                  )),
                  GestureDetector(
                    onTap: () async {
                      if (voiceRecordProvider.recordingEnded) {
                        String? audioFilePath;
                        var codec = voiceRecordProvider.codec;
                        if (await voiceRecordProvider.fileExists(
                            voiceRecordProvider.path[codec.index]!)) {
                          audioFilePath = voiceRecordProvider.path[codec.index];
                          print('audioFilePath: $audioFilePath');
                          File recordFile = File(audioFilePath!);
                          String voicePath = await StorageService()
                              .sendVoiceRecord(
                                  uid: userProvider.usermodel!.uid,
                                  recordFile: recordFile);
                          print('voicePath: $voicePath');
                          // ignore: use_build_context_synchronously
                          await ChatService().sendMessage(context,
                              message: voicePath,
                              chatID:
                                  '${userProvider.usermodel!.uid}${widget.getDetails.uid}',
                              chatUser: widget.getDetails,
                              type: 'voice');
                        }
                        chatDetailProvider.showVoiceRecord =
                            !chatDetailProvider.showVoiceRecord;
                        voiceRecordProvider.isRecording = false;
                        voiceRecordProvider.recordingEnded = false;
                        voiceRecordProvider.recorderTxt = '00:00';

                        chatDetailProvider.notify();
                      } else {
                        if (voiceRecordProvider.isRecording) {
                          await voiceRecordProvider.stopRecorder();
                        } else {
                          await voiceRecordProvider.startRecorder();
                        }
                      }
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        voiceRecordProvider.recordingEnded
                            ? Icons.send
                            : voiceRecordProvider.isRecording
                                ? Icons.stop
                                : Icons.mic_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
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
                        prefixIcon: GestureDetector(
                          onTap: () {
                            chatDetailProvider.showVoiceRecord =
                                !chatDetailProvider.showVoiceRecord;
                            chatDetailProvider.notify();
                          },
                          child: const Icon(Icons.voice_over_off),
                        ),
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
                ValueListenableBuilder(
                  valueListenable: isSendingImage,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          onPressed: () async {
                            if (_chat.text.isNotEmpty) {
                              await ChatService().sendMessage(context,
                                  chatUser: widget.getDetails,
                                  message: _chat.text,
                                  type: 'text',
                                  chatID:
                                      '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                              _chat.clear();
                            }

                            if (pickedFile != null) {
                              isSendingImage.value = true;
                              imagePath =
                                  'images/${userProvider.usermodel!.email}/chatImages/${userProvider.usermodel!.uid}${widget.getDetails.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
                              // ignore: use_build_context_synchronously
                              await uploadFile(context,
                                  '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                              setState(() {
                                isLoading = false;
                                pickedFile = null;
                              });
                              // ignore: use_build_context_synchronously
                              await ChatService().sendMessage(context,
                                  chatUser: widget.getDetails,
                                  message: imageUrl,
                                  type: 'image',
                                  chatID:
                                      '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                              print(2.3);
                              isSendingImage.value = false;
                            }
                          },
                          icon: isSendingImage.value
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send_sharp),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
