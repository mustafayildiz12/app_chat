part of '../chat_page.dart';

class MapImageThumbnail extends StatelessWidget {
  const MapImageThumbnail({
    Key? key,
    required this.lat,
    required this.long,
  }) : super(key: key);

  final double lat;
  final double long;

  String get _constructUrl => Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {
          'center': '$lat,$long',
          'zoom': '18',
          'size': '700x500',
          'maptype': 'roadmap',
          'key': 'AIzaSyCj1r_0PbZgE4z_Uk6uEZQAJiHXdM0Jr9c',
          'markers': 'color:red|$lat,$long'
        },
      ).toString();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _constructUrl,
      height: 100.0,
      width: 200.0,
      fit: BoxFit.fill,
    );
  }
}