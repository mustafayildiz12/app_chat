part of '../chat_page.dart';

class _MessagesList extends StatelessWidget {
  const _MessagesList({
    Key? key,
    required this.chatDetailProvider,
    required this.chatID,
    required this.myUser,
    required this.sawMessageId,
  }) : super(key: key);

  final String chatID;
  final String sawMessageId;
  final ChatDetailProvider chatDetailProvider;
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

                if (!sendedByMe &&
                    !chatDetailProvider.readedMessages.contains(message)) {
                  chatDetailProvider.setSeen(message, sawMessageId);
                }

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
                              ? GestureDetector(
                                  onTap: () {
                                    _ShowPickImageDialog(
                                      message: message,
                                    ).show(context);
                                  },
                                  child: SizedBox(
                                    height: Screen.height(context) * 40,
                                    width: Screen.width(context) * 50,
                                    child: Image.network(
                                      message.message,
                                      fit: BoxFit.fitWidth,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        final totalBytes =
                                            loadingProgress?.expectedTotalBytes;
                                        final bytesLoaded = loadingProgress
                                            ?.cumulativeBytesLoaded;
                                        if (totalBytes != null &&
                                            bytesLoaded != null) {
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
                              : message.type == 'voice'
                                  ? VoiceMessage(message: message)
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
                                size: 18,
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

class VoiceMessage extends StatefulWidget {
  const VoiceMessage({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  State<VoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer.setSourceUrl(widget.message.message);
  }

  @override
  Widget build(BuildContext context) {
    print('message.message  ${widget.message.message}');
    return CustomAudioPlayerWidget(url: widget.message.message);
  }
}
