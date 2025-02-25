import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenGoogleMapPolygon extends StatefulWidget {
  const ScreenGoogleMapPolygon({super.key});

  @override
  State<ScreenGoogleMapPolygon> createState() => _ScreenGoogleMapPolygonState();
}

class _ScreenGoogleMapPolygonState extends State<ScreenGoogleMapPolygon> {
  LatLng myCurrentLocation = const LatLng(22.294188, 70.789927);
  final Completer<GoogleMapController> gmCompleter = Completer();
  Set<Marker> marker = {};
  Set<Polygon> polygon = HashSet<Polygon>();
  List<LatLng> points = [
    const LatLng(22.294188, 70.789927),
    const LatLng(22.298365, 70.791473),
    const LatLng(22.301931, 70.792069),
    const LatLng(22.302567, 70.796376),
    const LatLng(22.294188, 70.789927), // Should be same as Starting to create polygon
  ];

  @override
  void initState() {
    super.initState();
    addPolygon();
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
        polygons: polygon,
        onMapCreated: (GoogleMapController controller) {
          gmCompleter.complete(controller);
        },
      ),
    );
  }

  void addPolygon() {
    polygon.add(
      Polygon(
        polygonId: const PolygonId("Id"),
        points: points,
        strokeColor: Colors.blueAccent,
        strokeWidth: 2,
        fillColor: Colors.green.withOpacity(0.1),
        geodesic: true,
      ),
    );
  }
}
