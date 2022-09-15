import 'package:flutter/material.dart';

import '../../../core/models/message_model.dart';
import '../../../core/models/user_model.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    Key? key,
    required this.chatID,
    required this.myUser,
    required this.messages,
  }) : super(key: key);

  final String chatID;
  final UserModel myUser;
  final List messages;

  @override
  Widget build(BuildContext context) {
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
            //    'isImage': messageHashMap['isImage'] ?? false,
            //    'isVideo': messageHashMap['isVideo'] ?? false,
            //    'isVoice': messageHashMap['isVoice'] ?? false,
            'senderUID': messageHashMap['senderUID'],
            'seen': messageHashMap['seen'],
            'id': messageHashMap['id'],
          };

          Message message = Message.fromMap(messageMap);

          bool sendedByMe = message.senderUID == myUser.uid;

          /*
                if (!sendedByMe &&
                    !chatDetailProvider.readedMessages.contains(message)) {
                  chatDetailProvider.setSeen(message, chatID);
                }
               */

          //  bool togetherWithBottom = false;

          /*
                if (index != 0 &&
                    message.senderUID ==
                        messages[index - 1].value['senderUID']) {
                  togetherWithBottom = true;
                }
               */
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
                      color: sendedByMe ? Theme.of(context).errorColor : Theme.of(context).hintColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    message.message,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Row(
                  mainAxisAlignment: sendedByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      '${myDate.hour}:${myDate.minute}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
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
  }
}
