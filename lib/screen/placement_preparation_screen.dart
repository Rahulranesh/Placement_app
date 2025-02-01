import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class PlacementPreparationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch placement preparation materials from Firestore.
    return FutureBuilder(
      future: DatabaseService().getPlacementMaterials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error fetching placement materials'));
        final materials = snapshot.data as List;
        return ListView.builder(
          itemCount: materials.length,
          itemBuilder: (context, index) {
            var material = materials[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(material['title'] ?? ''),
                subtitle: Text(material['description'] ?? ''),
                onTap: () {
                  // Optionally navigate to a detailed view.
                },
              ),
            );
          },
        );
      },
    );
  }
}
