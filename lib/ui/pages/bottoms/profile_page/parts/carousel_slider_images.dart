part of '../profile_page.dart';

class _CarouselSliderImages extends StatelessWidget {
  const _CarouselSliderImages({required this.userProvider, Key? key})
      : super(key: key);

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: userProvider.usermodel!.myCollection.length,
      options: CarouselOptions(autoPlay: true),
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          SizedBox(
        height: Screen.height(context) * 25,
        child: Image.file(
          File(userProvider.usermodel!.myCollection[itemIndex]),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
