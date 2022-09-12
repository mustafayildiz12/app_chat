import 'dart:convert';

class UserModel {
  final String uid;
  final String username;

   String email;
   String? profileImage;

   String password;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    this.profileImage
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? password,
    String? profileImage
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'username': username});

    result.addAll({'email': email});

    result.addAll({'password': password});
    result.addAll({'profileImage':profileImage});

    return result;
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profileImage: map['profileImage'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, email: $email, password: $password,profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.password == password;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        password.hashCode;
  }
}
