import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../service/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  bool inited = false;
  bool chatsGet = false;
  List chats = [];
  List<String> friendLikes = [];
  List<String> friendFollowers = [];

  Future<void> getChats(context) async {
    List chats = await ChatService().getMyChats();
    print(chats.length);
    chats = chats.map((e) => Chat.fromMap(e as Map)).toList();

    chatsGet = true;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
