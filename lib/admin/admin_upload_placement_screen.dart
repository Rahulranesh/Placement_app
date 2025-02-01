import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';

class AdminUploadPlacementScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadPlacementScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadPlacementScreenState createState() =>
      _AdminUploadPlacementScreenState();
}

class _AdminUploadPlacementScreenState extends State<AdminUploadPlacementScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String materialUrl = ''; // URL for the resource (document/video, etc.)

  Future<void> _uploadMaterial() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseService().addPlacementMaterial(
        department: currentDepartment,
        materialData: {
          'title': title,
          'description': description,
          'materialUrl': materialUrl,
        },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
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
                  onSaved: (value) => title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter description' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Material URL'),
                  onSaved: (value) => materialUrl = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter material URL' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _uploadMaterial,
                    child: const Text('Upload Material')),
              ],
            ),
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: DatabaseService().getPlacementMaterials(department: currentDepartment),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return const Center(child: Text('Error fetching materials'));
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
}
