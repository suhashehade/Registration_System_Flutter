import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/authController.dart';
import 'package:registration_app/controllers/showPagesController.dart';

class SideBar extends GetView<ShowPagesController> {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Drawer(
        width: 200.0,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const DrawerHeader(
                child: Center(
                  child: Text('Registration App'),
                ),
              ),
              ListTile(
                title: const Text('Users'),
                onTap: () {
                  Get.back();
                  controller.toggleCurrentPage('users');
                },
              ),
              ListTile(
                title: const Text('Orders'),
                onTap: () {
                  Get.back();
                  controller.toggleCurrentPage('orders');
                },
              ),
              ListTile(
                title: const Text('Currencies'),
                onTap: () {
                  Get.back();
                  controller.toggleCurrentPage('currencies');
                },
              ),
              ListTile(
                title: IconButton(
                  onPressed: () async {
                    authController.logout();
                    Get.offNamed('/');
                  },
                  icon: const Icon(Icons.logout),
                ),
              )
            ],
          ),
        ));
  }
}
