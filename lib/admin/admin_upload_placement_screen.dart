import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/subabase_storage_service.dart';

import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

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
  String fileUrl = '';
  bool _isUploadingFile = false;

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isUploadingFile = true;
      });
      try {
        String url = await SupabaseStorageService().uploadFile(file, 'placement_material', extension: ".pdf");
        setState(() {
          fileUrl = url;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File uploaded successfully"))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File upload failed: $e"))
        );
      }
      setState(() {
        _isUploadingFile = false;
      });
    }
  }

  Future<void> _uploadMaterial() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> materialData = {
        'title': title,
        'description': description,
      };
      if (fileUrl.isNotEmpty) {
        materialData['fileUrl'] = fileUrl;
      }
      try {
        await DatabaseService().addPlacementMaterial(materialData: materialData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Placement material uploaded successfully!"))
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading material: $e"))
        );
      }
    }
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
                        label: 'Title', onSaved: (value) => title = value.trim()),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                        label: 'Description', onSaved: (value) => description = value.trim()),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: fileUrl.isEmpty
                              ? Text("No file selected")
                              : Text("File Uploaded"),
                        ),
                        _isUploadingFile
                            ? CircularProgressIndicator()
                            : neumorphicButton(
                                onPressed: _pickAndUploadFile,
                                child: Text("Upload File", style: TextStyle(fontSize: 16))),
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
      // Listing materials if not in uploadOnly mode.
      return Scaffold(
        appBar: CustomAppBar(title: 'Placement Materials'),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseService().getPlacementMaterials(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(child: Text('Error fetching materials: ${snapshot.error}'));
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
                    trailing: material.containsKey('fileUrl')
                        ? IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () {
                              // Use download helper to view file.
                            },
                          )
                        : null,
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
