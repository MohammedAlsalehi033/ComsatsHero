import 'package:comsats_hero/models/users.dart';
import 'package:comsats_hero/widgets/Cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/papers.dart';import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class VerifiedPapersScreen extends StatefulWidget {
  @override
  _VerifiedPapersScreenState createState() => _VerifiedPapersScreenState();
}

class _VerifiedPapersScreenState extends State<VerifiedPapersScreen> {
  bool isAdmin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
  }

  Future<void> checkAdminStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admins').doc(user.email).get();

      if (adminDoc.exists) {
        setState(() {
          isAdmin = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You do not have access to this page.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to an application page or provide instructions to become an admin
                },
                child: Text('Become an Admin'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: PaperService.getUnVerifiedPapers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final papers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: papers.length,
            itemBuilder: (context, index) {
              var paper = papers[index];
              return MyCards.cardForAdminVerification(context, paper);
            },
          );
        },
      ),
    );
  }
}

class PaperDetailScreen extends StatelessWidget {
  final DocumentSnapshot paper;

  PaperDetailScreen({required this.paper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${paper['subject']}, ${paper['type']}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text('User: ${paper['userId']}'),
            SizedBox(height: 20),
            Expanded(
              child: PDFviewerAndVerifier(
                downloadablePath: paper['downloadURL'], // Ensure 'filePath' exists in paper document
                paper: paper,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await PaperService.verifyPaper(paper);
                Navigator.pop(context);
              },
              child: Text('Verify Paper'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
            await UserService.blockUser(paper['userId']);
            await PaperService.deletePaper(paper.id);
            Navigator.pop(context);
              },
              child: Text('Block User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFviewerAndVerifier extends StatefulWidget {
  const PDFviewerAndVerifier({super.key, required this.downloadablePath, required this.paper});

  final String downloadablePath;
  final DocumentSnapshot paper;

  @override
  State<PDFviewerAndVerifier> createState() => _PDFviewerAndVerifierState();
}

class _PDFviewerAndVerifierState extends State<PDFviewerAndVerifier> {
  late PdfViewerController _pdfViewerController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.downloadablePath,
            controller: _pdfViewerController,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              setState(() {
                _isLoading = false;
                _isError = true;
              });
              print('PDF loading failed: ${details.error}');
            },
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _isLoading = false;
              });
              print('PDF loaded successfully');
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isError)
            Center(
              child: Text('Failed to load PDF'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}