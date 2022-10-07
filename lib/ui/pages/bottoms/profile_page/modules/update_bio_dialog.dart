part of '../profile_page.dart';

class _UpdateBioDialog extends StatelessWidget {
  const _UpdateBioDialog({
    Key? key,
    required this.userProvider,
  }) : super(key: key);

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: const Text("Update Bio"),
      content: TextFormField(
        initialValue: userProvider.usermodel!.bio,
        maxLines: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Screen.width(context) * 6)),
        ),
        onChanged: (v) {
          userProvider.updateBio = v;
          userProvider.notify();
        },
        maxLength: 100,
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back")),
        ElevatedButton(
            onPressed: () async {
              final DatabaseReference ref = FirebaseDatabase.instance
                  .ref("users")
                  .child(userProvider.usermodel!.uid);
              await ref.update({
                "bio": userProvider.updateBio,
              });
              userProvider.usermodel!.bio = userProvider.updateBio!;
              userProvider.notify();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text("Done"))
      ],
    );
  }
}
