import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/core/repostiroy/user_repository.dart';
import 'package:app_chat/core/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_model.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage>
    with SingleTickerProviderStateMixin {
  late final Future<List<UserModel>>? _allUsersFuture;

  @override
  void initState() {
    _allUsersFuture = DatabaseService().getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.usermodel!.username),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        UserService().logout(context);
      }),
      body: FutureBuilder(
          future: _allUsersFuture,
          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(data.email),
                      subtitle: Text(data.password),
                      //   trailing: Text(data.uid),
                    ),
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
