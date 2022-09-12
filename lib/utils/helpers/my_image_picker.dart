import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker {
  static Future<File?> pick(context) async {
    final ImagePicker imagePicker = ImagePicker();
    late XFile? image;

    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Resim yükle'),
        children: [
          ListTile(
            onTap: () async {
              image = await imagePicker.pickImage(source: ImageSource.gallery);
              Navigator.pop(context);
            },
            title: const Text('Galeri'),
          ),
          ListTile(
            onTap: () async {
              image = await imagePicker.pickImage(source: ImageSource.camera);

              Navigator.pop(context);
            },
            title: const Text('Kamera'),
          ),
        ],
      ),
    );

    return image is XFile ? File(image!.path) : null;
  }

  static Future<dynamic> pickWithMultiOption(context) async {
    final ImagePicker imagePicker = ImagePicker();
    dynamic result;

    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Resim yükle'),
        children: [
          ListTile(
            onTap: () async {
              result = await imagePicker.pickMultiImage();
              Navigator.pop(context);
            },
            title: const Text('Çoklu Galeri'),
          ),
          ListTile(
            onTap: () async {
              result = await imagePicker.pickImage(source: ImageSource.gallery);
              Navigator.pop(context);
            },
            title: const Text('Galeri'),
          ),
          ListTile(
            onTap: () async {
              result = await imagePicker.pickImage(source: ImageSource.camera);

              Navigator.pop(context);
            },
            title: const Text('Kamera'),
          ),
        ],
      ),
    );
    if (result == null) {
      return null;
    }

    return result is XFile
        ? File(result.path)
        : result is List
            ? result.map((element) => File(element.path)).toList()
            : null;
  }

/*
  static Future<File?> takePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.camera);
      if (selectedImage == null) {
        return null;
      }
      final File image = File(selectedImage.path);
      final sizeInKbBeforeCompress = image.lengthSync() / 1024;
      debugPrint("before compressed size : {$sizeInKbBeforeCompress}Kb");

      final File compressedImage = await FlutterNativeImage.compressImage(
        image.absolute.path,
      );
      final sizeInKbAfterCompress = compressedImage.lengthSync() / 1024;
      debugPrint("after compress size : {$sizeInKbAfterCompress}Kb");
      return compressedImage;
    } catch (e) {
      debugPrint("İmage Picker Exception $e");
      return null;
    }
  }
 */

  static Future<File?> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImage == null) {
        return null;
      }
      final File image = File(selectedImage.path);
      final sizeInKbBeforeCompress = image.lengthSync() / 1024;
      debugPrint("before compressed size : {$sizeInKbBeforeCompress}Kb");

      final File compressedImage = await FlutterNativeImage.compressImage(
        image.absolute.path,
      );
      final sizeInKbAfterCompress = compressedImage.lengthSync() / 1024;
      debugPrint("after compress size : {$sizeInKbAfterCompress}Kb");
      return compressedImage;
    } catch (e) {
      debugPrint("İmage Picker Exception $e");
      return null;
    }
  }

/*
  static Future<File?> pickVideo() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? selectedImage = await imagePicker.pickVideo(source: ImageSource.gallery);
      if (selectedImage == null) {
        return null;
      }
      final File video = File(selectedImage.path);
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(selectedImage.path);
      if (mediaInfo != null) {
        return mediaInfo.file;
      }
      return video;
    } catch (e) {
      debugPrint("İmage Picker Exception $e");
      return null;
    }
  }
 */
}