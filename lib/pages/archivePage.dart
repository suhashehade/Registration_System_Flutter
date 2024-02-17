import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/showPagesController.dart';
import 'package:registration_app/pages/currenciesPage.dart';
import 'package:registration_app/pages/ordersPage.dart';
import 'package:registration_app/pages/sideBar.dart';
import 'package:registration_app/pages/usersPage.dart';

class ArchivePage extends GetView<ShowPagesController> {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 239, 204),
        ),
        body: GetX<ShowPagesController>(
            builder: (ShowPagesController showPagesController) {
          return Container(
            child: showPagesController.currentPage.value == 'users'
                ? const UsersPage()
                : showPagesController.currentPage.value == 'orders'
                    ? const OrdersPage()
                    : showPagesController.currentPage.value == 'currencies'
                        ? const CurrenciesPage()
                        : null,
          );
        }));
  }
}
