import 'package:comsats_hero/theme/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:provider/provider.dart';
import '../models/users.dart';
import '../services/uploadService.dart';
import '../services/file_picker_service.dart';
import '../services/document_scanner_service.dart';
import '../widgets/MyDropDownSearch.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<File> _selectedFiles = [];
  bool _isUploading = false;
  String? selectedYear;
  String? selectedType;
  String? selectedSubject;

  final FilePickerService _filePickerService = FilePickerService();
  final DocumentScannerService _documentScannerService = DocumentScannerService();

  Future<void> _pickFiles() async {
    List<File> files = await _filePickerService.pickFiles();
    setState(() {
      _selectedFiles = files;
    });
  }

  Future<void> _scanDocuments() async {
    List<File> files = await _documentScannerService.scanDocuments();
    setState(() {
      _selectedFiles = files;
    });
  }

  Future<void> _combineAndUploadFiles() async {
    if (await UserService.isUserBlocked(currentUser!.email!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You were blocked By admin')),
      );
      return;
    }

    double totalFilesSize = 0;
    for (var file in _selectedFiles) {
      totalFilesSize += file.lengthSync();
    }

    if (totalFilesSize / (1024 * 1024) > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Files must be less than 5 MB')),
      );
      return;
    }

    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select files')),
      );
      return;
    }

    if (selectedYear == null || selectedSubject == null || selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the proper options from above')),
      );
      return;
    }

    if (containsMultipleFilesWithPdf(_selectedFiles)) {
      if (_selectedFiles.length <= 1) {
        setState(() {
          _isUploading = true;
        });

        await PdfCompressor.compressPdfFile(_selectedFiles[0].path, "${_selectedFiles[0].path}compressed", CompressQuality.HIGH);
        File _compressedFile = File("${_selectedFiles[0].path}compressed");
        await UploadService.uploadAndAddPaper(_compressedFile, selectedYear!, selectedSubject!, selectedType!, currentUser!.email!);
        setState(() {
          _isUploading = false;
        });
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Files uploaded successfully')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can't upload multiple files containing PDFs")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final combinedPdf = await UploadService.combineFilesToPdf(_selectedFiles);
      await PdfCompressor.compressPdfFile(combinedPdf.path, "${combinedPdf.path}compressed", CompressQuality.HIGH);
      File _compressedPDF = File("${combinedPdf.path}compressed");
      await UploadService.uploadAndAddPaper(_compressedPDF, selectedYear!, selectedSubject!, selectedType!, currentUser!.email!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Files combined and uploaded successfully')),
      );
      setState(() {
        _selectedFiles = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    }

    setState(() {
      _isUploading = false;
    });

    Navigator.pop(context);
  }

  bool isPDF(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType != null && mimeType.contains('application/pdf');
  }

  bool containsMultipleFilesWithPdf(List<File> files) {
    for (var file in files) {
      if (isPDF(file.path)) {
        return true;
      }
    }
    return false;
  }

  void setSubject(String? subject) {
    setState(() {
      selectedSubject = subject;
    });
  }

  void setYear(String? year) {
    setState(() {
      selectedYear = year;
    });
  }

  void setType(String? type) {
    setState(() {
      selectedType = type;
    });
  }

  double _getTotalFileSizeInMb() {
    double totalFilesSize = 0;
    for (var file in _selectedFiles) {
      totalFilesSize += file.lengthSync();
    }
    return totalFilesSize / (1024 * 1024);
  }

  @override
  Widget build(BuildContext context) {
    double totalFileSizeInMb = _getTotalFileSizeInMb();
    double percentage = totalFileSizeInMb / 5;
    final myColors = Provider.of<MyColors>(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColors.primaryColorLight,
        title: const Text('Upload Papers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Upload Papers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Having multiple photos for the exam? Select all your photos at once for quick and easy merging.',
                style: TextStyle(color: myColors.textColorSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Mydropdownsearch(setSubject: setSubject, setType: setType, setYear: setYear),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickFiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColors.primaryColorLight,
                      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.file_upload, size: 50),
                        SizedBox(height: 10),
                        Text('Select Files', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _scanDocuments,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColors.primaryColorLight,
                      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, size: 50),
                        SizedBox(height: 10),
                        Text('Scan Document', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _selectedFiles.isNotEmpty
                  ? Column(
                children: [
                  SingleChildScrollView(scrollDirection: Axis.horizontal,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _selectedFiles.map((file) {
                            int fileSize = file.lengthSync();
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                              path.basename(file.path).length >= 30 ?
                                    path.basename(file.path).substring(0,30) + "....." : path.basename(file.path),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "      ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB",
                                    style: TextStyle(fontSize: 16, color: myColors.textColorSecondary),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: percentage > 1 ? 1 : percentage,
                    center: Text(
                      "${totalFileSizeInMb.toStringAsFixed(2)} / 5 MB",
                      style: TextStyle(fontSize: 16, color: percentage > 1 ? Colors.red : myColors.textColorPrimary),
                    ),
                    progressColor: percentage > 1 ? Colors.red : myColors.primaryColorLight,
                    backgroundColor: myColors.textColorSecondary.withOpacity(0.2),
                  ),
                ],
              )
                  : const Text('No files selected', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.primaryColorLight,
                ),
                onPressed: _combineAndUploadFiles,
                child:  Text('Combine and Upload', style: TextStyle(color: myColors.textColorLight)),
              ),
              const SizedBox(height: 20),
              const Text(
                "Only select 'Any' if you are not sure about the paper info (i.e., year and type)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
