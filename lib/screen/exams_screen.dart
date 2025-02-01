import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';
class ExamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
