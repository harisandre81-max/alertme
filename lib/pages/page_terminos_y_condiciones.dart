import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TerminosUIPage extends StatelessWidget {
  const TerminosUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E3),
      appBar: AppBar(
  centerTitle: true, // 👈 centra el título
  title: const Text(
    'Términos y Condiciones',
    style: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w600,
    ),
  ),
  backgroundColor: const Color(0xFFE6F0D5),
  iconTheme: const IconThemeData(color: Colors.deepPurple),
),

body:  SfPdfViewer.asset(
        'assets/pdfs/terminos.pdf',
      ),

    );
  }
}