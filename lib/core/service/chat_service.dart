import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../provider/user_provider.dart';
import '../repostiroy/user_repository.dart';
import 'notification_service.dart';

class ChatService {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> sendMessage(
    BuildContext context, {
    required String chatID,
    required UserModel chatUser,
    required String message,
    //   required void Function(String chatID) onNewChatID,
    required String type,
    //   bool isVoice = false,
  }) async {
    UserModel userModel =
        Provider.of<UserProvider>(context, listen: false).usermodel!;

    await database.ref('chats').child(userModel.uid + chatUser.uid).update({
      'chatID': userModel.uid + chatUser.uid,
      'lastMessage': message,
      'users': [
        {
          'uid': userModel.uid,
          'username': userModel.username,
          'profilePicture': userModel.profileImage,
          'starter': true,
        },
        {
          'uid': chatUser.uid,
          'username': chatUser.username,
          'profilePicture': chatUser.profileImage,
          'starter': false,
        },
      ],
      //  'anonym': true,
    });

    await database.ref('chats').child(chatUser.uid + userModel.uid).update({
      'chatID': chatUser.uid + userModel.uid,
      'lastMessage': message,
      'users': [
        {
          'uid': chatUser.uid,
          'username': chatUser.username,
          'profilePicture': chatUser.profileImage,
          'starter': false,
        },
        {
          'uid': userModel.uid,
          'username': userModel.username,
          'profilePicture': userModel.profileImage,
          'starter': true,
        },
      ],
      //  'anonym': true,
    });

    //  onNewChatID(newChatID);

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await database
        .ref('chats')
        .child(userModel.uid + chatUser.uid)
        .child('messages')
        .child(id)
        .set({
      'message': message,
      'date': DateTime.now().toString(),
      'senderUID': userModel.uid,
      'seen': false,
      'id': id,
      'type': type,
    });

    await database
        .ref('chats')
        .child(chatUser.uid + userModel.uid)
        .child('messages')
        .child(id)
        .set({
      'message': message,
      'date': DateTime.now().toString(),
      'senderUID': userModel.uid,
      'seen': false,
      'id': id,
      'type': type,
    });

    //  UserModel? userModel = await DatabaseService().getUser(chatUser.uid);

    await NotificationService().sendMessageNotification(
      recieverToken:
          userModel.token != null ? userModel.token! : chatUser.token!,
      title: userModel.username,
      body: message,
      type: 'text',
      senderName: userModel.username,
      senderProfilePictureUrl: userModel.profileImage,
      chatId: userModel.uid + chatUser.uid,
    );
  }

  Future<List> getMyChats() async {
    List chatIDs = [];
    List chats = [];

    String myUID = UserService().getCurrentUser()!.uid;
    DatabaseEvent databaseEvent =
        await database.ref('users').child(myUID).once();
    if (databaseEvent.snapshot.exists) {
      chatIDs = (databaseEvent.snapshot.value as Map)['chats'] != null
          ? (databaseEvent.snapshot.value as Map)['chats'].values.toList()
          : [];
      for (var element in chatIDs) {
        DatabaseEvent databaseEvent =
            await database.ref('chats').child(element).once();
        if (databaseEvent.snapshot.exists) {
          chats.add(databaseEvent.snapshot.value);
        }
      }
    }
    return chats;
  }
}
