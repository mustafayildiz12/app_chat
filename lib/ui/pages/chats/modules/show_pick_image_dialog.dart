part of '../chat_page.dart';
class _ShowPickImageDialog extends StatelessWidget {
  const _ShowPickImageDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Screen.height(context) * 80,
          width: Screen.width(context) * 100,
          child: Image.network(message.message),
        ),
        Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close)))
      ],
    );
  }
}

extension ImageChatDialogExtension on _ShowPickImageDialog {
  show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}