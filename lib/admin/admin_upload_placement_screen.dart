import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class AdminUploadPlacementScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadPlacementScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadPlacementScreenState createState() =>
      _AdminUploadPlacementScreenState();
}

class _AdminUploadPlacementScreenState
    extends State<AdminUploadPlacementScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String materialUrl = ''; // URL for the resource (document/video, etc.)

  Future<void> _uploadMaterial() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addPlacementMaterial(
          materialData: {
            'title': title,
            'description': description,
            'materialUrl': materialUrl,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Material uploaded successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading material: $e")),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getMaterials() async {
    return await DatabaseService().getPlacementMaterials();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      // Upload mode: Show the form to add new placement material.
      return Scaffold(
        appBar: AppBar(title: const Text('Upload Placement Material')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSaved: (value) => title = value!.trim(),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!.trim(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter description'
                      : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Material URL'),
                  onSaved: (value) => materialUrl = value!.trim(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter material URL'
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadMaterial,
                  child: const Text('Upload Material'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // List mode: Display a list of placement materials.
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _getMaterials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Text('Error fetching materials: ${snapshot.error}')),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('No placement materials found.')),
            );
          }
          final materials = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text('Placement Materials')),
            body: ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) {
                var material = materials[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(material['title'] ?? ''),
                    subtitle: Text(material['description'] ?? ''),
                    onTap: () {
                      // Optionally: navigate to details or open the URL.
                    },
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}
