// staffs_screen.dart
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

class StaffsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Staffs'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseService().getStaffs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(
                child: Text('Error fetching staff data: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No staff found.'));
          final staffs = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: staffs.length,
            itemBuilder: (context, index) {
              var staff = staffs[index];
              return NeumorphicContainer(
                padding: EdgeInsets.all(16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (staff['profileImageUrl'] != null &&
                            staff['profileImageUrl'].toString().isNotEmpty)
                        ? NetworkImage(staff['profileImageUrl'])
                        : null,
                    child: (staff['profileImageUrl'] == null ||
                            staff['profileImageUrl'].toString().isEmpty)
                        ? Icon(Icons.person)
                        : null,
                  ),
                  title: Text(staff['name'] ?? ''),
                  subtitle: Text(staff['achievement'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
