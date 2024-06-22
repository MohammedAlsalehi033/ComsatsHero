import 'package:comsats_hero/models/subjexts.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/users.dart';
import '../services/uploadService.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final List<String> years = ['2022', '2021', '2020', '2019', '2018'];
  final List<String> types = ['Mid', 'Final'];
  User? currentUser = FirebaseAuth.instance.currentUser;

  final List<String> subjects = [
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science'
  ];

  List<File> _selectedFiles = [];
  bool _isUploading = false;

  String? selectedYear;
  String? selectedType;
  String? selectedSubject;

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future<void> _combineAndUploadFiles() async {
    if (await UserService.isUserBlocked(currentUser!.email!)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You were blocked By admin')),
      );
      return ;
    }



    double _totalFilesSize = 0;
    _selectedFiles.forEach((element) {
      _totalFilesSize = _totalFilesSize + element.lengthSync();
    });

    if (_totalFilesSize / (1024 * 1024) > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Files must be less than 10 MB')),
      );
    }

    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select files')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final pdf = pw.Document();
      for (var file in _selectedFiles) {
        final image = pw.MemoryImage(file.readAsBytesSync());
        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        }));
      }

      final output = File(
          '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_combined.pdf');
      await output.writeAsBytes(await pdf.save());
      if (selectedYear == null ||
          selectedSubject == null ||
          selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('please select the proper options form above')),
        );
      }
      UploadService.uploadAndAddPaper(
          output, selectedYear!, selectedSubject!, selectedType!, currentUser!.email!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Files combined and uploaded successfully')),
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

            Text('"Having multiple photos for the exam? Select all your photos at once for quick and easy merging."', style: TextStyle(color: MyColors.textColorSecondary),),
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
              onPressed: _pickFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColorLight,
              ),
              child: const Text('Select Files',  style: TextStyle(color: MyColors.textColorLight),),
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
                    onPressed: _combineAndUploadFiles,
                    child: const Text('Combine and Upload',  style: TextStyle(color: MyColors.textColorLight)),
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
