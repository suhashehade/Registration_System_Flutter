import 'package:registration_app/models/invoiceInfo.dart';
import 'package:registration_app/models/user.dart';

class UserInvoice {
  UserInvoice(
      {required this.userOrders,
      required this.supplier,
      required this.customer,
      required this.invoiceInfo});

  final List userOrders;
  final User supplier;
  final User customer;
  final InvoiceInfo invoiceInfo;
}
