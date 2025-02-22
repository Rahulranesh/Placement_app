import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/download_helper.dart';
import 'package:place/utils/neumorphic_widget.dart';

class QuestionPapersStudentScreen extends StatefulWidget {
  const QuestionPapersStudentScreen({Key? key}) : super(key: key);

  @override
  _QuestionPapersStudentScreenState createState() => _QuestionPapersStudentScreenState();
}

class _QuestionPapersStudentScreenState extends State<QuestionPapersStudentScreen> {
  late Future<List<Map<String, dynamic>>> _papersFuture;

  @override
  void initState() {
    super.initState();
    _papersFuture = DatabaseService().getQNPapers();
  }

  Future<void> _downloadPdf(String pdfUrl) async {
    try {
      String fileName = pdfUrl.split('/').last;
      downloadAndOpenFile(context, pdfUrl, fileName);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Download failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _papersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error fetching question papers: ${snapshot.error}'));
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return Center(child: Text('No question papers found.'));
        final papers = snapshot.data!;
        Map<String, Map<String, List<Map<String, dynamic>>>> groupedPapers = {};
        for (var paper in papers) {
          String reg = paper['regulation'] ?? 'Unknown';
          String sem = paper['semester'] ?? 'Unknown';
          groupedPapers.putIfAbsent(reg, () => {});
          groupedPapers[reg]!.putIfAbsent(sem, () => []);
          groupedPapers[reg]![sem]!.add(paper);
        }
        return ListView(
          children: groupedPapers.entries.map((regEntry) {
            String reg = regEntry.key;
            Map<String, List<Map<String, dynamic>>> semMap = regEntry.value;
            return NeumorphicContainer(
              padding: EdgeInsets.all(8),
              child: ExpansionTile(
                title: Text("Regulation $reg"),
                children: semMap.entries.map((semEntry) {
                  String sem = semEntry.key;
                  List<Map<String, dynamic>> subjectPapers = semEntry.value;
                  return NeumorphicContainer(
                    padding: EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text("Semester $sem"),
                      children: subjectPapers.map((paper) {
                        String subject = paper['subject'] ?? 'Unknown';
                        String pdfUrl = paper['paperUrl'] ?? '';
                        return NeumorphicContainer(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(subject),
                            subtitle: Text("Tap to view or download"),
                            trailing: IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () {
                                _downloadPdf(pdfUrl);
                              },
                            ),
                            onTap: () {
                              _downloadPdf(pdfUrl);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
