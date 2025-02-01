import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';

class AdminUploadExamsScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadExamsScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadExamsScreenState createState() => _AdminUploadExamsScreenState();
}

class _AdminUploadExamsScreenState extends State<AdminUploadExamsScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String date = ''; // You could use a DatePicker widget here.

  Future<void> _uploadExam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseService().addExam(
        department: currentDepartment,
        examData: {
          'title': title,
          'date': date,
        },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      return Scaffold(
        appBar: AppBar(title: const Text('Upload Exam')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Exam Title'),
                  onSaved: (value) => title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter exam title' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Exam Date (YYYY-MM-DD)'),
                  onSaved: (value) => date = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter exam date' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _uploadExam, child: const Text('Upload Exam')),
              ],
            ),
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: DatabaseService().getExams(department: currentDepartment),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return const Center(child: Text('Error fetching exams data'));
          final exams = snapshot.data as List;
          return ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              var exam = exams[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(exam['title'] ?? ''),
                  subtitle: Text('Date: ${exam['date'] ?? ''}'),
                ),
              );
            },
          );
        },
      );
    }
  }
}
