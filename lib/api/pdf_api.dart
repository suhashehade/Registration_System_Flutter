import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "package:pdf/widgets.dart";

class PdfApi {
  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<void> readFile(File file) async {
    try {
      List<int> contents = await file.readAsBytes();
      String s = utf8.decode(contents, allowMalformed: true);
      print(s.toString());
    } on Exception catch (e) {
      print(e);
    }
  }
}
