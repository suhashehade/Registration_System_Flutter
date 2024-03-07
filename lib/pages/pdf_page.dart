import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

// ignore: must_be_immutable
class PdfView extends StatelessWidget {
  PdfView({super.key});
  String pdf = Get.arguments['file'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice${DateTime.now().microsecond}'),
      ),
      body: PDFView(
        filePath: pdf,
      ),
    );
  }
}
