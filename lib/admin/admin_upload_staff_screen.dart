import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';

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
  String profileImageUrl = '';

  /// Uploads a staff member using the department fetched internally
  /// by DatabaseService.
  Future<void> _uploadStaff() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // No need to pass department externally since it's fetched internally.
        await DatabaseService().addStaff(
          staffData: {
            'name': name,
            'achievement': achievement,
            'profileImageUrl': profileImageUrl,
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Staff uploaded successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading staff: $e")),
        );
      }
    }
  }

  /// Retrieves the list of staff members using the DatabaseService.
  Future<List<Map<String, dynamic>>> _getStaffs() async {
    return await DatabaseService().getStaffs();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      // Upload mode: Display the form to add a new staff member.
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
                  onSaved: (value) => name = value!.trim(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter staff name'
                      : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Achievement / Profile Details'),
                  onSaved: (value) => achievement = value!.trim(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter achievement'
                      : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Profile Image URL'),
                  onSaved: (value) => profileImageUrl = value!.trim(),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter image URL' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadStaff,
                  child: const Text('Upload Staff'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Non-upload mode: Display a list of staff members.
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _getStaffs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error fetching staff data: ${snapshot.error}'),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('No staff found.')),
            );
          }
          final staffs = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text('Staff List')),
            body: ListView.builder(
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
            ),
          );
        },
      );
    }
  }
}
