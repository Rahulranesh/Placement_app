// progress_screen.dart
import 'package:flutter/material.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/globals.dart' as globals;

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int total = globals.placementCompletion.length;
    int completed = globals.placementCompletion.values.where((v) => v).length;
    double progress = total > 0 ? completed / total : 0.0;
    return Scaffold(
      appBar: CustomAppBar(title: 'Placement Preparation Progress'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: NeumorphicContainer(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Preparation Progress',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                LinearProgressIndicator(value: progress, minHeight: 10),
                SizedBox(height: 10),
                Text('${(progress * 100).round()}% completed'),
                SizedBox(height: 30),
                Text(
                    'Complete the checklist items in the Placement Preparation page to update your progress.',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
