import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

class StaffsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService().getStaffs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Error fetching staff data: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No staff found.'));
        }
        final staffs = snapshot.data!;
        return ListView.builder(
          itemCount: staffs.length,
          itemBuilder: (context, index) {
            var staff = staffs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: (staff['profileImageUrl'] != null &&
                        staff['profileImageUrl'].toString().isNotEmpty)
                    ? NetworkImage(staff['profileImageUrl'])
                    : null,
                child: (staff['profileImageUrl'] == null ||
                        staff['profileImageUrl'].toString().isEmpty)
                    ? const Icon(Icons.person)
                    : null,
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
