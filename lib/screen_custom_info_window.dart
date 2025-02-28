import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenCustomInfoWindow extends StatefulWidget {
  const ScreenCustomInfoWindow({super.key});

  @override
  State<ScreenCustomInfoWindow> createState() => _ScreenCustomInfoWindowState();
}

class _ScreenCustomInfoWindowState extends State<ScreenCustomInfoWindow> {
  LatLng myCurrentLocation = const LatLng(22.294188, 70.789927);
  final CustomInfoWindowController csInfoWindowController = CustomInfoWindowController();
  Set<Marker> marker = {};

  final List<LatLng> latLngPoints = [
    const LatLng(22.289813, 70.794422),
    const LatLng(22.294358, 70.815387),
  ];

  final List<String> locNames = ["Shree Ramkrishna Temple", "Shree Ramnath Mahadev"];

  final List<String> locImages = [
    "https://media-cdn.tripadvisor.com/media/photo-o/07/d9/05/6f/shri-ramakrishna-ashrama.jpg", // Shree Ramkrishna Temple
    "https://i.pinimg.com/originals/5a/13/e3/5a13e3408e63d6a7f79675e50054df94.jpg", // Shree Ramnath Mahadev
  ];

  @override
  void initState() {
    super.initState();
    displayInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            initialCameraPosition: CameraPosition(
              target: myCurrentLocation,
              zoom: 12,
            ),
            markers: marker,
            onMapCreated: (controller) {
              csInfoWindowController.googleMapController = controller;
            },
            onCameraIdle: () {
              csInfoWindowController.hideInfoWindow!();
            },
          ),
          CustomInfoWindow(
            controller: csInfoWindowController,
            height: 150,
            width: 250,
            offset: 40,
          ),
        ],
      ),
    );
  }

  void displayInfo() {
    for (int i = 0; i < latLngPoints.length; i++) {
      marker.add(
        Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: latLngPoints[i],
          onTap: () {
            csInfoWindowController.addInfoWindow!(
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0).copyWith(top: 2.0),
                      child: Image.network(
                        locImages[i],
                        height: 125,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      locNames[i],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              latLngPoints[i],
            );
          },
        ),
      );
      setState(() {});
    }
  }
}
