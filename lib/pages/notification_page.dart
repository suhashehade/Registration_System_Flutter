import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.arguments['message'].notification!.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text(
          Get.arguments['message'].notification!.body,
          style: const TextStyle(fontSize: 30.0, color: Colors.green),
        )),
      ),
    );
  }
}
