import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenGoogleMap extends StatefulWidget {
  const ScreenGoogleMap({super.key});

  @override
  State<ScreenGoogleMap> createState() => _ScreenGoogleMapState();
}

class _ScreenGoogleMapState extends State<ScreenGoogleMap> {
  LatLng myCurrentLocation = const LatLng(22.301472, 70.826361);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: myCurrentLocation,
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("Marker Id"),
              position: myCurrentLocation,
              draggable: true,
              onDragEnd: (value) {},
              infoWindow: const InfoWindow(title: "MarkerTitle", snippet: "MarkerInfo."),
            ),
          }),
    );
  }
}
