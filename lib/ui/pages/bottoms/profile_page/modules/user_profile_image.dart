part of '../profile_page.dart';

class _UserProfileImage extends StatelessWidget {
  const _UserProfileImage(
      {required this.imageProvider, required this.userProvider, Key? key})
      : super(key: key);

  final UserProvider userProvider;
  final UploadImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        imageProvider.pickedFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.file(
                  imageProvider.pickedFile!,
                  height: Screen.width(context) * 50,
                  width: Screen.width(context) * 50,
                  fit: BoxFit.cover,
                ),
              )
            : userProvider.usermodel!.profileImagePath != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      File(userProvider.usermodel!.profileImagePath!),
                      height: Screen.width(context) * 50,
                      width: Screen.width(context) * 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    radius: Screen.width(context) * 25,
                    backgroundColor: Colors.amber,
                  ),
        Positioned(
          bottom: -Screen.height(context) * 1,
          right: Screen.width(context) * 5,
          child: IconButton(
              onPressed: () async {
                await imageProvider.selectImage();
                imageProvider.isProfileLoaded = true;
                imageProvider.notify();
              },
              icon: const Icon(
                Icons.photo_camera,
                color: Colors.blue,
                size: 32,
              )),
        )
      ],
    );
  }
}
