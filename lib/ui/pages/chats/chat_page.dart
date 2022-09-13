import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel getDetails;
  const ChatPage({required this.getDetails, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chat = TextEditingController();
  final List<String> chatList = [];
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
              child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Text(
                      chatList[index],
                      textAlign:
                          index % 2 == 0 ? TextAlign.left : TextAlign.right,
                    ));
                  })),
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
                        chatList.add(_chat.text);

                        await DatabaseService().sendMessage(
                            widget.getDetails.uid + userProvider.usermodel!.uid,
                            _chat.text,
                            userProvider.usermodel!.uid,
                            widget.getDetails.uid);
                        setState(() {});
                        _chat.clear();
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
