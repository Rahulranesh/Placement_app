import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/global.dart';


class AdminUploadStaffScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadStaffScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadStaffScreenState createState() => _AdminUploadStaffScreenState();
}

class _AdminUploadStaffScreenState extends State<AdminUploadStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String achievement = '';
  String profileImageUrl = ''; // For simplicity, admin enters an image URL.

  Future<void> _uploadStaff() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Upload the staff data to the subcollection for the current department.
      await DatabaseService().addStaff(
        department: currentDepartment,
        staffData: {
          'name': name,
          'achievement': achievement,
          'profileImageUrl': profileImageUrl,
        },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      // Display the upload form.
      return Scaffold(
        appBar: AppBar(title: const Text('Upload Staff')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => name = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter staff name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Achievement / Profile Details'),
                  onSaved: (value) => achievement = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter achievement' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Profile Image URL'),
                  onSaved: (value) => profileImageUrl = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter image URL' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _uploadStaff, child: const Text('Upload Staff')),
              ],
            ),
          ),
        ),
      );
    } else {
      // Otherwise, show the list of staffs (for management purposes).
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
}
