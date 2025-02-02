import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class PlacementPreparationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService().getPlacementMaterials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(
                  'Error fetching placement materials: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No placement materials found.'));
        }
        final materials = snapshot.data!;
        return ListView.builder(
          itemCount: materials.length,
          itemBuilder: (context, index) {
            var material = materials[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(material['title'] ?? ''),
                subtitle: Text(material['description'] ?? ''),
                onTap: () {
                  // Optionally, navigate to details or open the URL.
                },
              ),
            );
          },
        );
      },
    );
  }
}
