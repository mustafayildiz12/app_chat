import 'package:app_chat/core/adapters/hive/hive_adapter.dart';
import 'package:app_chat/core/provider/auth_provider.dart';
import 'package:app_chat/core/provider/chat_detail_provider.dart';
import 'package:app_chat/core/provider/image_provider.dart';
import 'package:app_chat/core/provider/register_provider.dart';
import 'package:app_chat/core/provider/splash_provider.dart';
import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/core/provider/voice_record_provider.dart';
import 'package:app_chat/ui/pages/splash.dart';
import 'package:app_chat/utils/helpers/theme_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'core/provider/bottom_navigation_provider.dart';
import 'core/provider/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  await Hive.initFlutter();

  HiveAdapters.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    initMessagingListener();
  }

  void initMessagingListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      print('Message data: ${message.data}');
    });
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeChangeProvider),
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => VoiceRecordProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UploadImageProvider()),
        ChangeNotifierProvider(create: (context) => ChatDetailProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme:
                ThemeStyles.themeData(themeChangeProvider.darkTheme, context),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
