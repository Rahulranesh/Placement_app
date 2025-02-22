import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:place/services/database_services.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class QuestionPapersStudentScreen extends StatefulWidget {
  const QuestionPapersStudentScreen({Key? key}) : super(key: key);

  @override
  _QuestionPapersStudentScreenState createState() =>
      _QuestionPapersStudentScreenState();
}

class _QuestionPapersStudentScreenState
    extends State<QuestionPapersStudentScreen> {
  late Future<List<Map<String, dynamic>>> _papersFuture;

  @override
  void initState() {
    super.initState();
    _papersFuture = DatabaseService().getQNPapers();
  }

  /// Downloads the PDF from a network URL, saves it locally, and opens the PDF viewer.
  Future<void> _downloadPdf(String pdfUrl) async {
    try {
      final uri = Uri.parse(pdfUrl);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        // Use the last segment of the URL as the file name (or "downloaded.pdf" if empty)
        final fileName = uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : "downloaded.pdf";
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Download completed")),
        );
        _viewPdf(file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error downloading PDF: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }

  /// Navigates to the PDF viewer page using the local file path.
  void _viewPdf(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdfViewerPage(pdfPath: filePath)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Question Papers'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _papersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(
                child:
                    Text('Error fetching question papers: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No question papers found.'));
          final papers = snapshot.data!;

          // Group papers by regulation then by semester.
          Map<String, Map<String, List<Map<String, dynamic>>>> groupedPapers =
              {};
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
      ),
    );
  }
}

/// A simple PDF Viewer page using flutter_pdfview.
class PdfViewerPage extends StatelessWidget {
  final String pdfPath; // Local file path for the downloaded PDF.
  const PdfViewerPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ),
    );
  }
}
