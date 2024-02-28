import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class UserInvoiceOrdersPdf extends StatelessWidget {
  UserInvoiceOrdersPdf({super.key});
  String pdf = Get.arguments['file'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Invoice'),
        ),
        body: PDFView(
          filePath: pdf,
        ));
  }
}
