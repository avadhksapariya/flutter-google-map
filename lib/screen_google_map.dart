import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenGoogleMap extends StatefulWidget {
  const ScreenGoogleMap({super.key});

  @override
  State<ScreenGoogleMap> createState() => _ScreenGoogleMapState();
}

class _ScreenGoogleMapState extends State<ScreenGoogleMap> {
  LatLng myCurrentLocation = const LatLng(22.301472, 70.826361);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

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
              // icon: customIcon, // disabled due to too big asset, if needed define customMarker() in initState
            ),
          }),
    );
  }

  void customMarker() {
    // marker icon asset should be small enough to be displayed nicely. 64*64 or so.
    BitmapDescriptor.asset(const ImageConfiguration(), "assets/images/marker2.png").then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }
}
