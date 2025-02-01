import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // STAFFS
  Future<List<Map<String, dynamic>>> getStaffs({required String department}) async {
    QuerySnapshot snapshot = await _db
        .collection('departments')
        .doc(department)
        .collection('staffs')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> addStaff({required String department, required Map<String, dynamic> staffData}) async {
    await _db
        .collection('departments')
        .doc(department)
        .collection('staffs')
        .add(staffData);
  }

  // EXAMS
  Future<List<Map<String, dynamic>>> getExams({required String department}) async {
    QuerySnapshot snapshot = await _db
        .collection('departments')
        .doc(department)
        .collection('exams')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> addExam({required String department, required Map<String, dynamic> examData}) async {
    await _db
        .collection('departments')
        .doc(department)
        .collection('exams')
        .add(examData);
  }

  // QN PAPERS
  Future<List<Map<String, dynamic>>> getQNPapers({required String department}) async {
    QuerySnapshot snapshot = await _db
        .collection('departments')
        .doc(department)
        .collection('qnpapers')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> addQNPaper({required String department, required Map<String, dynamic> paperData}) async {
    await _db
        .collection('departments')
        .doc(department)
        .collection('qnpapers')
        .add(paperData);
  }

  // PLACEMENT MATERIALS
  Future<List<Map<String, dynamic>>> getPlacementMaterials({required String department}) async {
    QuerySnapshot snapshot = await _db
        .collection('departments')
        .doc(department)
        .collection('placementMaterials')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> addPlacementMaterial({required String department, required Map<String, dynamic> materialData}) async {
    await _db
        .collection('departments')
        .doc(department)
        .collection('placementMaterials')
        .add(materialData);
  }
}
