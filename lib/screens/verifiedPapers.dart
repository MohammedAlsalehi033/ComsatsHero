import 'package:comsats_hero/models/users.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/widgets/Cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/papers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.email)
          .get();

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

class PaperDetailScreen extends StatefulWidget {
  final DocumentSnapshot paper;

  PaperDetailScreen({required this.paper});

  @override
  _PaperDetailScreenState createState() => _PaperDetailScreenState();
}

class _PaperDetailScreenState extends State<PaperDetailScreen> {
  List<DocumentSnapshot> similarPapers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSimilarPapers();
  }

  Future<void> fetchSimilarPapers() async {
    try {
      final papers = await PaperService.fetchSimilarPapers(
        widget.paper['subject'],
        widget.paper['type'],
        widget.paper['year'], // Ensure 'year' exists in paper document
        widget.paper.id,
      );
      setState(() {
        similarPapers = papers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch similar papers: $e')),
      );
    }
  }

  void navigateToPaperDetail(DocumentSnapshot paper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaperDetailScreen(paper: paper),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = (widget.paper['uploadDate'] as Timestamp).toDate();
    return Scaffold(floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton.large(onPressed: () async {
            await PaperService.verifyPaper(widget.paper);
            Navigator.pop(context);
          },child: Icon(Icons.check_circle),tooltip: "verify the paper",heroTag: "1",),
          FloatingActionButton.large(onPressed: () async {
            await PaperService.deletePaper(widget.paper.id);
            await UserService.decreaseRank(widget.paper['userId']);
            Navigator.pop(context);
          },child: Icon(Icons.delete),tooltip: "delete the paper",heroTag: "2",),
          FloatingActionButton.large(onPressed: () async {
            await UserService.blockUser(widget.paper['userId']);
            await PaperService.deletePaper(widget.paper.id);
            Navigator.pop(context);
          },child: Icon(Icons.block),tooltip: "block the user",splashColor: Colors.red,backgroundColor: Colors.redAccent,heroTag: "3",),
        ],
      ),
      appBar: AppBar(
        title: Text("${widget.paper['subject']}, ${widget.paper['type']}"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text('User: ${widget.paper['userId']}'),
                  Text('Year: ${widget.paper['year']}'),
                  Text(
                      'Updated at: ${dt.year}/${dt.month}/${dt.day} at ${dt.hour}:${(dt.minute < 10) ? "0" + dt.minute.toString() : dt.minute}'), // this line is just to ensure the minutes format i.e 00 at the end
                  SizedBox(height: 20),
                  Expanded(
                    child: PDFviewerAndVerifier(
                      downloadablePath: widget.paper['downloadURL'],
                      paper: widget.paper,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (similarPapers.isNotEmpty) ...[
                    Text(
                      'Similar Papers Found:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: similarPapers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(similarPapers[index]['verified']
                              ? Icons.check_circle
                              : Icons.cancel),
                          title: Text(
                              "${similarPapers[index]['subject']}, ${similarPapers[index]['type']}"),
                          subtitle:
                              Text("Year: ${similarPapers[index]['year']}"),
                          onTap: () =>
                              navigateToPaperDetail(similarPapers[index]),
                        );
                      },
                    ),
                    SizedBox(height: 120,)
                  ],
                ],
              ),
            ),
    );
  }
}

class PDFviewerAndVerifier extends StatefulWidget {
  const PDFviewerAndVerifier(
      {super.key, required this.downloadablePath, required this.paper});

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
