import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:place/screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Global theme notifier to allow dark mode toggle.
  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, darkMode, child) {
        return MaterialApp(
          title: 'Placement App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[300],
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[850],
          ),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          // Pass the theme notifier to LoginScreen.
          home: LoginScreen(themeNotifier: isDarkMode),
        );
      },
    );
  }
}
