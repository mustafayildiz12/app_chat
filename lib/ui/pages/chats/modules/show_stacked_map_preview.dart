part of '../chat_page.dart';

class _ShowStackedMapPreview extends StatelessWidget {
  const _ShowStackedMapPreview({
    Key? key,
    required this.chatDetailProvider,
    required this.getDetails,
    required this.userProvider,
  }) : super(key: key);

  final ChatDetailProvider chatDetailProvider;
  final UserModel getDetails;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: MapImageThumbnail(
            lat: chatDetailProvider.locationData!.latitude!,
            long: chatDetailProvider.locationData!.longitude!,
          ),
        ),
        Positioned(
          top: 1,
          right: 3,
          child: GestureDetector(
            onTap: () {
              chatDetailProvider.isMapReadyToSend = false;
              chatDetailProvider.notify();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor),
              child: const Icon(Icons.close_sharp),
            ),
          ),
        ),
        Positioned(
          bottom: 3,
          right: 3,
          child: GestureDetector(
            onTap: () async {
              final locationData =
                  await chatDetailProvider.location.getLocation();

              // ignore: use_build_context_synchronously
              await ChatService().sendMessage(context,
                  chatUser: getDetails,
                  message: chatDetailProvider.chatController.text,
                  type: 'location',
                  lat: locationData.latitude,
                  lon: locationData.longitude,
                  chatID: '${userProvider.usermodel!.uid}${getDetails.uid}');
              chatDetailProvider.isMapReadyToSend = false;
              chatDetailProvider.notify();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor),
              child: const Icon(Icons.send_outlined),
            ),
          ),
        ),
      ],
    );
  }
}