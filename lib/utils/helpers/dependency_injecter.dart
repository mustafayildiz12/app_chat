import 'package:app_chat/core/provider/auth_provider.dart';
import 'package:app_chat/core/provider/bottom_navigation_provider.dart';
import 'package:app_chat/core/provider/chat_detail_provider.dart';
import 'package:app_chat/core/provider/image_provider.dart';
import 'package:app_chat/core/provider/register_provider.dart';
import 'package:app_chat/core/provider/splash_provider.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/core/provider/voice_record_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../core/provider/theme_provider.dart';

class DependencyInjector {
  static DependencyInjector? _instance;

  static DependencyInjector get instance {
    _instance ??= DependencyInjector._init();

    return _instance!;
  }

  late final SplashProvider splashProvider;
  late final VoiceRecordProvider voiceRecordProvider;
  late final RegisterProvider registerProvider;
  late final UploadImageProvider uploadImageProvider;
  late final UserProvider userProvider;
  late final ChatDetailProvider chatDetailProvider;
  late final AuthProvider authProvider;
  late final BottomNavigationProvider bottomNavigationProvider;
  late final DarkThemeProvider themeChangeProvider;

  DependencyInjector._init() {
    splashProvider = SplashProvider();
    voiceRecordProvider = VoiceRecordProvider();
    registerProvider = RegisterProvider();
    uploadImageProvider = UploadImageProvider();
    userProvider = UserProvider();
    chatDetailProvider = ChatDetailProvider();
    authProvider = AuthProvider();
    bottomNavigationProvider = BottomNavigationProvider();
 //   themeChangeProvider = DarkThemeProvider();
  }



  List<ChangeNotifierProvider<ChangeNotifier>> otherProviders = [
        ChangeNotifierProvider(create: (context) => SplashProvider()),
    ChangeNotifierProvider(create: (context) => VoiceRecordProvider()),
    ChangeNotifierProvider(create: (context) => RegisterProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => UploadImageProvider()),
    ChangeNotifierProvider(create: (context) => ChatDetailProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
  ];
}
