part of '../profile_page.dart';

class _UserProfileInfo extends StatelessWidget {
  const _UserProfileInfo({
    Key? key,
    required this.userProvider,
  }) : super(key: key);

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Card(
            child: ListTile(
              title: Text(userProvider.usermodel!.username),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Card(
            child: ListTile(
              onTap: () async {
                await _UpdateBioDialog(
                  userProvider: userProvider,
                ).show(context);
              },
              title: Text(userProvider.usermodel!.bio),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Card(
            child: ListTile(
              title: Text(userProvider.usermodel!.email),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Card(
            child: ListTile(
              subtitle:
                  Text(userProvider.usermodel!.myFollowers.length.toString()),
              title: const Text("My Followers"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Card(
            child: ListTile(
              subtitle:
                  Text(userProvider.usermodel!.myCollection.length.toString()),
              title: const Text("My Collection"),
            ),
          ),
        ),
        SizedBox(
          height: Screen.height(context) * 3,
        ),
      ],
    );
  }
}

extension BioDialogExtension on _UpdateBioDialog {
  show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}
