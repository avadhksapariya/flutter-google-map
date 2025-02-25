import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenGoogleMapPolyline extends StatefulWidget {
  const ScreenGoogleMapPolyline({super.key});

  @override
  State<ScreenGoogleMapPolyline> createState() => _ScreenGoogleMapPolylineState();
}

class _ScreenGoogleMapPolylineState extends State<ScreenGoogleMapPolyline> {
  LatLng myCurrentLocation = const LatLng(22.294188, 70.789927);
  Set<Marker> marker = {};
  final Set<Polyline> polyline = {};

  List<LatLng> pointsOnMap = [
    const LatLng(22.294188, 70.789927),
    const LatLng(22.295024, 70.790904),
    const LatLng(22.298365, 70.791473),
    const LatLng(22.301931, 70.792069),
    const LatLng(22.302567, 70.796376),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < pointsOnMap.length; i++) {
      marker.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: pointsOnMap[i],
          infoWindow: const InfoWindow(
            title: "Route to RWorld",
            snippet: "From EmpiereTech",
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      setState(() {
        polyline.add(
          Polyline(
            polylineId: const PolylineId("Id"),
            points: pointsOnMap,
            color: Colors.blue,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 15,
        ),
        markers: marker,
        polylines: polyline,
      ),
    );
  }
}
