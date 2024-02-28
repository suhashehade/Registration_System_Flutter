import 'package:registration_app/models/currency.dart';
import 'package:registration_app/models/order.dart';
import 'package:registration_app/models/user.dart';

class OrderArgument {
  final int id;
  final Order order;
  final User user;
  final Currency currency;

  OrderArgument(
      {required this.id,
      required this.user,
      required this.currency,
      required this.order});
}
