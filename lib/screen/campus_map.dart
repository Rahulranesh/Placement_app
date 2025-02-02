// campus_map.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:place/utils/custom_appbar.dart';

class CampusMap extends StatefulWidget {
  @override
  _CampusMapState createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  GoogleMapController? _controller;
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(18.5204, 73.8567),
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Campus Map'),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        myLocationEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
