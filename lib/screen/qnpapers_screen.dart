import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class QNPapersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService().getQNPapers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error fetching Q/N papers: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Q/N papers found.'));
        }
        final papers = snapshot.data!;
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
                  // Optionally, open paper URL or navigate to a detailed view.
                },
              ),
            );
          },
        );
      },
    );
  }
}
