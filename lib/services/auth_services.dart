import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login method.
  Future<bool> login(String username, String password, bool isAdmin) async {
    try {
      // Here, 'username' is assumed to be an email address.
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      return result.user != null;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  // Registration method.
  Future<bool> register(String name, String department, String username,
      String password, bool isAdmin) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: username, password: password);
      // Save additional user info (name, department, role) to Firestore as needed.
      return result.user != null;
    } catch (e) {
      print('Registration Error: $e');
      return false;
    }
  }
}
