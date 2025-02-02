// placement_preparation_screen.dart
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
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
    return Scaffold(
      appBar: CustomAppBar(title: 'Placement Preparation'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _materialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(
                child: Text(
                    'Error fetching placement materials: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No placement materials found.'));
          final materials = snapshot.data!;
          for (var material in materials) {
            String id = material['id'];
            if (!globals.placementCompletion.containsKey(id)) {
              globals.placementCompletion[id] = false;
            }
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              var material = materials[index];
              String id = material['id'];
              bool isCompleted = globals.placementCompletion[id] ?? false;
              return NeumorphicContainer(
                padding: EdgeInsets.all(16),
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
      ),
    );
  }
}
