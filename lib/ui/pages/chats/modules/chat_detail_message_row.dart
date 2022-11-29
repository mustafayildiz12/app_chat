part of '../chat_page.dart';

class _ChatDetailMessageRow extends StatelessWidget {
  const _ChatDetailMessageRow({
    Key? key,
    required this.chatDetailProvider,
    required this.widget,
    required this.userProvider,
  }) : super(key: key);

  final ChatDetailProvider chatDetailProvider;
  final ChatPage widget;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                chatDetailProvider.emojiShowing =
                    !chatDetailProvider.emojiShowing;
                chatDetailProvider.notify();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              icon: const Icon(Icons.emoji_emotions)),
          Expanded(
            child: TextFormField(
              onTap: () {
                chatDetailProvider.emojiShowing = false;
                chatDetailProvider.notify();
              },
              controller: chatDetailProvider.chatController,
              maxLines: null,
              decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                    onTap: () {
                      chatDetailProvider.showVoiceRecord =
                          !chatDetailProvider.showVoiceRecord;
                      chatDetailProvider.notify();
                    },
                    child: Icon(
                      Icons.record_voice_over,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      _ChatDetailBottomSheet(
                        chatDetailProvider: chatDetailProvider,
                      ).show(context);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).iconTheme.color,
              child: IconButton(
                onPressed: () async {
                  if (chatDetailProvider.chatController.text.isNotEmpty) {
                    await ChatService().sendMessage(context,
                        chatUser: widget.getDetails,
                        message: chatDetailProvider.chatController.text,
                        type: 'text',
                        chatID:
                            '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                    chatDetailProvider.chatController.clear();
                  }

                  if (chatDetailProvider.pickedFile != null) {
                    chatDetailProvider.isSendingImage = true;
                    chatDetailProvider.notify();
                    chatDetailProvider.imagePath =
                        'images/${userProvider.usermodel!.email}/chatImages/${userProvider.usermodel!.uid}${widget.getDetails.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
                    // ignore: use_build_context_synchronously
                    await chatDetailProvider.uploadFile(context,
                        '${userProvider.usermodel!.uid}${widget.getDetails.uid}');

                    chatDetailProvider.isLoading = false;
                    chatDetailProvider.pickedFile = null;
                    chatDetailProvider.notify();

                    // ignore: use_build_context_synchronously
                    await ChatService().sendMessage(context,
                        chatUser: widget.getDetails,
                        message: chatDetailProvider.imageUrl,
                        type: 'image',
                        chatID:
                            '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                    chatDetailProvider.isSendingImage = false;
                    chatDetailProvider.notify();
                  }
                },
                icon: chatDetailProvider.isSendingImage
                    ? CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )
                    : const Icon(Icons.send_sharp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatDetailBottomSheet extends StatelessWidget {
  const _ChatDetailBottomSheet({
    Key? key,
    required this.chatDetailProvider,
  }) : super(key: key);

  final ChatDetailProvider chatDetailProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            onTap: () {
              chatDetailProvider.selectImageFromCamera();

              chatDetailProvider.isLoading = true;
              chatDetailProvider.notify();
              Navigator.pop(context);
            },
            title: Text(
              'Camera',
              style: TextStyle(color: Colors.grey.shade300),
            ),
            trailing: Icon(
              Icons.camera_alt,
              color: Theme.of(context).iconTheme.color,
            )),
        ListTile(
          onTap: () {
            chatDetailProvider.selectImageFromGallery();

            chatDetailProvider.isLoading = true;
            chatDetailProvider.notify();
            Navigator.pop(context);
          },
          title: Text(
            'Galery',
            style: TextStyle(color: Colors.grey.shade300),
          ),
          trailing: Icon(
            Icons.photo,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        ListTile(
          onTap: () async {
            await chatDetailProvider.sendLocation(context);

            await chatDetailProvider.getUserLocation();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          title: Text(
            'Share Location',
            style: TextStyle(color: Colors.grey.shade300),
          ),
          trailing: Icon(
            Icons.location_history,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}

extension ChatDetailBottomSheetExtension on _ChatDetailBottomSheet {
  show(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      context: context,
      builder: (context) => this,
    );
  }
}
