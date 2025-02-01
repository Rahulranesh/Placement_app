import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';


class QNPapersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  // Optionally, open paper URL.
                },
              ),
            );
          },
        );
      },
    );
  }
}
