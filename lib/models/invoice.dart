import 'package:registration_app/models/currency.dart';
import 'package:registration_app/models/invoice_info.dart';
import 'package:registration_app/models/order.dart';
import 'package:registration_app/models/user.dart';

class Invoice {
  final Order order;
  final CustomUser customer;
  final CustomUser supplier;
  final Currency currency;
  final InvoiceInfo invoiceInfo;
  Invoice(
      {required this.order,
      required this.supplier,
      required this.customer,
      required this.currency,
      required this.invoiceInfo});
}
