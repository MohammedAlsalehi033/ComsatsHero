import 'package:cloud_firestore/cloud_firestore.dart';

class PaperService {
  static final CollectionReference papersCollection = FirebaseFirestore.instance.collection('papers');

  static Future<DocumentReference<Object?>> addPaper(String year, String subject, String type, String userId, String filePath, String downloadURL) async {
    return await papersCollection.add({
      'year': year,
      'subject': subject,
      'uploadDate': Timestamp.now(),
      'userId': userId,
      'filePath': filePath,
      'downloadURL': downloadURL,
      'verified': false,
      'type': type,
    });
  }

  static Stream<QuerySnapshot> getPapers() {
    return papersCollection.snapshots();
  }

  static Stream<QuerySnapshot> getVerifiedPapers() {
    return papersCollection.where('verified', isEqualTo: true).snapshots();
  }

  static Stream<QuerySnapshot> getUnVerifiedPapers() {
    return FirebaseFirestore.instance
        .collection('papers')
        .where('verified', isEqualTo: false)
        .orderBy('uploadDate', descending: true) // Correct usage of orderBy
        .snapshots();
  }

  static Stream<QuerySnapshot> searchPapers({
    required String subject,
    String? year,
    String? type,
  }) {
    Query query = papersCollection.where('subject', isEqualTo: subject)
        .where('verified', isEqualTo: true);

    if (year != null && year.isNotEmpty) {
      query = query.where('year', isEqualTo: year);
    }

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }

    return query.snapshots();
  }



  static Future<void> verifyPaper(DocumentSnapshot paper) async {
    await FirebaseFirestore.instance.collection('papers').doc(paper.id).update({
      'verified': true,
    });
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(paper['userId']).get();
    if (userDoc.exists) {
      int currentRanking = userDoc['rank'] ?? 0;
      await FirebaseFirestore.instance.collection('users').doc(paper['userId']).update({
        'rank': currentRanking + 1,
      });
    }
  }

  static Future<void> deletePaper(String id)async {
    await FirebaseFirestore.instance.collection("papers").doc(id).delete();
  }

}
