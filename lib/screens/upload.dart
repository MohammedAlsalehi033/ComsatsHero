import 'package:comsats_hero/models/subjexts.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/users.dart';
import '../services/uploadService.dart';
import '../services/file_picker_service.dart';
import '../services/document_scanner_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final List<String> years = ['2022', '2021', '2020', '2019', '2018'];
  final List<String> types = ['Mid', 'Final'];
  User? currentUser = FirebaseAuth.instance.currentUser;

  List<File> _selectedFiles = [];
  bool _isUploading = false;

  String? selectedYear;
  String? selectedType;
  String? selectedSubject;

  final FilePickerService _filePickerService = FilePickerService();
  final DocumentScannerService _documentScannerService =
      DocumentScannerService();

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

    if (totalFilesSize / (1024 * 1024) > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Files must be less than 3 MB')),
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

    print(_selectedFiles.length);
    if (containsMultipleFilesWithPdf(_selectedFiles)) {
      if (_selectedFiles.length <= 1) {
        setState(() {
          _isUploading = true;
        });
        await UploadService.uploadAndAddPaper(_selectedFiles[0], selectedYear!,
            selectedSubject!, selectedType!, currentUser!.email!);
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
      await UploadService.uploadAndAddPaper(combinedPdf, selectedYear!,
          selectedSubject!, selectedType!, currentUser!.email!);

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
    bool hasPdf = false;

    for (var file in files) {
      if (isPDF(file.path)) {
          return true;
      }
    }
    return false;
  }


  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Scan Document'),
                onTap: () {
                  Navigator.of(context).pop();
                  _scanDocuments();
                },
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Upload File'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFiles();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Paper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Search for Papers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '"Having multiple photos for the exam? Select all your photos at once for quick and easy merging."',
              style: TextStyle(color: MyColors.textColorSecondary),
            ),
            const SizedBox(height: 20),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchDelay: Duration(seconds: 0),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Select Year'),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 300),
              ),
              items: years,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
              selectedItem: selectedYear,
            ),
            const SizedBox(height: 20),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Select Type'),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 300),
              ),
              items: types,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              selectedItem: selectedType,
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: MySubjects.getSubjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading subjects');
                } else {
                  final subjects = snapshot.data ?? [];
                  return DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      showSearchBox: true,
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('Select Subject'),
                      ),
                      fit: FlexFit.loose,
                      constraints: const BoxConstraints(maxHeight: 300),
                    ),
                    items: subjects,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value;
                      });
                    },
                    selectedItem: selectedSubject,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColorLight,
              ),
              child: const Text(
                'Select Files',
                style: TextStyle(color: MyColors.textColorLight),
              ),
            ),
            const SizedBox(height: 16),
            _selectedFiles.isNotEmpty
                ? Text(
                    'Selected Files: ${_selectedFiles.map((file) => path.basename(file.path)).join(', ')}')
                : const Text('No files selected'),
            const SizedBox(height: 16),
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColorLight,
                    ),
                    onPressed: ()async{
                      await _combineAndUploadFiles();
                    },
                    child: const Text('Combine and Upload',
                        style: TextStyle(color: MyColors.textColorLight)),
                  ),
            _selectedFiles.isNotEmpty
                ? Column(
                    children: _selectedFiles.map((file) {
                      int fileSize = file.lengthSync();
                      return Text(
                        "Size of the file " +
                            (fileSize / (1024 * 1024))
                                .toString()
                                .substring(0, 5) +
                            "MB",
                        textAlign: TextAlign.left,
                      );
                    }).toList(),
                  )
                : const Text('No files selected'),
          ],
        ),
      ),
    );
  }
}
