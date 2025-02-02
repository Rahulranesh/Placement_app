import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:place/utils/container.dart';
import 'package:place/utils/button.dart';
import 'package:place/utils/textfield.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', department = '';

  // Fetch current user data to prefill the form.
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

  // Update profile data.
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
    // Check if dark mode is active.
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Set container and text colors based on theme.
    Color containerColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NeumorphicContainer(
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Use the neumorphicTextField as before.
                // You can also update the custom widget to support text styling.
                neumorphicTextField(
                  label: "Name",
                  onSaved: (value) => name = value,
                ),
                SizedBox(height: 15),
                neumorphicTextField(
                  label: "Department",
                  onSaved: (value) => department = value,
                ),
                SizedBox(height: 20),
                neumorphicButton(
                  onPressed: _updateProfile,
                  child: Center(
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
