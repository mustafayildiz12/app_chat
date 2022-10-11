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
                        ? Stack(
                            children: [
                              Image.file(
                                chatDetailProvider.pickedFile!,
                                height: Screen.width(context) * 50,
                                width: Screen.width(context) * 50,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 1,
                                  right: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      chatDetailProvider.pickedFile = null;
                                      chatDetailProvider.notify();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: const Icon(Icons.close_sharp),
                                    ),
                                  ))
                            ],
                          )
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
