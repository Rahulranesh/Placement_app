import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

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
  String paperUrl = ''; // URL to the document

  /// Uploads a question paper using the department fetched internally.
  Future<void> _uploadPaper() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addQNPaper(
          paperData: {
            'subject': subject,
            'year': year,
            'paperUrl': paperUrl,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Q/N Paper uploaded successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading Q/N Paper: $e")),
        );
      }
    }
  }

  /// Retrieves the list of question papers.
  Future<List<Map<String, dynamic>>> _getPapers() async {
    return await DatabaseService().getQNPapers();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      // Upload mode: Display the form to add a new Q/N paper.
      return Scaffold(
        appBar: AppBar(title: const Text('Upload Q/N Paper')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Subject'),
                  onSaved: (value) => subject = value!.trim(),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter subject' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Year'),
                  onSaved: (value) => year = value!.trim(),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter year' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Paper URL'),
                  onSaved: (value) => paperUrl = value!.trim(),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter paper URL' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadPaper,
                  child: const Text('Upload Q/N Paper'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // List mode: Display a list of uploaded Q/N papers.
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _getPapers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Text('Error fetching Q/N papers: ${snapshot.error}')),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('No Q/N papers found.')),
            );
          }
          final papers = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text('Q/N Papers')),
            body: ListView.builder(
              itemCount: papers.length,
              itemBuilder: (context, index) {
                var paper = papers[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(paper['subject'] ?? ''),
                    subtitle: Text('Year: ${paper['year'] ?? ''}'),
                    onTap: () {
                      // Optionally, implement navigation to a detailed view or open the URL.
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
