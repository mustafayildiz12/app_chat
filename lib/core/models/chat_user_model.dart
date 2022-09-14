import 'dart:convert';

class ChatUser {
  String uid;
  String username;
  String profilePicture;
  bool? starter;
  String? token;
  String? biography;

  ChatUser({
    required this.uid,
    required this.username,
    required this.profilePicture,
    this.starter,
    this.biography,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'profilePicture': profilePicture});
    result.addAll({'starter': starter});

    result.addAll({'token': token});
    result.addAll({'biography':biography});

    return result;
  }

  factory ChatUser.fromMap(Map<dynamic, dynamic> map) {
    return ChatUser(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      starter: map['starter'] ?? false,
      token: map['token'],
      biography: map['biography'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) => ChatUser.fromMap(json.decode(source));
}
