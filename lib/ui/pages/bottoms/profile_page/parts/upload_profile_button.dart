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
              /*
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;

              final mainPath = "$tempPath/logo.png";

              await Dio().download(imageProvider.imageUrl, mainPath);

              final hiveUrl = CachedDomainHive();
              await hiveUrl.init();

              await hiveUrl.setValue(mainPath);
          
           */
              imageProvider.pickedFile = null;
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
