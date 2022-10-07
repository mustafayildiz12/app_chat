import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/provider/theme_provider.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/image_provider.dart';
import '../../../../core/repostiroy/user_repository.dart';
import 'user_image_collection.dart';

part 'modules/update_username_dialog.dart';
part 'modules/carousel_slider_images.dart';
part 'modules/user_profile_image.dart';
part 'modules/user_profile_info.dart';
part 'modules/upload_profile_button.dart';
part 'modules/profile_popup_menu.dart';
part 'modules/update_bio_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    UploadImageProvider imageProvider =
        Provider.of<UploadImageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          _ProfilePopupMenu(
              userProvider: userProvider, themeChange: themeChange)
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Screen.height(context) * 3,
              ),
              _UserProfileImage(
                userProvider: userProvider,
                imageProvider: imageProvider,
              ),
              SizedBox(
                height: Screen.height(context) * 3,
              ),
              _UploadProfileButton(
                  imageProvider: imageProvider, userProvider: userProvider),
              _UserProfileInfo(userProvider: userProvider),
              if (userProvider.usermodel!.myCollection.isNotEmpty)
                _CarouselSliderImages(
                  userProvider: userProvider,
                )
              else
                const Text('Your Collection is empty'),
            ],
          ),
        ),
      ),
    );
  }
}

extension SettingsDialogExtension on _UpdateUserNameDialog {
  show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}
