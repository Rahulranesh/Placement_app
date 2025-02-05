// qnpapers_screen.dart
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/download_helper.dart';

class QNPapersScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _getPapers() async {
    return await DatabaseService().getQNPapers();
  }

  @override
  Widget build(BuildContext context) {
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
              String paperUrl = paper['paperUrl'] ?? '';
              return NeumorphicContainer(
                padding: EdgeInsets.all(16),
                child: ListTile(
                  title: Text(paper['subject'] ?? ''),
                  subtitle: Text('Year: ${paper['year'] ?? ''}'),
                  trailing: paperUrl.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            String fileName = paperUrl.split('/').last;
                            downloadAndOpenFile(context, paperUrl, fileName);
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
