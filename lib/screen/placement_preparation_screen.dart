import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/globals.dart' as globals;

class PlacementPreparationScreen extends StatefulWidget {
  @override
  _PlacementPreparationScreenState createState() =>
      _PlacementPreparationScreenState();
}

class _PlacementPreparationScreenState
    extends State<PlacementPreparationScreen> {
  late Future<List<Map<String, dynamic>>> _materialsFuture;

  @override
  void initState() {
    super.initState();
    _materialsFuture = DatabaseService().getPlacementMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _materialsFuture,
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
        // Initialize the global map for each material if not already set.
        for (var material in materials) {
          String id = material['id'];
          if (!globals.placementCompletion.containsKey(id)) {
            globals.placementCompletion[id] = false;
          }
        }
        return ListView.builder(
          itemCount: materials.length,
          itemBuilder: (context, index) {
            var material = materials[index];
            String id = material['id'];
            bool isCompleted = globals.placementCompletion[id] ?? false;
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                title: Text(material['title'] ?? ''),
                subtitle: Text(material['description'] ?? ''),
                value: isCompleted,
                onChanged: (bool? newValue) {
                  setState(() {
                    globals.placementCompletion[id] = newValue ?? false;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
