import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:intl/intl.dart';

class AdminPlacementInfoListScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _getPlacementInfo() async {
    return await DatabaseService().getPlacementInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Placement Info', showNotificationButton: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getPlacementInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('No placement info found.'));
          final infoList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              var info = infoList[index];
              DateTime placementDate = DateTime.parse(info['placementDate']);
              return NeumorphicContainer(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info['companyName'] ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Date: ${DateFormat.yMd().format(placementDate)}'),
                    SizedBox(height: 8),
                    Text('Eligibility: ${info['eligibility'] ?? ''}'),
                    SizedBox(height: 8),
                    Text(info['description'] ?? ''),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
