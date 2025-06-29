import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/result.dart';

class ResultService {
  final CollectionReference resultsCollection =
      FirebaseFirestore.instance.collection('pastResults');

  // Save a quiz result
  Future<void> saveResult(QuizResult result) async {
    await resultsCollection.doc(result.id).set(result.toJson());
  }

  // Get a result by ID
  Future<QuizResult?> getResult(String resultId) async {
    final doc = await resultsCollection.doc(resultId).get();
    if (!doc.exists) return null;
    return QuizResult.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Get all results for a user (by adminEmail)
  Future<List<QuizResult>> getResultsForUser(String adminEmail) async {
    final query = await resultsCollection
        .where('adminEmail', isEqualTo: adminEmail)
        .get();
    return query.docs
        .map((doc) =>
            QuizResult.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
