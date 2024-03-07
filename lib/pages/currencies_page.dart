import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currencies_controller.dart';
import 'package:registration_app/widgets/archive.dart';
import 'package:registration_app/widgets/currencies_archive.dart';

class CurrenciesPage extends GetView<CurrenciesController> {
  const CurrenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CurrenciesController());
    return Archive(
      title: const Text('Currencies'),
      body: Currencies(),
      addBtnFuction: () {
        Get.toNamed('/addCurrency');
      },
    );
  }
}
