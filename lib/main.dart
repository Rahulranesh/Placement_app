import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:place/screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placement App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Customize further to follow Mitch Koko’s modern style.
      ),
      home: LoginScreen(),
    );
  }
}
