import 'package:get/get.dart';
import 'package:registration_app/models/notification_message.dart';

class MessageNotificationController extends GetxController {
  RxString title = ''.obs;
  RxString body = ''.obs;
  RxInt count = 0.obs;
  RxList notifications = [].obs;
  Map<String, dynamic> payload = <String, dynamic>{}.obs;

  updateMessage(NotificationMessage message) {
    title.value = message.title;
    body.value = message.body;
    payload = message.payload;
    notifications.add(message);
  }

  addMessage() {
    notifications.add(NotificationMessage(
        title: title.value, body: body.value, payload: payload));
    increaseCount();
  }

  increaseCount() {
    count.value += 1;
  }

  decreaseCount() {
    count.value -= 1;
  }
}
