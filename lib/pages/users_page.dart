import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/user_controller.dart';
import 'package:registration_app/widgets/archive.dart';
import 'package:registration_app/widgets/users_archive.dart';

class UsersPage extends GetView<UserController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return Archive(
        title: const Text('Users'),
        body: Users(),
        addBtnFuction: () {
          Get.toNamed('/signUp');
        });
  }
}
