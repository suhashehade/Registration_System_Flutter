import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/notification_message.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification!.title}');
  print('Body: ${message.notification!.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final firebaseMessageing = FirebaseMessaging.instance;

  final androidChannel = const AndroidNotificationChannel(
    "hight_importance_channel",
    "High Importance Notifications",
    description: "this channel is used for important notifications",
    importance: Importance.defaultImportance,
  );
  final localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) async {
    if (message != null) {
      print("id: ${message.messageId}");
      print('Title: ${message.notification!.title}');
      print('Body: ${message.notification!.body}');
      print('Payload: ${message.data}');
      messageNotificationController!.decreaseCount();

      Get.toNamed('/notificationPage', arguments: {"message": message});
    } else {
      print('noo');
    }
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        RemoteMessage message = RemoteMessage(
          data: json.decode(payload.payload.toString()),
          notification: RemoteNotification(
            title: messageNotificationController!.title.value,
            body: messageNotificationController!.body.value,
          ),
        );

        // final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));

        handleMessage(message);
      },
    );
    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("not nulllllll");
        handleMessage(message);
      }
      // else {
      //   print("nulllllll");
      //   message = RemoteMessage(
      //     data: messageNotificationController!.payload,
      //     notification: RemoteNotification(
      //       title: messageNotificationController!.title.value,
      //       body: messageNotificationController!.body.value,
      //     ),
      //   );
      //   print(message.notification!.body);
      //   handleMessage(message);
      // }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print("message id: ${message.messageId}");
        messageNotificationController!.updateMessage(
          NotificationMessage(
              title: message.notification!.title.toString(),
              body: message.notification!.body.toString(),
              payload: message.data),
        );
        final notification = message.notification;
        localNotifications.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: "@drawable/ic_launcher",
            ),
          ),
          payload: jsonEncode(
            {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
              "screen": "/notificationPage"
            },
          ),
        );
      } else {
        print('noooooooooo');
      }
    });
  }

  Future<void> initNotifications() async {
    await firebaseMessageing.requestPermission();
    final fCMToken = await firebaseMessageing.getToken();
    print(fCMToken);
    prefs!.setString('token', fCMToken!);
    initPushNotification();
    initLocalNotifications();
  }

  sendMessage(String title, String message, String id) async {
    var headersList = {
      'Accept': '*/*',
      'Authorization':
          'key=AAAAiBekV9Y:APA91bEnm6rT2a7bYnyv-SVGZiY2jKCwc69J9Pek3VdSN-5aYhKzfb_oLx_33eeo8kwLsxSmks4Y-To8bu1nIBMTXHNJqznnxrct2eRUNPuVYx5BuriYOT-xenh1AMuV0vHLLke5VNQY',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    RemoteMessage remoteMessage = RemoteMessage(
      messageId: id,
      data: {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": "default",
        "screen": "/notificationPage"
      },
      notification: RemoteNotification(
        body: message,
        title: title,
      ),
      senderId: prefs!.getString('token'),
    );
    remoteMessage.toMap();
    Map<String, dynamic> body = {
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": "default",
        "screen": "/notificationPage"
      },
      "notification": {"body": message, "title": title, "sound": "default"},
      "to": prefs!.getString('token'),
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);
    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var res = json.decode(resBody);
      print("the result is: ${res['results'][0]['message_id']}");

      NotificationMessage notificationMessage = NotificationMessage(
          title: title, body: message, payload: body['data']);
      messageNotificationController!.updateMessage(notificationMessage);
      messageNotificationController!.increaseCount();
    } else {
      print("fail: ${res.reasonPhrase}");
    }
  }
}
