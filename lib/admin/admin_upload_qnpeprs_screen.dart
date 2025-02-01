import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';


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

  Future<void> _uploadPaper() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseService().addQNPaper(
        department: currentDepartment,
        paperData: {
          'subject': subject,
          'year': year,
          'paperUrl': paperUrl,
        },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
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
                  onSaved: (value) => subject = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter subject' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Year'),
                  onSaved: (value) => year = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter year' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Paper URL'),
                  onSaved: (value) => paperUrl = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter paper URL' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _uploadPaper,
                    child: const Text('Upload Q/N Paper')),
              ],
            ),
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: DatabaseService().getQNPapers(department: currentDepartment),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return const Center(child: Text('Error fetching Q/N papers'));
          final papers = snapshot.data as List;
          return ListView.builder(
            itemCount: papers.length,
            itemBuilder: (context, index) {
              var paper = papers[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(paper['subject'] ?? ''),
                  subtitle: Text('Year: ${paper['year'] ?? ''}'),
                  onTap: () {
                    // Optionally: navigate to a detailed view or open the URL.
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
