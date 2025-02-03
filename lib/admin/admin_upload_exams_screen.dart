import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/subabase_storage_service.dart';
<<<<<<< HEAD
=======

>>>>>>> ffe1626e32d9e8b5423444e786f6984724fbfb96
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';

class AdminUploadExamsScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadExamsScreen({this.uploadOnly = false, Key? key}) : super(key: key);

  @override
  _AdminUploadExamsScreenState createState() => _AdminUploadExamsScreenState();
}

class _AdminUploadExamsScreenState extends State<AdminUploadExamsScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String date = '';
  String? examImageUrl;
  bool _isUploadingImage = false;

  Future<void> _pickAndUploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isUploadingImage = true;
      });
      try {
<<<<<<< HEAD
        // Upload file using SupabaseStorageService. The file name will include the Firebase UID.
        String url = await SupabaseStorageService()
            .uploadFile(file, 'exams', extension: ".jpg");
=======
        // Use SupabaseStorageService instead of Firebase Storage
        String url = await SupabaseStorageService().uploadFile(file, 'exams', extension: ".jpg");
>>>>>>> ffe1626e32d9e8b5423444e786f6984724fbfb96
        setState(() {
          examImageUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image upload failed: $e"))
        );
      }
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _uploadExam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Prepare exam data, including tracking the uploader’s Firebase UID.
      Map<String, dynamic> examData = {
        'title': title,
        'date': date,
        'uploadedBy': FirebaseAuth.instance.currentUser?.uid,
      };
      if (examImageUrl != null) {
        examData['examImageUrl'] = examImageUrl;
      }
      try {
        await DatabaseService().addExam(examData: examData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exam uploaded successfully!"))
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading exam: $e"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Upload Exam'),
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
                      label: 'Exam Title',
                      onSaved: (value) => title = value.trim(),
                    ),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                      label: 'Exam Date (YYYY-MM-DD)',
                      onSaved: (value) => date = value.trim(),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            examImageUrl == null
                                ? "No exam image selected"
                                : "Exam image uploaded",
                          ),
                        ),
                        _isUploadingImage
                            ? CircularProgressIndicator()
                            : neumorphicButton(
                                onPressed: _pickAndUploadImage,
                                child: Text("Upload Image", style: TextStyle(fontSize: 16))
                              ),
                      ],
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(
                      onPressed: _uploadExam,
                      child: Text('Upload Exam', style: TextStyle(fontSize: 18))
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(title: 'Exams'),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseService().getExams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(child: Text('Error fetching exams: ${snapshot.error}'));
            if (!snapshot.hasData || snapshot.data!.isEmpty)
              return Center(child: Text('No exams found.'));
            final exams = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                var exam = exams[index];
                return NeumorphicContainer(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(exam['title'] ?? ''),
                    subtitle: Text('Date: ${exam['date'] ?? ''}'),
                    trailing: exam.containsKey('examImageUrl')
                        ? IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () {
<<<<<<< HEAD
                              // To download, use the URL launcher to open the public URL.
                              // For example:
                              // await launchUrl(Uri.parse(exam['examImageUrl']));
=======
                              print("Download exam image from: ${exam['examImageUrl']}");
>>>>>>> ffe1626e32d9e8b5423444e786f6984724fbfb96
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
