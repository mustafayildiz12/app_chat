part of 'profile_page.dart';

class _UpdateUserNameDialog extends StatelessWidget {
  const _UpdateUserNameDialog({
    Key? key,
    required this.newUsername,
    required this.userProvider,
  }) : super(key: key);

  final TextEditingController newUsername;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Username"),
      content: TextFormField(
        controller: newUsername,
        maxLength: 21,
        decoration: InputDecoration(
          hintText: userProvider.usermodel!.username,
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.grey),
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
                "username": newUsername.text,
              });
              userProvider.usermodel!.username = newUsername.text;
              userProvider.notify();
              Navigator.pop(context);
            },
            child: const Text("Done"))
      ],
    );
  }
}
