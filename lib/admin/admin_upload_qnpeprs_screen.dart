import 'dart:io';
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/storage_service.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';

class AdminUploadQNPapersScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadQNPapersScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadQNPapersScreenState createState() =>
      _AdminUploadQNPapersScreenState();
}

class _AdminUploadQNPapersScreenState extends State<AdminUploadQNPapersScreen> {
  final _formKey = GlobalKey<FormState>();
  String subject = '';
  String year = '';
  String paperUrl = '';
  bool _isUploadingFile = false;

  Future<void> _pickAndUploadPDF() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isUploadingFile = true;
      });
      try {
        String url = await StorageService().uploadFile(
            file, 'qnpapers/${DateTime.now().millisecondsSinceEpoch}.pdf');
        setState(() {
          paperUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("PDF upload failed: $e")));
      }
      setState(() {
        _isUploadingFile = false;
      });
    }
  }

  Future<void> _uploadPaper() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addQNPaper(paperData: {
          'subject': subject,
          'year': year,
          'paperUrl': paperUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Q/N Paper uploaded successfully!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading Q/N Paper: $e")));
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getPapers() async {
    return await DatabaseService().getQNPapers();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Upload Q/N Paper'),
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
                      label: 'Subject',
                      onSaved: (value) => subject = value.trim(),
                    ),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                      label: 'Year',
                      onSaved: (value) => year = value.trim(),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(paperUrl.isEmpty
                              ? "No PDF selected"
                              : "PDF uploaded"),
                        ),
                        _isUploadingFile
                            ? CircularProgressIndicator()
                            : neumorphicButton(
                                onPressed: _pickAndUploadPDF,
                                child: Text("Upload PDF",
                                    style: TextStyle(fontSize: 16))),
                      ],
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(
                        onPressed: _uploadPaper,
                        child: Text('Upload Q/N Paper',
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
        appBar: CustomAppBar(title: 'Q/N Papers'),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getPapers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(
                  child: Text('Error fetching Q/N papers: ${snapshot.error}'));
            if (!snapshot.hasData || snapshot.data!.isEmpty)
              return Center(child: Text('No Q/N papers found.'));
            final papers = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: papers.length,
              itemBuilder: (context, index) {
                var paper = papers[index];
                return NeumorphicContainer(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(paper['subject'] ?? ''),
                    subtitle: Text('Year: ${paper['year'] ?? ''}'),
                    trailing: IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () {
                        // Use url_launcher to download/view the PDF.
                        print("Download PDF from: ${paper['paperUrl']}");
                      },
                    ),
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
