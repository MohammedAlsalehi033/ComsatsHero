import 'package:cloud_firestore/cloud_firestore.dart';

class MyTypes {
  static final DocumentReference subjectsDoc = FirebaseFirestore.instance.collection('generals').doc('types');



  static Future<List<String>> getTypes() async {
    DocumentSnapshot docSnapshot = await subjectsDoc.get();
    if (docSnapshot.exists) {
      List<dynamic> subjectsDynamic = docSnapshot['types'];
      return List<String>.from(subjectsDynamic);
    } else {
      return [];
    }
  }
}
