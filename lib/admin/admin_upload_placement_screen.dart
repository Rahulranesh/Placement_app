// admin_upload_placement_screen.dart
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/neumorphic_widget.dart';

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
  String materialUrl = '';

  Future<void> _uploadMaterial() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addPlacementMaterial(materialData: {
          'title': title,
          'description': description,
          'materialUrl': materialUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Material uploaded successfully!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading material: $e")));
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getMaterials() async {
    return await DatabaseService().getPlacementMaterials();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Upload Placement Material'),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: NeumorphicContainer(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    NeumorphicTextField(
                      label: 'Title',
                      onSaved: (value) => title = value.trim(),
                    ),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                      label: 'Description',
                      onSaved: (value) => description = value.trim(),
                    ),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                      label: 'Material URL',
                      onSaved: (value) => materialUrl = value.trim(),
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(
                        onPressed: _uploadMaterial,
                        child: Text('Upload Material',
                            style: TextStyle(fontSize: 18))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(title: 'Placement Materials'),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getMaterials(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(
                  child: Text('Error fetching materials: ${snapshot.error}'));
            if (!snapshot.hasData || snapshot.data!.isEmpty)
              return Center(child: Text('No placement materials found.'));
            final materials = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: materials.length,
              itemBuilder: (context, index) {
                var material = materials[index];
                return NeumorphicContainer(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(material['title'] ?? ''),
                    subtitle: Text(material['description'] ?? ''),
                    onTap: () {},
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
