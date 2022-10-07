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
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: GestureDetector(
                    onTap: () async {
                      await _UpdateUserNameDialog(
                        userProvider: userProvider,
                      ).show(context);
                    },
                    child: Text(
                      "Change Username",
                      style: TextStyle(color: Colors.grey.shade300),
                    )),
              ),
              PopupMenuItem(
                value: 2,
                onTap: () {
                  UserService().logout(context);
                },
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Text(
                      themeChange.darkTheme ? 'Dark Theme' : 'Light Theme',
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
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
                    child: Text(
                      'My Collection',
                      style: TextStyle(color: Colors.grey.shade300),
                    )),
              )
            ]);
  }
}
