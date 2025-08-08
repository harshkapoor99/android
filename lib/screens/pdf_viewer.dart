import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String fileName;

  const PdfViewerScreen({
    super.key,
    required this.pdfPath,
    required this.fileName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.pdfPath),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: PdfView(controller: _pdfController),
    );
  }
}
