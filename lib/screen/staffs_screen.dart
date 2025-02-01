import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';

class StaffsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getStaffs(department: currentDepartment),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return const Center(child: Text('Error fetching staff data'));
        final staffs = snapshot.data as List;
        return ListView.builder(
          itemCount: staffs.length,
          itemBuilder: (context, index) {
            var staff = staffs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(staff['profileImageUrl'] ?? ''),
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
