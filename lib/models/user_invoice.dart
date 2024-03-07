import 'package:registration_app/models/invoice_info.dart';
import 'package:registration_app/models/user.dart';

class UserInvoice {
  UserInvoice(
      {required this.userOrders,
      required this.supplier,
      required this.customer,
      required this.invoiceInfo});

  final List userOrders;
  final CustomUser supplier;
  final CustomUser customer;
  final InvoiceInfo invoiceInfo;
}
