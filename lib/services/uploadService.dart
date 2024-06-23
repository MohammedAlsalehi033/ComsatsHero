import 'dart:io';
import 'package:comsats_hero/models/papers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';



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


  static Future<File> combineFilesToPdf(List<File> files) async {
    final pdf = pw.Document();
    for (var file in files) {
      final image = pw.MemoryImage(file.readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(child: pw.Image(image));
      }));
    }

    final output = File('${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}_combined.pdf');
    await output.writeAsBytes(await pdf.save());

    return output;
  }
}
