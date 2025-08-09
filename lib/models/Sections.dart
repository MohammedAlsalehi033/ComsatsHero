import 'package:cloud_firestore/cloud_firestore.dart';

class Sections {
  static final CollectionReference sectionsCollection = FirebaseFirestore.instance.collection('exam_timings');

  // Get all section names (document IDs)
  static Future<List<String>> getAllSections() async {
    QuerySnapshot querySnapshot = await sectionsCollection.get();
    List<String> sectionNames = querySnapshot.docs.map((doc) => doc.id).toList();
    return sectionNames;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getLastTimeUpdated (){
    return FirebaseFirestore.instance.collection("generals").doc("examsTimingUpdateTime").get();
  }

  static Stream<DocumentSnapshot> getExamTimings(String sectionName) {
    return sectionsCollection.doc(sectionName).snapshots();
  }






}
