import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import "package:pdf/widgets.dart" as pw;

class PDFWidgets {
  // ignore: non_constant_identifier_names
  static pw.Widget Footer(invoice) => pw.Container(
        padding: const pw.EdgeInsets.all(20.0),
        color: PdfColor.fromHex('#406343'),
        child: pw.Column(children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(children: [
                  pw.Icon(const pw.IconData(0xeba4)),
                  pw.Text('Phone: ${invoice.supplier.phone}',
                      style: pw.TextStyle(color: PdfColor.fromHex('#f3efcc'))),
                ]),
                pw.Row(children: [
                  pw.Icon(const pw.IconData(0xe22a)),
                  pw.Text('Email: ${invoice.supplier.email}',
                      style: pw.TextStyle(color: PdfColor.fromHex('#f3efcc'))),
                ])
              ])
        ]),
      );

  // ignore: non_constant_identifier_names
  static pw.Widget Logo(logobytes) => pw.Center(
      child: pw.Image(pw.MemoryImage(logobytes), height: 100.0, width: 100.0));

  // ignore: non_constant_identifier_names
  static pw.Widget Header(invoice) =>
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(children: [
          pw.Text('Invoice to '),
          pw.Text(invoice.customer.name,
              style: const pw.TextStyle(fontSize: 16.0)),
          pw.Text(invoice.customer.title,
              style: const pw.TextStyle(fontSize: 14.0)),
        ]),
        pw.Column(children: [
          pw.Text('INVOICE',
              style:
                  pw.TextStyle(fontSize: 30.0, fontWeight: pw.FontWeight.bold)),
          pw.Text('Invoice NO.: ${invoice.invoiceInfo.number}'),
          pw.Text(
              'Invoice Date: ${DateFormat.yMMMd().format(DateTime(invoice.invoiceInfo.date.year, invoice.invoiceInfo.date.month, invoice.invoiceInfo.date.day))}')
        ])
      ]);
}
