import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  String username;

  String email;
  String? profileImage;
  List myFollowers;
  String password;
  List myCollection = List.empty(growable: true);

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.password,
      required this.myFollowers,
      required this.myCollection,
      this.profileImage});

  UserModel copyWith(
      {String? uid,
      String? username,
      String? email,
      String? password,
      List? myFollowers,
      List? myCollection,
      String? profileImage}) {
    return UserModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        myFollowers: myFollowers ?? this.myFollowers,
        email: email ?? this.email,
        password: password ?? this.password,
        myCollection: myCollection ?? this.myCollection,
        profileImage: profileImage ?? this.profileImage);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'username': username});

    result.addAll({'email': email});

    result.addAll({'password': password});
    result.addAll({'profileImage': profileImage});
    result.addAll({'myFollowers': myFollowers});
    result.addAll({'myCollection': myCollection});

    return result;
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
        myFollowers: map['myFollowers'] ?? [],
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        myCollection: map['myCollection'] ?? [],
        profileImage: map['profileImage'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.profileImage == profileImage &&
        listEquals(other.myFollowers, myFollowers) &&
        //    listEquals(other.myCollection, myCollection) &&
        other.password == password;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        email.hashCode ^
        myFollowers.hashCode ^
        profileImage.hashCode ^
        //    myCollection.hashCode ^
        password.hashCode;
  }
}
