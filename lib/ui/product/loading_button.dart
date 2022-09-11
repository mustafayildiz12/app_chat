import 'package:app_chat/core/class/screen_class.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);
  final String title;
  final Future<void> Function() onPressed;
  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  void changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Screen.height(context)*8,
      width: Screen.width(context)*90,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
         shape: const StadiumBorder()
        ),
        onPressed: () async {
          changeLoading();
          await widget.onPressed.call();
          changeLoading();
        },
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(widget.title),
      ),
    );
  }
}