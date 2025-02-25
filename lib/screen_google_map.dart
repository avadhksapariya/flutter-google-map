import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenGoogleMap extends StatefulWidget {
  const ScreenGoogleMap({super.key});

  @override
  State<ScreenGoogleMap> createState() => _ScreenGoogleMapState();
}

class _ScreenGoogleMapState extends State<ScreenGoogleMap> {
  LatLng myCurrentLocation = const LatLng(22.301472, 70.826361);
  late GoogleMapController googleMapController;
  Set<Marker> marker = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 15,
        ),
        markers: marker,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        /*markers: {
          Marker(
            markerId: const MarkerId("Marker Id"),
            position: myCurrentLocation,
            draggable: true,
            onDragEnd: (value) {},
            infoWindow: const InfoWindow(title: "MarkerTitle", snippet: "MarkerInfo."),
            // icon: customIcon, // disabled due to too big asset, if needed define customMarker() in initState
          ),
        },*/
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Position position = await currentPosition();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 15,
              ),
            ),
          );
          marker.clear();
          marker.add(
            Marker(
              markerId: const MarkerId("Here I am!"),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: const InfoWindow(title: "Hi !", snippet: "You are here."),
            ),
          );
          setState(() {});
        },
        child: const Icon(
          Icons.my_location,
        ),
      ),
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

  Future<Position> currentPosition() async {
    bool serviceEnable;
    LocationPermission locPermission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      log(Future.error("Location service is disabled.").toString());

      locPermission = await Geolocator.checkPermission();
      if (locPermission == LocationPermission.denied) {
        locPermission = await Geolocator.requestPermission();
        if (locPermission == LocationPermission.denied) {
          return Future.error("Location permission denied.");
        }
      }

      if (locPermission == LocationPermission.deniedForever) {
        return Future.error("Location permission denied permanently.");
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
