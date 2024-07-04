import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyYears {
  static final DocumentReference subjectsDoc = FirebaseFirestore.instance.collection('generals').doc('years');



  static Future<List<String>> getYears() async {
    DocumentSnapshot docSnapshot = await subjectsDoc.get();
    if (docSnapshot.exists) {
      List<dynamic> subjectsDynamic = docSnapshot['years'];
      List<String> years = subjectsDynamic.map((e) => e.toString()).toList();

      return years;
    } else {
      return [];
    }
  }
}
