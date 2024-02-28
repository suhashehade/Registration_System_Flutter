import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/widgets/orderCard.dart';

class OrderList extends GetView<OrderController> {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    List orders = controller.orders;
    return GetX<OrderController>(builder: (OrderController controller) {
      return Expanded(
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(index: index);
          },
        ),
      );
    });
  }
}
