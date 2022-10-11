part of '../chat_page.dart';

class _MapPage extends StatelessWidget {
  const _MapPage({required this.lat, required this.lon});
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, lon), zoom: 14),
        markers: {
          Marker(
              markerId: const MarkerId('myLocation'),
              position: LatLng(lat, lon))
        },
      ),
    );
  }
}
