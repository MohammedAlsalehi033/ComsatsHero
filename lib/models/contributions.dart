import 'package:cloud_firestore/cloud_firestore.dart';

class ContributionService {
  final CollectionReference contributionsCollection = FirebaseFirestore.instance.collection('contributions');

  Future<DocumentReference<Object?>> addContribution(String userId, String paperId) async {
    return await contributionsCollection.add({
      'userId': userId,
      'paperId': paperId,
      'date': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getContributions() {
    return contributionsCollection.snapshots();
  }
}
