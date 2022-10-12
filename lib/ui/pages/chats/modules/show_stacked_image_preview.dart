part of '../chat_page.dart';

class _ShowStackedImagePreview extends StatelessWidget {
  const _ShowStackedImagePreview({
    Key? key,
    required this.chatDetailProvider,
  }) : super(key: key);

  final ChatDetailProvider chatDetailProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          chatDetailProvider.pickedFile!,
          height: Screen.width(context) * 50,
          width: Screen.width(context) * 50,
          fit: BoxFit.cover,
        ),
        Positioned(
            top: 1,
            right: 3,
            child: GestureDetector(
              onTap: () {
                chatDetailProvider.pickedFile = null;
                chatDetailProvider.notify();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: const Icon(Icons.close_sharp),
              ),
            ))
      ],
    );
  }
}