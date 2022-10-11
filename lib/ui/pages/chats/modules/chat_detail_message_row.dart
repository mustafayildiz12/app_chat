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
          Expanded(
            child: TextFormField(
              controller: chatDetailProvider.chatController,
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
                      Icons.photo_camera,
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
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send_sharp),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).iconTheme.color,
              child: IconButton(
                onPressed: () async {
                  await chatDetailProvider.sendLocation(context);

                  final locationData =
                      await chatDetailProvider.location.getLocation();

                  // ignore: use_build_context_synchronously
                  await ChatService().sendMessage(context,
                      chatUser: widget.getDetails,
                      message: chatDetailProvider.chatController.text,
                      type: 'location',
                      lat: locationData.latitude,
                      lon: locationData.longitude,
                      chatID:
                          '${userProvider.usermodel!.uid}${widget.getDetails.uid}');
                },
                icon: const Icon(
                  Icons.location_history,
                  size: 20,
                ),
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
            title: const Text('Galeri'),
            trailing: Icon(
              Icons.photo,
              color: Theme.of(context).iconTheme.color,
            ))
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
