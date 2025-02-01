import 'package:flutter/material.dart';

import 'package:place/services/auth_services.dart';
import 'package:place/utils/container.dart';
import 'package:place/utils/textfield.dart';
import 'package:place/utils/button.dart';

// The RegisterScreen with neumorphic style
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', department = '', username = '', password = '';
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.grey[300]!;

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        title: Text('Register', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: NeumorphicContainer(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Role selection using custom neumorphic radio buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicRadio<bool>(
                          value: false,
                          groupValue: isAdmin,
                          onChanged: (value) {
                            setState(() {
                              isAdmin = value!;
                            });
                          },
                          label: "Student",
                        ),
                        SizedBox(width: 20),
                        NeumorphicRadio<bool>(
                          value: true,
                          groupValue: isAdmin,
                          onChanged: (value) {
                            setState(() {
                              isAdmin = value!;
                            });
                          },
                          label: "Admin",
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    neumorphicTextField(
                      label: "Name",
                      onSaved: (value) => name = value,
                    ),
                    SizedBox(height: 15),
                    neumorphicTextField(
                      label: "Department",
                      onSaved: (value) => department = value,
                    ),
                    SizedBox(height: 15),
                    neumorphicTextField(
                      label: "Username",
                      onSaved: (value) => username = value,
                    ),
                    SizedBox(height: 15),
                    neumorphicTextField(
                      label: "Password",
                      obscureText: true,
                      onSaved: (value) => password = value,
                    ),
                    SizedBox(height: 20),
                    neumorphicButton(
                      onPressed: _register,
                      child: Center(
                        child: Text('Register', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await AuthService()
          .register(name, department, username, password, isAdmin);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    }
  }
}

///
/// Below are the custom widgets for the neumorphic style.
/// You can place these in a separate utility file (e.g., utils/neumorphic_widgets.dart)
///

/// A container with a neumorphic look.

/// A custom neumorphic text field.

/// A custom neumorphic radio widget for role selection.
class NeumorphicRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String label;

  NeumorphicRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = value == groupValue;
    Color baseColor = Colors.grey[300]!;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  // For selected state, use a shallower shadow for a pressed look.
                  BoxShadow(
                    color: Colors.grey[500]!,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  // For unselected state, use deeper shadows.
                  BoxShadow(
                    color: Colors.grey[500]!,
                    offset: Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
