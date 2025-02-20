/* admin_upload_placement_screen.dart */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/subabase_storage_service.dart';

import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';

class AdminUploadPlacementScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadPlacementScreen({this.uploadOnly = false, Key? key}) : super(key: key);
  @override
  _AdminUploadPlacementScreenState createState() => _AdminUploadPlacementScreenState();
}

class _AdminUploadPlacementScreenState extends State<AdminUploadPlacementScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String materialUrl = '';
  bool _isUploadingFile = false;
  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isUploadingFile = true;
      });
      try {
        String url = await SupabaseStorageService().uploadFile(file, 'placement_material');
        setState(() {
          materialUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File upload failed: $e")));
      }
      setState(() {
        _isUploadingFile = false;
      });
    }
  }
  Future<void> _uploadMaterial() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addPlacementMaterial(materialData: {
          'title': title,
          'description': description,
          'materialUrl': materialUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Material uploaded successfully!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading material: $e")));
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
        appBar: CustomAppBar(title: 'Upload Placement Material', showNotificationButton: true),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: NeumorphicContainer(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    NeumorphicTextField(label: 'Title', onSaved: (value) => title = value.trim()),
                    SizedBox(height: 15),
                    NeumorphicTextField(label: 'Description', onSaved: (value) => description = value.trim()),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: Text(materialUrl.isEmpty ? "No file selected" : "File uploaded")),
                        _isUploadingFile ? CircularProgressIndicator() : neumorphicButton(onPressed: _pickAndUploadFile, child: Text("Upload File", style: TextStyle(fontSize: 16))),
                      ],
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(onPressed: _uploadMaterial, child: Text('Upload Material', style: TextStyle(fontSize: 18))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(title: 'Placement Materials', showNotificationButton: true),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getMaterials(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Error fetching materials: ${snapshot.error}'));
            if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('No placement materials found.'));
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
                    trailing: IconButton(icon: Icon(Icons.download), onPressed: () {}),
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
