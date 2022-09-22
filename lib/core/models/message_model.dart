import 'dart:convert';

class Message {
  String message;
  String date;
  bool seen;
  String senderUID;
  String id;
 String type;
 // bool isVideo;
 // bool isVoice;
  Message({
    required this.message,
    required this.date,
    required this.seen,
    required this.senderUID,
    required this.id,
    required this.type
   
  });

  Message copyWith({
    String? message,
    String? date,
    bool? seen,
    String? senderUID,
    String? id,
    String? type,
  }) {
    return Message(
      message: message ?? this.message,
      date: date ?? this.date,
      seen: seen ?? this.seen,
      senderUID: senderUID ?? this.senderUID,
      id: id ?? this.id,
      type: type ?? this.type
   
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'message': message});
    result.addAll({'date': date});
    result.addAll({'seen': seen});
    result.addAll({'senderUID': senderUID});
    result.addAll({'id': id});
   

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] ?? '',
      date: map['date'] ?? '',
      seen: map['seen'] ?? false,
      senderUID: map['senderUID'] ?? '',
      id: map['id'] ?? '',
      type: map['type'] ?? ''
     
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(message: $message, date: $date, seen: $seen, senderUID: $senderUID, id: $id,type:$type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.message == message && 
    other.date == date && other.seen == seen && 
    other.senderUID == senderUID && other.type == type && other.id == id;
  }

  @override
  int get hashCode {
    return message.hashCode ^ date.hashCode ^
     seen.hashCode ^ senderUID.hashCode ^
     type.hashCode^
      id.hashCode;
  }
}
