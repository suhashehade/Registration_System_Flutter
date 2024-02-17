import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/pages/ordersArchive.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    Get.put(CurrenciesController());

    return Archive(
      title: const Text('Orders'),
      body: Orders(),
      addBtnFuction: () {
        Get.offNamed('/addOrder');
      },
    );
  }
}
