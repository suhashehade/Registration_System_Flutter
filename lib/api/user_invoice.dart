import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import "package:pdf/widgets.dart" as pw;
import 'package:printing/printing.dart';
import 'package:registration_app/api/pdf_api.dart';
import 'package:registration_app/api/pdf_widgets.dart';
import 'package:registration_app/models/user_invoice.dart';

class UserInvoicePdf {
  static Future generate(invoice) async {
    final pdf = pw.Document();

    ByteData bytes = await rootBundle.load('assets/images/spinel_logo.jpg');
    Uint8List logobytes = bytes.buffer.asUint8List();
    double total = 0.0;
    for (var o in invoice.userOrders) {
      total += (o['rate'] * o['amount']);
    }
    final headers = [
      '#',
      'Type',
      'Currency',
      'Amount',
      'Equal Amount',
      'Status',
      'Order Date'
    ];

    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.openSansRegular(),
          bold: await PdfGoogleFonts.openSansRegular(),
          icons: await PdfGoogleFonts.openSansRegular(), // this line
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              PDFWidgets.Logo(logobytes),
              PDFWidgets.Header(invoice),
              pw.Divider(),
              Body(invoice, headers, total),
              pw.Divider(),
              PDFWidgets.Footer(invoice),
            ]));

    return await PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  // ignore: non_constant_identifier_names
  static HeaderTable(List header) =>
      pw.TableRow(children: header.map((h) => pw.Text(h)).toList());

  // ignore: non_constant_identifier_names
  static pw.Widget Body(UserInvoice invoice, List header, double total) =>
      pw.Column(children: [
        pw.Table(
            border: const pw.TableBorder(bottom: pw.BorderSide(width: 1)),
            children: [
              pw.TableRow(children: header.map((h) => pw.Text(h)).toList()),
              for (var i = 0; i < invoice.userOrders.length; i++)
                pw.TableRow(children: [
                  pw.Text('0${i + 1}'),
                  pw.Text('${invoice.userOrders[i]['type']}'),
                  pw.Text('${invoice.userOrders[i]['currencyName']}'),
                  pw.Text('${invoice.userOrders[i]['amount']}'),
                  pw.Text('${invoice.userOrders[i]['equalAmount']}'),
                  pw.Text(invoice.userOrders[i]['state'] == 1
                      ? "Paid"
                      : "Not Paid"),
                  pw.Text(invoice.userOrders[i]['orderDate']),
                ]),
            ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Container(
            margin: const pw.EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            decoration: pw.BoxDecoration(
              border: const pw.Border.fromBorderSide(pw.BorderSide(width: 1.0)),
              color: PdfColor.fromHex('#406343'),
            ),
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(
              'Total: $total NIS',
              style: pw.TextStyle(
                color: PdfColor.fromHex('#f3efcc'),
              ),
            ),
          ),
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
