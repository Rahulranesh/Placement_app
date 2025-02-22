import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/subabase_storage_service.dart';

import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class AdminUploadQNPapersScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadQNPapersScreen({this.uploadOnly = false, Key? key}) : super(key: key);

  @override
  _AdminUploadQNPapersScreenState createState() => _AdminUploadQNPapersScreenState();
}

class _AdminUploadQNPapersScreenState extends State<AdminUploadQNPapersScreen> {
  final _formKey = GlobalKey<FormState>();
  String subject = '';
  String regulation = '18';
  String semester = '1';
  String paperUrl = '';
  bool _isUploadingFile = false;

  final List<String> regulations = ['18', '22'];
  final List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  Future<void> _pickAndUploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isUploadingFile = true;
      });
      try {
        String url = await SupabaseStorageService()
            .uploadFile(file, 'qn_paper', extension: ".pdf");
        setState(() {
          paperUrl = url;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF uploaded successfully"))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF upload failed: $e")),
        );
      }
      setState(() {
        _isUploadingFile = false;
      });
    }
  }

  Future<void> _uploadPaper() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> paperData = {
        'subject': subject,
        'regulation': regulation,
        'semester': semester,
        'paperUrl': paperUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      };

      try {
        await DatabaseService().addQNPaper(paperData: paperData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Question paper uploaded successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading question paper: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Upload Question Paper'),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: NeumorphicContainer(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: regulation,
                      decoration: InputDecoration(
                        labelText: 'Regulation',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: regulations.map((reg) {
                        return DropdownMenuItem<String>(
                          value: reg,
                          child: Text("Regulation $reg"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          regulation = value!;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select a regulation'
                          : null,
                      onSaved: (value) => regulation = value!,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: semester,
                      decoration: InputDecoration(
                        labelText: 'Semester',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: semesters.map((sem) {
                        return DropdownMenuItem<String>(
                          value: sem,
                          child: Text("Semester $sem"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          semester = value!;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select a semester'
                          : null,
                      onSaved: (value) => semester = value!,
                    ),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                      label: 'Subject',
                      onSaved: (value) => subject = value,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: paperUrl.isEmpty
                              ? Text("No PDF selected")
                              : Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf),
                                    SizedBox(width: 8),
                                    Expanded(child: Text("PDF Uploaded")),
                                  ],
                                ),
                        ),
                        _isUploadingFile
                            ? CircularProgressIndicator()
                            : neumorphicButton(
                                onPressed: _pickAndUploadPDF,
                                child: Text("Upload PDF", style: TextStyle(fontSize: 16)),
                              ),
                      ],
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(
                      onPressed: _uploadPaper,
                      child: Text('Upload Question Paper', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // For non-uploadOnly mode, list existing papers (omitted for brevity).
      return Container();
    }
  }
}
