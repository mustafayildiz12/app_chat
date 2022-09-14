import 'dart:collection';
import 'package:app_chat/core/service/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
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
              final myDate =  DateTime.parse(message.date);

                return Align(
                  alignment:
                      sendedByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: sendedByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        margin: EdgeInsets.only(
                          left: sendedByMe ? 50 : 0,
                          right: sendedByMe ? 0 : 50,
                          bottom: 8
                        ),
                        decoration: BoxDecoration(
                          color: sendedByMe ? Colors.amber : Colors.deepOrange,
                          borderRadius: BorderRadius.circular(12)
                        ),
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
                                  color:
                                      message.seen ? Colors.blue : Colors.grey,
                                ),
                              ),
                          ],
                        ),

                      /*
                      if (!togetherWithBottom) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: sendedByMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            /*
                            Text(
                              DateTime.parse(message.date).toHour(),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 12,
                              ),
                            ),
                             */
                            if (sendedByMe)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.done_all,
                                  color:
                                      message.seen ? Colors.blue : Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ] else
                        const SizedBox(height: 4),
                      */
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

/*
  BorderRadius getBorderRadius(
      bool togetherWithBottom, bool sendedByMe, double radius) {
    return togetherWithBottom
        ? BorderRadius.circular(radius)
        : BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(sendedByMe ? radius : 0),
            bottomRight: Radius.circular(sendedByMe ? 0 : radius),
          );
  }
 */
}

// class VideoMessage extends StatefulWidget {
//   const VideoMessage({Key? key, required this.url}) : super(key: key);
//   final String url;

//   @override
//   State<VideoMessage> createState() => _VideoMessageState();
// }

// class _VideoMessageState extends State<VideoMessage> {
//   String? fileName;

//   Future<void> setThumbnail() async {
//     fileName = await VideoThumbnail.thumbnailFile(
//       video: widget.url,
//       thumbnailPath: (await getTemporaryDirectory()).path,
//       imageFormat: ImageFormat.PNG,
//       quality: 100,
//     );
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     setThumbnail();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen(url: widget.url)));
//       },
//       child: Container(
//         height: 200,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           image: fileName != null
//               ? DecorationImage(
//                   image: FileImage(File(fileName!)),
//                   fit: BoxFit.cover,
//                 )
//               : null,
//         ),
//         child: Center(
//             child: Icon(
//           Icons.play_circle_outline,
//           size: 50,
//           color: Colors.white.withOpacity(0.5),
//         )),
//       ),
//     );
//   }
// }

