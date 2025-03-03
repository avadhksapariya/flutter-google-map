import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_map/screen_custom_info_window.dart';
import 'package:flutter_google_map/screen_google_map_polygon.dart';
import 'package:flutter_google_map/screen_google_map_polyline.dart';
import 'package:geocoding/geocoding.dart';
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
  bool showOptions = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    googleMapController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
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
          Positioned(
            top: 40,
            right: 8,
            left: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      final location = searchController.text.trim();
                      if (location.isNotEmpty) {
                        searchPlace(location);
                      }
                    },
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: showOptions,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: FloatingActionButton.small(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScreenGoogleMapPolyline(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.polyline,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: FloatingActionButton.small(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScreenGoogleMapPolygon(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.crop_square,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: FloatingActionButton.small(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScreenCustomInfoWindow(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.window,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                  child: FloatingActionButton(
                    foregroundColor: Colors.red.shade700,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      searchController.clear();

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
                ),
              ],
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              toggleOptions();
            },
            child: showOptions ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
          ),
        ],
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

  Future<void> searchPlace(String place) async {
    try {
      List<Location> locations = await locationFromAddress(place);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLatLng = LatLng(location.latitude, location.longitude);

        // Move the map camera to the searched location
        googleMapController.animateCamera(CameraUpdate.newLatLng(searchedLatLng));

        // Add the marker on searched place
        marker.clear();
        marker.add(
          Marker(
            markerId: const MarkerId("searchedPlace"),
            position: searchedLatLng,
            infoWindow: InfoWindow(title: place, snippet: "Lat: ${location.latitude}, Lng: ${location.longitude}"),
          ),
        );

        setState(() {});
      } else {
        log("Could not find the place.");
        return;
      }
    } catch (e) {
      log("Error finding place: $e");
    }
  }

  void toggleOptions() {
    setState(() {
      showOptions = !showOptions;
    });
  }
}
