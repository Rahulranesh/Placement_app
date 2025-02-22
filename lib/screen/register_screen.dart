import 'package:flutter/material.dart';
import 'package:place/services/auth_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields.
  String name = '';
  String department = 'cse'; // Default department.
  String username = '';
  String password = '';
  bool isAdmin = false;

  // List of department options.
  final List<String> departments = [
    'cse',
    'it',
    'ece',
    'eee',
    'mech',
    'civil',
    'ibt',
    'eie',
    'prod'
  ];

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

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: baseColor,
      appBar: CustomAppBar(title: 'Register'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NeumorphicContainer(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Role selection (Student/Admin).
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
                  // Name field.
                  NeumorphicTextField(
                    label: "Name",
                    onSaved: (value) => name = value,
                  ),
                  SizedBox(height: 15),
                  // Department dropdown field.
                  DropdownButtonFormField<String>(
                    value: department,
                    decoration: InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    items: departments.map((dept) {
                      return DropdownMenuItem<String>(
                        value: dept,
                        child: Text(dept.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        department = value!;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a department'
                        : null,
                    onSaved: (value) => department = value!,
                  ),
                  SizedBox(height: 15),
                  // Username field.
                  NeumorphicTextField(
                      label: "Username", onSaved: (value) => username = value),
                  SizedBox(height: 15),
                  // Password field.
                  NeumorphicTextField(
                    label: "Password",
                    obscureText: true,
                    onSaved: (value) => password = value,
                  ),
                  SizedBox(height: 20),
                  // Register button.
                  neumorphicButton(
                    onPressed: _register,
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
