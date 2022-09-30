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
       padding:
           const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
       child: Card(
         child: ListTile(
           title: Text(userProvider.usermodel!.username),
         ),
       ),
     ),
     Padding(
       padding:
           const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
       child: Card(
         child: ListTile(
           title: Text(userProvider.usermodel!.email),
         ),
       ),
     ),
     Padding(
       padding:
           const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
       child: Card(
         child: ListTile(
           onTap: () {},
           subtitle: Text(
               userProvider.usermodel!.myFollowers.length.toString()),
           title: const Text("Takip Edilen Kişi Sayısı"),
         ),
       ),
     ),
     Padding(
       padding:
           const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
       child: Card(
         child: ListTile(
           subtitle: Text(
               userProvider.usermodel!.myCollection.length.toString()),
           title: const Text("Koleksiyon Syısı"),
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