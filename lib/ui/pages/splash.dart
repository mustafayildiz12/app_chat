import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SplashProvider splashProvider = Provider.of<SplashProvider>(context);

    splashProvider.init(context);

    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Icon(Icons.flutter_dash,size: 80,
          
          ),
        ),
      ),
    );
  }
}