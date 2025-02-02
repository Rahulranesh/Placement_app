import 'package:flutter/material.dart';
import 'package:place/utils/container.dart';
import 'package:place/utils/globals.dart' as globals;

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int total = globals.placementCompletion.length;
    int completed = globals.placementCompletion.values.where((v) => v).length;
    double progress = total > 0 ? completed / total : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Placement Preparation Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NeumorphicContainer(
          // Use theme-aware colors
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Preparation Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
              ),
              SizedBox(height: 10),
              Text('${(progress * 100).round()}% completed'),
              SizedBox(height: 30),
              Text(
                'Complete the checklist items in the Placement Preparation page to update your progress.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
