import 'package:app_chat/core/adapters/hive/hive_adapter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'firebase_options.dart';
import 'ui/pages/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  await Hive.initFlutter();

  HiveAdapters.init();

  runApp(const MyApp());
}
