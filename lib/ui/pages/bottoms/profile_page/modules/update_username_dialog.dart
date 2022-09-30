part of '../profile_page.dart';

class _UpdateUserNameDialog extends StatelessWidget {
  const _UpdateUserNameDialog({
    Key? key,
    required this.userProvider,
  }) : super(key: key);

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Username"),
      content: TextFormField(
        initialValue: userProvider.usermodel!.username,
        onChanged: (v) {
          userProvider.updateUsername = v;
          userProvider.notify();
        },
        maxLength: 21,
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
                "username": userProvider.updateUsername,
              });
              userProvider.usermodel!.username = userProvider.updateUsername!;
              userProvider.notify();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text("Done"))
      ],
    );
  }
}
