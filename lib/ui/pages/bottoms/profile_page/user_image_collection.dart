import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/image_provider.dart';

class UserImageCollection extends StatefulWidget {
  const UserImageCollection({Key? key}) : super(key: key);

  @override
  State<UserImageCollection> createState() => _UserImageCollectionState();
}

class _UserImageCollectionState extends State<UserImageCollection> {
  @override
  Widget build(BuildContext context) {
    UploadImageProvider imageProvider =
        Provider.of<UploadImageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: imageProvider.imageFileList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                          File(imageProvider.imageFileList![index].path),
                          height: Screen.height(context) * 20,
                          fit: BoxFit.fitHeight));
                }),
          )),
          TextButton(
              onPressed: () {
                imageProvider.selectImages();
              },
              child: const Text("Add Image")),
          SizedBox(height: Screen.height(context) * 10),
          Visibility(
            visible: imageProvider.imageFileList!.isNotEmpty,
            child: ElevatedButton(
                onPressed: () {
                  imageProvider.uploadSelectedImagesToFirebase(context);
                },
                child: imageProvider.isCollectionLoaded
                    ? CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      )
                    : const Text('Save Changes')),
          ),
          SizedBox(height: Screen.height(context) * 2),
        ],
      ),
    );
  }
}
