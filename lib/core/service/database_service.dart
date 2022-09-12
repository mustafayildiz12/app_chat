import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repostiroy/user_repository.dart';

class DatabaseService {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<void> createAccount(UserModel userModel) async {
    await firebaseDatabase
        .ref()
        .child('users')
        .child(userModel.uid)
        .set(
          userModel.toMap(),
        )
        .catchError((error) => debugPrint('error : $error'));
  }

  Future<void> saveUsernames(String username, String uid) async {
    await firebaseDatabase
        .ref()
        .child('usernames')
        .child(username)
        .set({'username': username}).catchError(
            (error) => debugPrint('error : $error'));
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];

    DatabaseEvent databaseEvent =
        await firebaseDatabase.ref().child('users').once();

    if (databaseEvent.snapshot.exists) {
      if (databaseEvent.snapshot.value != null) {
        var linkedhsmap = databaseEvent.snapshot.value as LinkedHashMap;

        (linkedhsmap.entries.toList()).map((e) {
          if (e.value != null) {
            return users.add(UserModel.fromMap(e.value as Map));
          }
        }).toList();
      }
    }

    User? user = UserService().getCurrentUser();
    if (user != null) {
      users.removeWhere((element) => element.uid == user.uid);
    }

    return users;
  }

  Future<List<UserModel>> getUsers(int count) async {
    List<UserModel> users = [];
    try {
      DatabaseEvent databaseEvent;

      databaseEvent = await firebaseDatabase
          .ref()
          .child('users')
          // .orderByChild('showInShake')
          // .equalTo(true)
          .orderByChild('gender')
          .limitToFirst(count)
          .once();

      if (databaseEvent.snapshot.exists) {
        if (databaseEvent.snapshot.value != null) {
          var linkedhsmap = databaseEvent.snapshot.value as LinkedHashMap;

          (linkedhsmap.entries.toList()).map((e) {
            if (e.value != null) {
              return users.add(UserModel.fromMap(e.value as Map));
            }
          }).toList();
        }
      }

      User? user = UserService().getCurrentUser();
      if (user != null) {
        users.removeWhere((element) => element.uid == user.uid);
      }
    } catch (e) {
      print('e : $e');
    }
    return users;
  }

  Future<UserModel?> getUser(String uid) async {
    DataSnapshot dataSnapshot =
        await firebaseDatabase.ref().child('users').child(uid).get();
    if (dataSnapshot.exists) {
      Map data = dataSnapshot.value as Map;
      data['key'] = dataSnapshot.key;
      UserModel newUser = UserModel.fromMap(data);
      return newUser;
    }
    return null;
  }

  Stream chatStream(String chatID) {
    return firebaseDatabase.ref('chats').child(chatID).onValue;
  }
/*

  Future<Chat?> getChat(String chatID) async {
    DatabaseEvent databaseEvent = await firebaseDatabase.ref('chats').child(chatID).once();
    if (databaseEvent.snapshot.exists) {
      return Chat.fromMap(databaseEvent.snapshot.value as Map);
    }
    return null;
  }
 */

  /*
  Future<void> setSeen(Message message, String chatID) async {
    await firebaseDatabase.ref('chats').child('${chatID}').child('messages').child(message.id).update({
      'seen': true,
    });
  }

  Future<void> removeAnonym(String chatID) async {
    await firebaseDatabase.ref('chats').child(chatID).update({
      'anonym': false,
    });
  }

  Future<void> updateToken(String uid, String token) async {
    await firebaseDatabase.ref().child('users').child(uid).update({
      'token': token,
    });
  }

  Future<void> updateLastLogin(String uid) async {
    await firebaseDatabase.ref().child('users').child(uid).update(
      {'lastLogin': DateTime.now().toString()},
    );
  }

  Stream<DatabaseEvent> userStream(String uid) {
    return firebaseDatabase.ref().child('users').child(uid).onValue;
  }

  Future<void> sendAdvice(String advice, UserModel user) async {
    await firebaseDatabase.ref().child('advices').push().set({
      'advice': advice,
      'user': {
        'uid': user.uid,
        'username': user.username,
        'photoURL': user.profilePicture,
        'phoneNumber': user.phoneNumber,
      },
    });
  }
   */
}
