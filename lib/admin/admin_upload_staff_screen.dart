import 'dart:io';
import 'package:flutter/material.dart';
import 'package:place/services/database_services.dart';
import 'package:place/services/storage_service.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';

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
  bool _isUploadingImage = false;

  Future<void> _pickAndUploadImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isUploadingImage = true;
      });
      try {
        String url = await StorageService().uploadFile(
            file, 'staffs/${DateTime.now().millisecondsSinceEpoch}');
        setState(() {
          profileImageUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Image upload failed: $e")));
      }
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _uploadStaff() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addStaff(staffData: {
          'name': name,
          'achievement': achievement,
          'profileImageUrl': profileImageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Staff uploaded successfully!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error uploading staff: $e")));
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getStaffs() async {
    return await DatabaseService().getStaffs();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uploadOnly) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Upload Staff'),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: NeumorphicContainer(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    NeumorphicTextField(
                      label: 'Name',
                      onSaved: (value) => name = value.trim(),
                    ),
                    SizedBox(height: 15),
                    NeumorphicTextField(
                      label: 'Achievement / Profile Details',
                      onSaved: (value) => achievement = value.trim(),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(profileImageUrl.isEmpty
                              ? "No image selected"
                              : "Image uploaded"),
                        ),
                        _isUploadingImage
                            ? CircularProgressIndicator()
                            : neumorphicButton(
                                onPressed: _pickAndUploadImage,
                                child: Text("Upload Image",
                                    style: TextStyle(fontSize: 16))),
                      ],
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(
                        onPressed: _uploadStaff,
                        child: Text('Upload Staff',
                            style: TextStyle(fontSize: 18))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(title: 'Staff List'),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getStaffs(),
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
}
