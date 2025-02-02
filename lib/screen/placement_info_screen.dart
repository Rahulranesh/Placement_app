import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/notification_service.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

class PlacementInfoScreen extends StatefulWidget {
  @override
  _PlacementInfoScreenState createState() => _PlacementInfoScreenState();
}

class _PlacementInfoScreenState extends State<PlacementInfoScreen> {
  late Future<List<Map<String, dynamic>>> _infoFuture;

  @override
  void initState() {
    super.initState();
    _infoFuture = DatabaseService().getPlacementInfo();
  }

  void _scheduleNotifications(List<Map<String, dynamic>> infoList) {
    int idCounter = 0;
    DateTime now = DateTime.now();
    for (var info in infoList) {
      String companyName = info['companyName'] ?? 'Placement';
      String description = info['description'] ?? '';
      String placementDateStr = info['placementDate'];
      DateTime placementDate = DateTime.parse(placementDateStr);
      if (placementDate.isAfter(now)) {
        DateTime scheduledTime = DateTime(
            placementDate.year, placementDate.month, placementDate.day, 9, 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Upcoming Placements'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _infoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No placement information found.'));
          final infoList = snapshot.data!;
          _scheduleNotifications(infoList);
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              var info = infoList[index];
              String companyName = info['companyName'] ?? '';
              String eligibility = info['eligibility'] ?? '';
              String description = info['description'] ?? '';
              DateTime placementDate = DateTime.parse(info['placementDate']);
              return NeumorphicContainer(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(companyName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Date: ${DateFormat.yMd().format(placementDate)}'),
                    SizedBox(height: 8),
                    Text('Eligibility: $eligibility'),
                    SizedBox(height: 8),
                    Text(description),
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
