part of '../chat_page.dart';

class _ChatDetailMessageRow extends StatelessWidget {
  const _ChatDetailMessageRow({
    Key? key,
    required TextEditingController chat,
    required this.chatDetailProvider,
    required this.widget,
    required this.userProvider,
  })  : _chat = chat,
        super(key: key);

  final TextEditingController _chat;
  final ChatDetailProvider chatDetailProvider;
  final ChatPage widget;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    child: const Icon(Icons.record_voice_over),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Theme.of(context).shadowColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        builder: (context) {
                          return _ChatDetailBottomSheet(
                            chatDetailProvider: chatDetailProvider,
                          );
                        },
                      );
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
                        type: 'text',
                        chatID:
                            '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                    _chat.clear();
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
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send_sharp),
              ),
            ),
          )
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
            title: const Text('Kamera'),
            trailing: const Icon(Icons.camera_alt)),
        ListTile(
            onTap: () {
              chatDetailProvider.selectImageFromGallery();

              chatDetailProvider.isLoading = true;
              chatDetailProvider.notify();
               Navigator.pop(context);
            },
            title: const Text('Galeri'),
            trailing: const Icon(Icons.photo))
      ],
    );
  }
}
