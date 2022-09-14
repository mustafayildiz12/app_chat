import 'dart:collection';
import 'dart:convert';

import 'chat_user_model.dart';

class Chat {
  String chatID;
  List<ChatUser> users;
  List<ChatMessage> messages;
  bool anonym;

  Chat({
    required this.chatID,
    required this.users,
    required this.messages,
    required this.anonym,
  });

  ChatMessage lastMessage() {
    List<ChatMessage> allMessages = messages.map((e) => e).toList();
    allMessages.sort((a, b) => b.date.compareTo(a.date));
    return allMessages.first;
  }

  int unseenMessages(String myUID) {
    int unseen = 0;
    for (var message in messages) {
      if (!message.seen && message.senderUID != myUID) {
        unseen++;
      }
    }
    return unseen;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'chatID': chatID});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});
    result.addAll({'messages': messages.map((x) => x.toMap()).toList()});
    result.addAll({'anonym': anonym});

    return result;
  }

  factory Chat.fromMap(Map<dynamic, dynamic> map) {
    return Chat(
      chatID: map['chatID'] ?? '',
      users: List<ChatUser>.from(
          map['users']?.map((x) => ChatUser.fromMap(x as Map))),
      messages: (map['messages'] as LinkedHashMap)
          .entries
          .map((x) => ChatMessage.fromMap(x.value as Map))
          .toList(),
      anonym: map['anonym'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));
}

class ChatMessage {
  DateTime date;
  String id;
  String message;
  bool seen;
  String senderUID;

  ChatMessage({
    required this.date,
    required this.id,
    required this.message,
    required this.seen,
    required this.senderUID,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'date': date.toString()});
    result.addAll({'id': id});
    result.addAll({'message': message});
    result.addAll({'seen': seen});
    result.addAll({'senderUID': senderUID});

    return result;
  }

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      date: DateTime.parse(map['date']),
      id: map['id'] ?? '',
      message: map['message'] ?? '',
      seen: map['seen'] ?? false,
      senderUID: map['senderUID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));
}
