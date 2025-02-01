import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class QNPapersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch previous year Q/N papers from Firestore.
    return FutureBuilder(
      future: DatabaseService().getQNPapers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error fetching Q/N papers data'));
        final papers = snapshot.data as List;
        return ListView.builder(
          itemCount: papers.length,
          itemBuilder: (context, index) {
            var paper = papers[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(paper['subject'] ?? ''),
                subtitle: Text('Year: ${paper['year'] ?? ''}'),
                onTap: () {
                  // Optionally, implement a detailed view or download functionality.
                },
              ),
            );
          },
        );
      },
    );
  }
}
