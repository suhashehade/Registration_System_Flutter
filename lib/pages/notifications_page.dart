import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/message_notification_controller.dart';

class NotificationsPage extends GetView<MessageNotificationController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MessageNotificationController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GetX<MessageNotificationController>(
              builder: (MessageNotificationController controller) {
            return ListView(
              children: controller.notifications
                  .map((n) => Text(n.body.value.toString()))
                  .toList(),
            );
          })),
    );
  }
}
