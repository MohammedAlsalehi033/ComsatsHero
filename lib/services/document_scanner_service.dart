import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class DocumentScannerService {
  Future<List<File>> scanDocuments() async {
    List<String> scannedFiles = await CunningDocumentScanner.getPictures() ?? [];
    return scannedFiles.map((path) => File(path)).toList();
  }
}
