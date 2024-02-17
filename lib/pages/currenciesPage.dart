import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/pages/currenciesArchive.dart';

class CurrenciesPage extends GetView<CurrenciesController> {
  const CurrenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CurrenciesController());
    return Archive(
      title: const Text('Currencies'),
      body: Currencies(),
      addBtnFuction: () {
        Get.offNamed('/addCurrency');
      },
    );
  }
}
