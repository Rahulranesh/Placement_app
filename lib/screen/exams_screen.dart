import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/download_helper.dart';

class ExamsScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _getExams() async {
    return await DatabaseService().getExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Exams'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getExams(),
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
              String examUrl = exam['examImageUrl'] ?? '';
              return NeumorphicContainer(
                padding: EdgeInsets.all(16),
                child: ListTile(
                  title: Text(exam['title'] ?? ''),
                  subtitle: Text('Date: ${exam['date'] ?? ''}'),
                  trailing: examUrl.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            // Download helper to open file.
                            String fileName = examUrl.split('/').last;
                            downloadAndOpenFile(context, examUrl, fileName);
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
