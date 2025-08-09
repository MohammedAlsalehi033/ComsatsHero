import 'package:comsats_hero/theme/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class _UploadScreenState extends State<UploadScreen> with AutomaticKeepAliveClientMixin {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<File> _selectedFiles = [];
  bool _isUploading = false;
  String? selectedYear;
  String? selectedType;
  String? selectedSubject;

  final FilePickerService _filePickerService = FilePickerService();
  final DocumentScannerService _documentScannerService = DocumentScannerService();

  @override
  bool get wantKeepAlive => true;

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
    bool _isPDF = false;
    if (await UserService.isUserBlocked(currentUser!.email!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You were blocked by admin')),
      );
      return;
    }

    double totalFilesSize = _selectedFiles.fold(0, (sum, file) => sum + file.lengthSync());

    for(var file in _selectedFiles){
       _isPDF =  file.path.contains("pdf");
       break;
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

    setState(() {
      _isUploading = true;
    });

    try {

      if (_isPDF && _selectedFiles.length > 1){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please either select multiple photos or single pdf')));
        return;
      }
     late File fileToUpload;
      if(!_isPDF){
        final combinedPdf = await UploadService.combineFilesToPdf(_selectedFiles);
        final compressedPath = "${combinedPdf.path}compressed";
        await PdfCompressor.compressPdfFile(combinedPdf.path, compressedPath, CompressQuality.HIGH);
        fileToUpload = File(compressedPath);
      }
      else {
        fileToUpload = File(_selectedFiles[0].path);
      }


      await UploadService.uploadAndAddPaper(
        fileToUpload,
        selectedYear!,
        selectedSubject!,
        selectedType!,
        currentUser!.email!,
      );

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
    } finally {
      setState(() {
        _isUploading = false;
      });
    }

    Navigator.pop(context);
  }

  double _getTotalFileSizeInMb() {
    return _selectedFiles.fold(0, (sum, file) => sum + file.lengthSync()) / (1024 * 1024);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double totalFileSizeInMb = _getTotalFileSizeInMb();
    double percentage = totalFileSizeInMb / 5;
    final myColors = Provider.of<MyColors>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColors.primaryColorLight,
        centerTitle: true,
        title: Text(
          'Upload Papers',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Having multiple photos for the exam? Select all your photos at once for quick and easy merging.',
                      style: TextStyle(color: myColors.textColorSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Mydropdownsearch(
                      setSubject: (value) => setState(() => selectedSubject = value),
                      setType: (value) => setState(() => selectedType = value),
                      setYear: (value) => setState(() => selectedYear = value),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _pickFiles,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColors.primaryColorLight,
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.file_upload, size: 40),
                              SizedBox(height: 10),
                              Text('Select Files'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _scanDocuments,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myColors.primaryColorLight,
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.camera_alt, size: 40),
                              SizedBox(height: 10),
                              Text('Scan Document'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _selectedFiles.isNotEmpty
                        ? Column(
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: _selectedFiles.map((file) {
                                int fileSize = file.lengthSync();
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        path.basename(file.path),
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB",
                                      style: TextStyle(fontSize: 14, color: myColors.textColorSecondary),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 8.0,
                          percent: percentage.clamp(0.0, 1.0),
                          center: Text(
                            "${totalFileSizeInMb.toStringAsFixed(2)} / 5 MB",
                            style: TextStyle(fontSize: 14, color: myColors.textColorPrimary),
                          ),
                          progressColor: percentage > 1 ? Colors.red : myColors.primaryColorLight,
                          backgroundColor: myColors.textColorSecondary.withOpacity(0.2),
                        ),
                      ],
                    )
                        : const Center(child: Text('No files selected')),
                    const SizedBox(height: 20),
                    _isUploading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myColors.primaryColorLight,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _combineAndUploadFiles,
                      child: const Text('Combine and Upload'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}