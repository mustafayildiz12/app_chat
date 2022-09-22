import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class StorageService {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<String> sendVoiceRecord({required String uid, required File recordFile}) async {
    String downloadURL = '';

    try {
      String path = '${DateTime.now().millisecondsSinceEpoch}${basename(recordFile.path)}';
      await storage
          .ref('voiceRecords/$uid')
          .child(path)
          .putFile(
              recordFile,
              firebase_storage.SettableMetadata(
                contentType: 'audio/mp4',
              ))
          .then((p0) async => downloadURL = await p0.ref.getDownloadURL());
    } catch (e) {
      debugPrint('e catched : $e');
    }
    return downloadURL;
  }
}
