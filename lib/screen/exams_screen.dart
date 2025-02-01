import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class ExamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch upcoming exams from Firestore.
    return FutureBuilder(
      future: DatabaseService().getExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error fetching exams data'));
        final exams = snapshot.data as List;
        return ListView.builder(
          itemCount: exams.length,
          itemBuilder: (context, index) {
            var exam = exams[index];
            return Card(
              margin: EdgeInsets.all(8.0),
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
