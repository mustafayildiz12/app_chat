import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../provider/user_provider.dart';
import '../repostiroy/user_repository.dart';

class ChatService {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> sendMessage(
    BuildContext context, {
   required String chatID,
    required UserModel chatUser,
    required String message,
 //   required void Function(String chatID) onNewChatID,
    //   bool isImage = false,
    //   bool isVideo = false,
    //   bool isVoice = false,
  }) async {
    UserModel userModel =
        Provider.of<UserProvider>(context, listen: false).usermodel!;
   

    
      await FirebaseDatabase.instance
          .ref('users')
          .child(userModel.uid)
          .child('chats')
          .push()
          .set(chatID);
      await FirebaseDatabase.instance
          .ref('users')
          .child(chatUser.uid)
          .child('chats')
          .push()
          .set(chatID);

     
      await database.ref('chats').child(chatID).update({
        'chatID': chatID,
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
        'anonym': true,
      });
    //  onNewChatID(newChatID);
    

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await database.ref('chats').child(chatID).child('messages').child(id).set({
      'message': message,
     // 'isImage': isImage,
     // 'isVideo': isVideo,
     // 'isVoice': isVoice,
      'date': DateTime.now().toString(),
      'senderUID': userModel.uid,
      'seen': false,
      'id': id,
    });

    //  UserModel? userModel = await DatabaseService().getUser(chatUser.uid);

    /*
    await NotificationService().sendNotification(
      recieverToken: userModel != null && userModel.token != null ? userModel.token! : chatUser.token!,
      title: userModel.username,
      body: message,
      senderName: userModel.username,
      senderProfilePictureUrl: userModel.profileImage,
    );
    */
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
