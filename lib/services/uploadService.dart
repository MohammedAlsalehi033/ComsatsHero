import 'dart:io';
import 'package:comsats_hero/models/papers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadService {
  static Future<void> uploadAndAddPaper(File file, String year, String subject,String type, String userId) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$userId/papers/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      PaperService.addPaper(year,subject,type,userId,storageRef.fullPath,downloadURL);
    } catch (e) {
      rethrow;
    }
  }
}
