import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationService {
  Future<void> sendMessageNotification({
    required String recieverToken,
    required String title,
    required String body,
    required String senderName,
    required String? senderProfilePictureUrl,
    required String chatId,
    required String type,
  }) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    String key =
        'AAAAkG8AZUw:APA91bEz78b8xuC1LVyeN4s3Url1jeTbyzDvUEbWOj8CRr39N3CLH3eo0eu2pp_tNWT7mkMPTu7ijPw2GnFTZ6iqGfk_iu7huQfSQRkeY1LqNXswq5wOTmzQH4iMdW4f2-5mcPan0ElB';

    Map<String, String>? headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$key',
    };

    String messageBody = body;
    if (body.contains('.com')) {
      messageBody = 'Medya';
    }

    Map requestBody = {
      "to": recieverToken,
      "notification": {
        "title": title,
        "body": messageBody,
        "mutable_content": true,
      },
      "data": {
        "type": type,
        "title": title,
        "body": body,
        "senderName": senderName,
        "senderProfilePictureUrl": senderProfilePictureUrl,
        "chatID": chatId,
      }
    };

    await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('notif sent to $recieverToken');
  }
}
