import 'package:flutter/material.dart';

import 'package:place/services/auth_services.dart';
import 'package:place/utils/container.dart';
import 'package:place/utils/button.dart';

import 'package:place/utils/textfield.dart';
import 'register_screen.dart';
import 'student_home_screen.dart';
import 'admin_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '', password = '';
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    // Base color for neumorphic style
    final Color baseColor = Colors.grey[300]!;

    return Scaffold(
      backgroundColor: baseColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: NeumorphicContainer(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
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
                      onPressed: _login,
                      child: Center(
                          child: Text('Login', style: TextStyle(fontSize: 18))),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen())),
                      child: Text("Don't have an account? Register"),
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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await AuthService().login(username, password, isAdmin);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isAdmin ? AdminHomeScreen() : StudentHomeScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login failed')));
      }
    }
  }
}

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
