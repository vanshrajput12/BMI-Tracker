import 'package:bmi_project/models/user_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/weight_entry_model.dart';

class DashboardService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No logged-in user found.');
    }

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists) {
      throw Exception('User profile not found.');
    }

    return UserProfile.fromMap(
      document.id,
      document.data()!,
    );
  }

  Future<List<WeightEntry>> getWeightHistory() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No logged-in user found.');
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('weightEntries')
        .orderBy('date')
        .limitToLast(7)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      final timestamp = data['date'] as Timestamp?;

      return WeightEntry(
        date: timestamp?.toDate(),
        weightKg: (data['weightKg'] as num?)?.toDouble() ?? 0,
      );
    }).toList();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}