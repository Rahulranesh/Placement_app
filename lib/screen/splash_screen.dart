import 'dart:async';
import 'package:flutter/material.dart';
import 'package:place/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final ValueNotifier<bool> themeNotifier;
  const SplashScreen({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(themeNotifier: widget.themeNotifier),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
