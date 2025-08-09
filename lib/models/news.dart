import 'package:cloud_firestore/cloud_firestore.dart';

class news {
  static final DocumentReference subjectsDoc = FirebaseFirestore.instance.collection('generals').doc('news');



  static Future<List<String>> getNews() async {
    DocumentSnapshot docSnapshot = await subjectsDoc.get();
    if (docSnapshot.exists) {
      List<dynamic> newsDynamic = docSnapshot['news'];
      return List<String>.from(newsDynamic);
    } else {
      return [];
    }
  }
}
