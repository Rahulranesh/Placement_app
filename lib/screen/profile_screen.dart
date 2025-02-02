import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', department = '';

  Future<void> _fetchProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] ?? '';
          department = userDoc['department'] ?? '';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': name,
          'department': department,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')));
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color containerColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    return Scaffold(
      appBar: CustomAppBar(title: 'Update Profile'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: NeumorphicContainer(
            color: containerColor,
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  NeumorphicTextField(
                    label: "Name",
                    onSaved: (value) => name = value,
                  ),
                  SizedBox(height: 15),
                  NeumorphicTextField(
                    label: "Department",
                    onSaved: (value) => department = value,
                  ),
                  SizedBox(height: 20),
                  neumorphicButton(
                      onPressed: _updateProfile,
                      child: Center(
                          child: Text('Update Profile',
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
