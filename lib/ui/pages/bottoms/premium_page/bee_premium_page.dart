import 'package:flutter/material.dart';

class BeePremiumPage extends StatefulWidget {
  const BeePremiumPage({Key? key}) : super(key: key);

  @override
  State<BeePremiumPage> createState() => _BeePremiumPageState();
}

class _BeePremiumPageState extends State<BeePremiumPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Send Data'),
            ElevatedButton(
                onPressed: () async {
                  final before = DateTime.now();
                  setState(() {
                    isLoading = true;
                  });
               //   await DatabaseService().trySpeeds();
                  final after = DateTime.now();
                  setState(() {
                    isLoading = false;
                  });
                  print(after.difference(before).inSeconds);
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Upload'))
          ],
        ),
      ),
    );
  }
}
