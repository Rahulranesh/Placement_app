import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class StaffsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch department staffs from Firestore.
    return FutureBuilder(
      future: DatabaseService().getStaffs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error fetching staff data'));
        final staffs = snapshot.data as List;
        return ListView.builder(
          itemCount: staffs.length,
          itemBuilder: (context, index) {
            var staff = staffs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(staff['profileImageUrl'] ?? ''),
              ),
              title: Text(staff['name'] ?? ''),
              subtitle: Text(staff['achievement'] ?? ''),
            );
          },
        );
      },
    );
  }
}
