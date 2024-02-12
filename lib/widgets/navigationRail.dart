import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/navigationRailController.dart';

class CustomNavigationRail extends GetView<NavigationRailController> {
  const CustomNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationRailController());
    return NavigationRail(
      indicatorColor: const Color.fromARGB(255, 243, 239, 204),
      selectedIconTheme: const IconThemeData(
        color: Color.fromARGB(255, 64, 99, 67),
        fill: 1,
      ),
      selectedLabelTextStyle: const TextStyle(
        color: Color.fromARGB(255, 64, 99, 67),
      ),
      unselectedIconTheme: const IconThemeData(
        color: Color.fromARGB(255, 64, 99, 67),
        fill: 1,
      ),
      onDestinationSelected: (int index) {
        controller.changeIndex(index);
        if (controller.index.value == 0) {
          Get.offNamed('/archive');
        } else {
          if (controller.index.value == 1) {
            Get.offNamed('/orders');
          } else {
            if (controller.index.value == 2) {
              Get.offNamed('/currencies');
            }
          }
        }
      },
      labelType: NavigationRailLabelType.all,
      selectedIndex: controller.index.value,
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Users"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.payment),
          label: Text("Orders"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.currency_exchange),
          label: Text("Currencies"),
        )
      ],
    );
  }
}
