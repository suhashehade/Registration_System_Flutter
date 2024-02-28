import 'package:registration_app/models/currency.dart';
import 'package:registration_app/models/invoiceInfo.dart';
import 'package:registration_app/models/order.dart';
import 'package:registration_app/models/user.dart';

class Invoice {
  final Order order;
  final User customer;
  final User supplier;
  final Currency currency;
  final InvoiceInfo invoiceInfo;
  Invoice(
      {required this.order,
      required this.supplier,
      required this.customer,
      required this.currency,
      required this.invoiceInfo});
}
