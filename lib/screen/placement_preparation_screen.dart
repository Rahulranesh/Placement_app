import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';


class PlacementPreparationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getPlacementMaterials(department: currentDepartment),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return const Center(child: Text('Error fetching placement materials'));
        final materials = snapshot.data as List;
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
                  // Optionally, navigate to details.
                },
              ),
            );
          },
        );
      },
    );
  }
}
