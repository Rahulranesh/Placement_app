import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:place/screen/login_screen.dart';
import 'package:place/screen/student_home_screen.dart';
import 'package:place/admin/admin_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://fcjdpmcaifpooqgtrmom.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZjamRwbWNhaWZwb29xZ3RybW9tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg1Njk2OTUsImV4cCI6MjA1NDE0NTY5NX0.JEq6JAIJQgJyiV0AhdqrlHXeq35oT8_WTZCMsfDclsg',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.blueGrey),
              titleTextStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
            ),
          ),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          home: AuthWrapper(themeNotifier: isDarkMode),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final ValueNotifier<bool> themeNotifier;
  const AuthWrapper({Key? key, required this.themeNotifier}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>;
                if (data['role'] == 'Admin') {
                  return AdminHomeScreen(themeNotifier: themeNotifier);
                } else {
                  return StudentHomeScreen(themeNotifier: themeNotifier);
                }
              }
              return StudentHomeScreen(themeNotifier: themeNotifier);
            },
          );
        }
        return LoginScreen(themeNotifier: themeNotifier);
      },
    );
  }
}

