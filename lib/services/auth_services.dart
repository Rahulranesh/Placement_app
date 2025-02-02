import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login(String username, String password, bool isAdmin) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      return result.user != null;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String department, String username,
      String password, bool isAdmin) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: username, password: password);
      if (result.user != null) {
        await _firestore.collection("users").doc(result.user!.uid).set({
          "name": name,
          "department": department,
          "email": username,
          "role": isAdmin ? "Admin" : "Student",
          "createdAt": FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Registration Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
