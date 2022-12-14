part of '../chat_page.dart';

class _ChatDetailAppBar extends StatelessWidget with PreferredSizeWidget {
  const _ChatDetailAppBar({
    Key? key,
    required this.getDetails,
    required this.userProvider,
  }) : super(key: key);

  final UserProvider userProvider;
  final UserModel getDetails;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        getDetails.username,
        overflow: TextOverflow.ellipsis,
      ),
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
      actions: [
        getDetails.profileImage != ""
            ? Align(
                widthFactor: 0.1,
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: Screen.height(context) * 3,
                  backgroundImage: NetworkImage(getDetails.profileImage!),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: Screen.height(context) * 3,
                  child: const Icon(Icons.flutter_dash),
                ),
              ),
        _ChatDetailPopupButton(
          userProvider: userProvider,
          getDetails: getDetails,
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
