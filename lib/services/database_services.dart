import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch department staffs.
  Future<List> getStaffs() async {
    QuerySnapshot snapshot = await _db.collection('staffs').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch upcoming exams.
  Future<List> getExams() async {
    QuerySnapshot snapshot = await _db.collection('exams').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch previous year question/notes papers.
  Future<List> getQNPapers() async {
    QuerySnapshot snapshot = await _db.collection('qnpapers').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch placement preparation materials.
  Future<List> getPlacementMaterials() async {
    QuerySnapshot snapshot = await _db.collection('placementMaterials').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
