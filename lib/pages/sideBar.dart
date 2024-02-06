import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/authController.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Drawer(
        child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Registration App'),
          ),
        ),
        ListTile(
          title: const Text('Users'),
          onTap: () {
            Get.offNamed('/archive');
          },
        ),
        ListTile(
          title: const Text('Orders'),
          onTap: () {
            Get.offNamed('/orders');
          },
        ),
        ListTile(
          title: const Text('Curruncies'),
          onTap: () {
            Get.offNamed('/currencies');
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
    ));
  }
}
