import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/message_notification_controller.dart';
import 'package:registration_app/controllers/show_pages_controller.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/pages/currencies_page.dart';
import 'package:registration_app/pages/orders_page.dart';
import 'package:registration_app/widgets/sidebar.dart';
import 'package:registration_app/pages/users_page.dart';

class ArchivePage extends GetView<ShowPagesController> {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MessageNotificationController());
    return Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 239, 204),
          actions: [
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Badge(
                child: Icon(Icons.notifications),
                label: Obx(
                  () => Text(
                    '${messageNotificationController!.count.value}',
                  ),
                ),
                backgroundColor: Colors.amber,
              ),
            )
          ],
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
