import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/service/chat_service.dart';
import 'package:app_chat/ui/pages/chats/message_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';
import '../../../core/service/database_service.dart';

class ChatPage extends StatefulWidget {
  final UserModel getDetails;
  const ChatPage({required this.getDetails, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chat = TextEditingController();
  // final List<String> chatList = [];
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
                )),
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
                      return MessagesList(
                        chatID: chatID,
                        myUser: userProvider.usermodel!,
                      );
                    } else {
                      return StreamBuilder(
                        stream: DatabaseService().chatStream(
                            '${widget.getDetails.uid}${userProvider.usermodel!.uid}'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              var data = (snapshot.data as DatabaseEvent)
                                  .snapshot
                                  .value;

                              if (data != null) {
                                Map dataMap = data as Map;
                                final chatID = dataMap['chatID'];
                                return MessagesList(
                                  chatID: chatID,
                                  myUser: userProvider.usermodel!,
                                );
                              }
                            } else {
                              return const Center(child: Text('Mesaj Yok'));
                            }
                          }
                          return const Center(child: Text('Mesaj Yok'));
                        },
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
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
