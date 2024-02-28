import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import "package:pdf/widgets.dart" as pw;
import 'package:printing/printing.dart';
import 'package:registration_app/api/pdf_api.dart';
import 'package:registration_app/models/invoice.dart';

class PdfInoviceApi {
  static Future generate(Invoice invoice) async {
    final pdf = pw.Document();
    ByteData bytes = await rootBundle.load('assets/spinel_logo.jpg');
    Uint8List logobytes = bytes.buffer.asUint8List();

    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.openSansRegular(),
          bold: await PdfGoogleFonts.openSansBold(),
          icons: await PdfGoogleFonts.materialIcons(), // this line
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              Logo(logobytes),
              Header(invoice),
              pw.Divider(),
              Body(invoice),
              pw.Divider(),
              Footer(invoice),
            ]));

    return await PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static pw.Widget Logo(logobytes) => pw.Center(
      child: pw.Image(pw.MemoryImage(logobytes), height: 100.0, width: 100.0));

  static pw.Widget Header(Invoice invoice) =>
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

  static pw.Widget Body(Invoice invoice) => pw.Column(children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Contact Customer:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Email: ${invoice.customer.email}'),
            pw.Text('Phone No.: ${invoice.customer.phone}')
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Order Main Information:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Order Date: ${invoice.order.orderDate}'),
            pw.Text('Order Type: ${invoice.order.type}'),
            pw.Text(
                'Order Status: ${invoice.order.status == 1 ? 'Paid' : 'Not Paid'}'),
          ]),
        ]),
        pw.Divider(),
        pw.Row(children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Order Details:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Currency: ${invoice.currency.name}'),
            pw.Text('Order Amount: ${invoice.order.orderAmount}'),
            pw.Text('Equal Order Amount: ${invoice.order.equalOrderAmount}'),
            pw.Text(
                'Due To Date: ${DateFormat.yMMMd().format(DateTime(invoice.invoiceInfo.dueDate.year, invoice.invoiceInfo.dueDate.month, invoice.invoiceInfo.dueDate.day))}'),
          ]),
        ]),
        pw.Divider(),
        pw.Container(
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Terms And Conditions:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      for (int i = 0;
                          i < invoice.invoiceInfo.termsAndConditions.length;
                          i++)
                        pw.Text(invoice.invoiceInfo.termsAndConditions[i])
                    ]),
                pw.Positioned(
                  bottom: 100.0,
                  child:
                      pw.Text('Supplier Signature: ${invoice.supplier.name}'),
                )
              ]),
        )
      ]);

  static pw.Widget Footer(Invoice invoice) => pw.Container(
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
}
