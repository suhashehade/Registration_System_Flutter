import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/user_controller.dart';

// ignore: must_be_immutable
class Archive extends GetView<UserController> {
  final Widget body;
  final Text title;
  final Function addBtnFuction;
  const Archive(
      {super.key,
      required this.body,
      required this.title,
      required this.addBtnFuction});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        onPressed: () {
          addBtnFuction();
        },
        child: const Icon(
          Icons.add,
          size: 30.0,
          color: Color.fromARGB(255, 243, 239, 204),
        ),
      ),
      body: body,
    );
  }
}
