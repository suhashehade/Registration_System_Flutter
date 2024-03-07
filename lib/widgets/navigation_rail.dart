import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/navigation_rail_controller.dart';
import 'package:registration_app/controllers/auth_controller.dart';
import 'package:registration_app/controllers/show_pages_controller.dart';

class CustomNavigationRail extends GetView<NavigationRailController> {
  const CustomNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationRailController());
    ShowPagesController showPagesController = Get.put(ShowPagesController());
    AuthController authController = Get.put(AuthController());
    return GetX<NavigationRailController>(
        builder: (NavigationRailController controller) {
      return NavigationRail(
        useIndicator: true,
        indicatorColor: const Color.fromARGB(255, 243, 239, 204),
        selectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 50, 80, 46),
        ),
        selectedLabelTextStyle: const TextStyle(
          color: Color.fromARGB(255, 50, 80, 46),
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: Color.fromARGB(255, 64, 99, 67),
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 64, 99, 67),
        ),
        onDestinationSelected: (int index) {
          controller.changeIndex(index);

          if (controller.index.value == 0) {
            showPagesController.toggleCurrentPage('users');
          } else {
            if (controller.index.value == 1) {
              showPagesController.toggleCurrentPage('orders');
            } else {
              if (controller.index.value == 2) {
                showPagesController.toggleCurrentPage('currencies');
              }
            }
          }
        },
        labelType: NavigationRailLabelType.all,
        selectedIndex: controller.index.value,
        destinations: <NavigationRailDestination>[
          const NavigationRailDestination(
            icon: Icon(Icons.home),
            label: Text("Users"),
          ),
          const NavigationRailDestination(
            icon: Icon(Icons.payment),
            label: Text("Orders"),
          ),
          const NavigationRailDestination(
            icon: Icon(Icons.currency_exchange),
            label: Text("Currencies"),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.logout),
            label: InkWell(
              child: const Text("Logout"),
              onTap: () {
                authController.logout();
                Get.offNamed('/');
              },
            ),
          ),
        ],
      );
    });
  }
}
