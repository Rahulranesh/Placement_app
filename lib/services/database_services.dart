import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserDepartment() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in.");
    DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      return "global";
    }
    String? department = userDoc['department'];
    if (department == null || department.trim().isEmpty) {
      return "global";
    }
    return department;
  }

  Future<List<Map<String, dynamic>>> getStaffs() async {
    String dept = await getUserDepartment();
    QuerySnapshot snapshot = await _db.collection('departments').doc(dept).collection('staffs').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> addStaff({required Map<String, dynamic> staffData}) async {
    String dept = await getUserDepartment();
    await _db.collection('departments').doc(dept).collection('staffs').add(staffData);
  }

  Future<List<Map<String, dynamic>>> getExams() async {
    String dept = await getUserDepartment();
    QuerySnapshot snapshot = await _db.collection('departments').doc(dept).collection('exams').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> addExam({required Map<String, dynamic> examData}) async {
    String dept = await getUserDepartment();
    await _db.collection('departments').doc(dept).collection('exams').add(examData);
  }

  Future<List<Map<String, dynamic>>> getQNPapers() async {
    String dept = await getUserDepartment();
    QuerySnapshot snapshot = await _db.collection('departments').doc(dept).collection('qnpapers').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> addQNPaper({required Map<String, dynamic> paperData}) async {
    String dept = await getUserDepartment();
    await _db.collection('departments').doc(dept).collection('qnpapers').add(paperData);
  }

  Future<List<Map<String, dynamic>>> getPlacementMaterials() async {
    String dept = await getUserDepartment();
    QuerySnapshot snapshot = await _db.collection('departments').doc(dept).collection('placementMaterials').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> addPlacementMaterial({required Map<String, dynamic> materialData}) async {
    String dept = await getUserDepartment();
    await _db.collection('departments').doc(dept).collection('placementMaterials').add(materialData);
  }

 // In lib/services/database_services.dart

// Replace the existing placement info methods with these:

Future<void> addPlacementInfo({required Map<String, dynamic> infoData}) async {
  // Store placement info in a global collection
  await _db.collection('placement_info').add(infoData);
}

Future<List<Map<String, dynamic>>> getPlacementInfo() async {
  // Retrieve placement info from the global collection
  QuerySnapshot snapshot = await _db.collection('placement_info').get();
  return snapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
      .toList();
}

}
