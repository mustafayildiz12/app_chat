import 'dart:convert';

class Message {
  String message;
  String date;
  bool seen;
  String senderUID;
  String id;
  bool isImage;
  bool isVideo;
  bool isVoice;
  Message({
    required this.message,
    required this.date,
    required this.seen,
    required this.senderUID,
    required this.id,
    required this.isImage,
    required this.isVideo,
    required this.isVoice,
  });

  Message copyWith({
    String? message,
    String? date,
    bool? seen,
    String? senderUID,
    String? id,
  }) {
    return Message(
      message: message ?? this.message,
      date: date ?? this.date,
      seen: seen ?? this.seen,
      senderUID: senderUID ?? this.senderUID,
      id: id ?? this.id,
      isImage: isImage,
      isVideo: isVideo,
      isVoice: isVoice,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'message': message});
    result.addAll({'date': date});
    result.addAll({'seen': seen});
    result.addAll({'senderUID': senderUID});
    result.addAll({'id': id});
    result.addAll({'isImage': isImage});
    result.addAll({'isVideo': isVideo});
    result.addAll({'isVoice': isVoice});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] ?? '',
      date: map['date'] ?? '',
      seen: map['seen'] ?? false,
      senderUID: map['senderUID'] ?? '',
      id: map['id'] ?? '',
      isImage: map['isImage'] ?? false,
      isVideo: map['isVideo'] ?? false,
      isVoice: map['isVoice'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(message: $message, date: $date, seen: $seen, senderUID: $senderUID, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.message == message && other.date == date && other.seen == seen && other.senderUID == senderUID && other.id == id;
  }

  @override
  int get hashCode {
    return message.hashCode ^ date.hashCode ^ seen.hashCode ^ senderUID.hashCode ^ id.hashCode;
  }
}
