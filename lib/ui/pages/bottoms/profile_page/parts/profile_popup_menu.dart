part of '../profile_page.dart';

class _ProfilePopupMenu extends StatelessWidget {
  const _ProfilePopupMenu({
    Key? key,
    required this.userProvider,
    required this.themeChange,
  }) : super(key: key);

  final UserProvider userProvider;
  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: GestureDetector(
                    onTap: () async {
                      await _UpdateUserNameDialog(
                        userProvider: userProvider,
                      ).show(context);
                    },
                    child: const Text("Change Username")),
              ),
              PopupMenuItem(
                value: 2,
                onTap: () {
                  UserService().logout(context);
                },
                child: const Text("Sign Out"),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Text(themeChange.darkTheme ? 'Dark Theme' : 'Light Theme'),
                    Checkbox(
                        value: themeChange.darkTheme,
                        onChanged: (value) {
                          themeChange.darkTheme = value!;
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const UserImageCollection()));
                    },
                    child: const Text('My Collection')),
              )
            ]);
  }
}
