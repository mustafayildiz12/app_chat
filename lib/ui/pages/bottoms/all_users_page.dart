import 'dart:collection';

import 'package:app_chat/core/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
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
  int itemsCount = 7;

  @override
  void initState() {
    super.initState();
    scrollControllerListener();
  }

  final ScrollController _scrollController = ScrollController();
  bool showBottomLoading = false;

  void scrollControllerListener() {
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >
            _scrollController.position.maxScrollExtent - 50) {
          setState(() {
            showBottomLoading = true;
          });
        } else {
          setState(() {
            showBottomLoading = false;
          });
        }
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          print('has reached the bottom');
          Future.delayed(Duration.zero).then((value) async {
            setState(() {
              itemsCount += 10;
              print('new itemsCount set to: $itemsCount');
              showBottomLoading = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.usermodel!.username),
        centerTitle: true,
      ),
      body: FutureBuilder<DataSnapshot>(
          future: FirebaseDatabase.instance
              .ref()
              .child('users')
              .limitToFirst(itemsCount)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DataSnapshot dataSnapshot = snapshot.data!;
              List<UserModel> users = [];

              if (dataSnapshot.value.runtimeType == List<Object?>) {
                users = (dataSnapshot.value as List)
                    .map((user) => UserModel.fromMap(user as Map))
                    .toList();
              } else {
                LinkedHashMap usersMap = dataSnapshot.value as LinkedHashMap;
                users = usersMap.entries
                    .map((e) => UserModel.fromMap(e.value as Map))
                    .toList();
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final data = users[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(data.email),
                        subtitle: Text(data.password),
                        leading: Text('$index'),
                        //   trailing: Text(data.uid),
                      ),
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
