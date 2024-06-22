import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFviewer extends StatefulWidget {
  const PDFviewer({super.key, required this.downloadablePath});

  final String downloadablePath;

  @override
  State<PDFviewer> createState() => _PDFviewerState();
}

class _PDFviewerState extends State<PDFviewer> {
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
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
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
