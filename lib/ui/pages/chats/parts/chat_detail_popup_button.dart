part of '../chat_page.dart';
class _ChatDetailPopupButton extends StatelessWidget {
  const _ChatDetailPopupButton({
    Key? key,
    required this.userProvider,
    required this.getDetails,
  }) : super(key: key);

  final UserProvider userProvider;
  final UserModel getDetails;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                    userProvider.usermodel!.myFollowers.contains(getDetails.uid)
                        ? "Takibi Bırak"
                        : "Takip Et"),
                onTap: () async {
                  final DatabaseReference ref = FirebaseDatabase.instance
                      .ref("users")
                      .child(userProvider.usermodel!.uid);
                  if (userProvider.usermodel!.myFollowers
                      .contains(getDetails.uid)) {
                    userProvider.usermodel!.myFollowers.remove(getDetails.uid);
                    userProvider.notify();
                    await ref.update({
                      "myFollowers": userProvider.usermodel!.myFollowers,
                    });
                  } else {
                    userProvider.usermodel!.myFollowers.add(getDetails.uid);
                    userProvider.notify();
                    await ref.update({
                      "myFollowers": userProvider.usermodel!.myFollowers,
                    });
                  }
                },
              )
            ]);
  }
}