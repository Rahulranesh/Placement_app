import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CampusMap extends StatefulWidget {
  @override
  _CampusMapState createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  GoogleMapController? _controller;

  // Set initial camera position to your college’s location.
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(18.5204,
        73.8567), // Example coordinates – update with your college's coordinates.
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        // Enable user gestures to move the camera.
        myLocationEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
