part of '../chat_page.dart';

class _ChatStream extends StatelessWidget {
  const _ChatStream({
    Key? key,
    required this.userProvider,
    required this.getDetails,
    required this.chatDetailProvider,
  }) : super(key: key);

  final UserProvider userProvider;
  final UserModel getDetails;
  final ChatDetailProvider chatDetailProvider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: DatabaseService()
            .chatStream('${userProvider.usermodel!.uid}${getDetails.uid}'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              var data = (snapshot.data as DatabaseEvent).snapshot.value;

              if (data != null) {
                Map dataMap = data as Map;
                final chatID = dataMap['chatID'];
                final sawMessageId =
                    '${getDetails.uid}${userProvider.usermodel!.uid}';
                return Column(
                  children: [
                    Expanded(
                      child: _MessagesList(
                        sawMessageId: sawMessageId,
                        chatID: chatID,
                        chatDetailProvider: chatDetailProvider,
                        myUser: userProvider.usermodel!,
                      ),
                    ),
                    chatDetailProvider.pickedFile != null
                        ? _ShowStackedImagePreview(
                            chatDetailProvider: chatDetailProvider)
                        : chatDetailProvider.isMapReadyToSend
                            ? _ShowStackedMapPreview(
                                chatDetailProvider: chatDetailProvider,
                                getDetails: getDetails,
                                userProvider: userProvider)
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
    );
  }
}
