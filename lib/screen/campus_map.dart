/*import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart'; // Make sure this package is added in pubspec.yaml

// The LatLng class is provided by the package
final LatLng gctCampusPosition = LatLng(11.018208, 76.936011);

class CampusInsideView extends StatefulWidget {
  @override
  _CampusInsideViewState createState() => _CampusInsid/*  */eViewState();
}

class _CampusInsideViewState extends State<CampusInsideView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campus Inside View"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // The GoogleStreetView widget shows a panoramic Street View image.
          GoogleStreetView(
            // Use the coordinates for Government College of Technology, Coimbatore.
            initialPosition: gctCampusPosition,
            // Optionally adjust heading, pitch, and zoom to best show the inside view.
            initialHeading: 150,
            initialPitch: 0,
            initialZoom: 1.0,
            onStreetViewCreated: (GoogleStreetViewController controller) {
              // Once the view is created, hide the loading spinner.
              setState(() {
                _isLoading = false;
              });
            },
            onError: (error) {
              // Print any error encountered.
              print("Google Street View error: $error");
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}*/