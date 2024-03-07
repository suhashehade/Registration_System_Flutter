import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import "package:pdf/widgets.dart" as pw;
import 'package:printing/printing.dart';
import 'package:registration_app/api/pdf_widgets.dart';
import 'package:registration_app/api/pdf_api.dart';
import 'package:registration_app/models/invoice.dart';

class PdfInoviceApi {
  static Future generate(invoice) async {
    final pdf = pw.Document();
    ByteData bytes = await rootBundle.load('assets/images/spinel_logo.jpg');
    Uint8List logobytes = bytes.buffer.asUint8List();

    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.openSansRegular(),
          bold: await PdfGoogleFonts.openSansBold(),
          icons: await PdfGoogleFonts.materialIcons(), // this line
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              PDFWidgets.Logo(logobytes),
              PDFWidgets.Header(invoice),
              pw.Divider(),
              Body(invoice),
              pw.Divider(),
              PDFWidgets.Footer(invoice),
            ]));

    return await PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  // ignore: non_constant_identifier_names
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
}
