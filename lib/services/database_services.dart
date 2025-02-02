import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Get the current user's department (Public method)
  Future<String> getUserDepartment() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in.");

    DocumentSnapshot userDoc =
        await _db.collection('users').doc(user.uid).get();
    if (!userDoc.exists) throw Exception("User data not found.");

    String? department = userDoc['department'];
    if (department == null || department.trim().isEmpty) {
      throw Exception("Department not set for user.");
    }
    return department;
  }

  // 🚀 STAFFS
  Future<List<Map<String, dynamic>>> getStaffs() async {
    String dept = await getUserDepartment();
    try {
      QuerySnapshot snapshot = await _db
          .collection('departments')
          .doc(dept)
          .collection('staffs')
          .get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching staffs: $e");
    }
  }

  Future<void> addStaff({required Map<String, dynamic> staffData}) async {
    String dept = await getUserDepartment();
    try {
      await _db
          .collection('departments')
          .doc(dept)
          .collection('staffs')
          .add(staffData);
    } catch (e) {
      throw Exception("Error adding staff: $e");
    }
  }

  // 🚀 EXAMS
  Future<List<Map<String, dynamic>>> getExams() async {
    String dept = await getUserDepartment();
    try {
      QuerySnapshot snapshot = await _db
          .collection('departments')
          .doc(dept)
          .collection('exams')
          .get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching exams: $e");
    }
  }

  Future<void> addExam({required Map<String, dynamic> examData}) async {
    String dept = await getUserDepartment();
    try {
      await _db
          .collection('departments')
          .doc(dept)
          .collection('exams')
          .add(examData);
    } catch (e) {
      throw Exception("Error adding exam: $e");
    }
  }

  // 🚀 QUESTION PAPERS
  Future<List<Map<String, dynamic>>> getQNPapers() async {
    String dept = await getUserDepartment();
    try {
      QuerySnapshot snapshot = await _db
          .collection('departments')
          .doc(dept)
          .collection('qnpapers')
          .get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching question papers: $e");
    }
  }

  Future<void> addQNPaper({required Map<String, dynamic> paperData}) async {
    String dept = await getUserDepartment();
    try {
      await _db
          .collection('departments')
          .doc(dept)
          .collection('qnpapers')
          .add(paperData);
    } catch (e) {
      throw Exception("Error adding question paper: $e");
    }
  }

  // 🚀 PLACEMENT MATERIALS
  Future<List<Map<String, dynamic>>> getPlacementMaterials() async {
    String dept = await getUserDepartment();
    try {
      QuerySnapshot snapshot = await _db
          .collection('departments')
          .doc(dept)
          .collection('placementMaterials')
          .get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching placement materials: $e");
    }
  }

  Future<void> addPlacementMaterial(
      {required Map<String, dynamic> materialData}) async {
    String dept = await getUserDepartment();
    try {
      await _db
          .collection('departments')
          .doc(dept)
          .collection('placementMaterials')
          .add(materialData);
    } catch (e) {
      throw Exception("Error adding placement material: $e");
    }
  }

  Future<void> addPlacementInfo(
      {required Map<String, dynamic> infoData}) async {
    String dept = await getUserDepartment();
    try {
      await _db
          .collection('departments')
          .doc(dept)
          .collection('placement_info')
          .add(infoData);
    } catch (e) {
      throw Exception("Error adding placement info: $e");
    }
  }

  // Retrieve Placement Information (for student use)
  Future<List<Map<String, dynamic>>> getPlacementInfo() async {
    String dept = await getUserDepartment();
    try {
      QuerySnapshot snapshot = await _db
          .collection('departments')
          .doc(dept)
          .collection('placement_info')
          .get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching placement info: $e");
    }
  }
}
