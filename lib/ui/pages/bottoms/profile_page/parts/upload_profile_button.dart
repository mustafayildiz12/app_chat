part of '../profile_page.dart';
class _UploadProfileButton extends StatelessWidget {
  const _UploadProfileButton({
    Key? key,
    required this.imageProvider,
    required this.userProvider,
  }) : super(key: key);

  final UploadImageProvider imageProvider;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: imageProvider.isProfileLoaded,
      child: TextButton(
          onPressed: () async {
            if (imageProvider.pickedFile != null) {
              imageProvider.isProfileLoading = true;
              imageProvider.notify();
              imageProvider.imagePath =
                  'images/${userProvider.usermodel!.email}/profileImage.png';

              await imageProvider.uploadFile(context);

              imageProvider.isProfileLoaded = false;
              imageProvider.isProfileLoading = false;
              imageProvider.notify();
            }
          },
          child: imageProvider.isProfileLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).errorColor,
                )
              : const Text("Save")),
    );
  }
}