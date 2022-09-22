import 'dart:collection';

import 'package:app_chat/core/service/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/message_model.dart';
import '../../../core/models/user_model.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    Key? key,
    required this.chatID,
    required this.myUser,
  }) : super(key: key);

  final String chatID;
  final UserModel myUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().chatStream(chatID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DatabaseEvent databaseEvent = snapshot.data as DatabaseEvent;
          if (databaseEvent.snapshot.value == null) {
            return const SizedBox();
          }
          if ((databaseEvent.snapshot.value as Map)['messages'] == null) {
            return const SizedBox();
          }
          LinkedHashMap linkedHashMap =
              (databaseEvent.snapshot.value as Map)['messages'];
          List messages = linkedHashMap.entries.toList();
          messages.sort((a, b) => b.value['date'].compareTo(a.value['date']));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var messageHashMap = messages[index].value;

                Map<String, dynamic> messageMap = {
                  'message': messageHashMap['message'],
                  'date': messageHashMap['date'],
                  'type': messageHashMap['type'],
                  'senderUID': messageHashMap['senderUID'],
                  'seen': messageHashMap['seen'],
                  'id': messageHashMap['id'],
                };

                Message message = Message.fromMap(messageMap);

                bool sendedByMe = message.senderUID == myUser.uid;

                final myDate = DateTime.parse(message.date);

                return Align(
                  alignment:
                      sendedByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: sendedByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: EdgeInsets.only(
                              left: sendedByMe ? 50 : 0,
                              right: sendedByMe ? 0 : 50,
                              bottom: 8),
                          decoration: BoxDecoration(
                              color: sendedByMe
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).hintColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: message.type == 'image'
                              ? Image.network(
                                  message.message,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    final totalBytes =
                                        loadingProgress?.expectedTotalBytes;
                                    final bytesLoaded =
                                        loadingProgress?.cumulativeBytesLoaded;
                                    if (totalBytes != null &&
                                        bytesLoaded != null) {
                                      return const CupertinoActivityIndicator(
                                          //  value: bytesLoaded / totalBytes,
                                          );
                                    } else {
                                      return child;
                                    }
                                  },
                                )
                              : Text(message.message)),
                      Row(
                        mainAxisAlignment: sendedByMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            '${myDate.hour}:${myDate.minute}',
                            style: TextStyle(
                              color: Theme.of(context).shadowColor,
                              fontSize: 12,
                            ),
                          ),
                          if (sendedByMe)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.done_all,
                                color: message.seen ? Colors.blue : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("Error");
        }
        return const Text('');
      },
    );
  }
}
