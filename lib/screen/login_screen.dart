// login_screen.dart
import 'package:flutter/material.dart';

import 'package:place/admin/admin_home_screen.dart';
import 'package:place/screen/register_screen.dart';
import 'package:place/screen/student_home_screen.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  final ValueNotifier<bool>? themeNotifier;
  LoginScreen({Key? key, this.themeNotifier}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '', password = '';
  bool isAdmin = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await AuthService().login(username, password, isAdmin);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isAdmin
                ? AdminHomeScreen()
                : StudentHomeScreen(themeNotifier: widget.themeNotifier),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: baseColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NeumorphicContainer(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
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
                  NeumorphicTextField(
                      label: "Username", onSaved: (value) => username = value),
                  SizedBox(height: 15),
                  NeumorphicTextField(
                      label: "Password",
                      obscureText: true,
                      onSaved: (value) => password = value),
                  SizedBox(height: 20),
                  neumorphicButton(
                      onPressed: _login,
                      child: Center(
                          child:
                              Text('Login', style: TextStyle(fontSize: 18)))),
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
    );
  }
}
