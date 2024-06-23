import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<List<File>> pickFiles({bool allowMultiple = true}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: allowMultiple);

    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    }
    return [];
  }
}
