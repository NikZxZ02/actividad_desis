import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String pdfPreview;
  const PdfPreviewScreen({super.key, required this.pdfPreview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vista Previa",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: Scaffold(
        backgroundColor: Colors.grey,
        body: Padding(
          padding: const EdgeInsets.only(
            right: 10.0,
            left: 10.0,
            top: 5.0,
            bottom: 150,
          ),
          child: PDFView(
            filePath: pdfPreview,
            autoSpacing: false,
            onViewCreated: (PDFViewController pdfViewController) {
              pdfViewController.setPage(0);
            },
          ),
        ),
      ),
    );
  }
}
