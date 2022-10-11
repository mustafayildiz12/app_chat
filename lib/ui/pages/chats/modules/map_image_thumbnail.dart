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
          'key': 'AIzaSyCpX-w04XMAIaGd61gqPzEtakmXdScB-bM',
          'markers': 'color:red|$lat,$long'
        },
      ).toString();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _constructUrl,
      height:Screen.height(context) * 40,
      width:Screen.width(context) * 50,
      fit: BoxFit.fill,
    );
  }
}