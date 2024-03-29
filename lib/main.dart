import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/api/firebase_api.dart';
import 'package:registration_app/controllers/message_notification_controller.dart';
import 'package:registration_app/controllers/show_pages_controller.dart';
import 'package:registration_app/controllers/sidebar_controller.dart';
import 'package:registration_app/middlewares/auth_middleware.dart';
import 'package:registration_app/pages/add_currency.dart';
import 'package:registration_app/pages/add_order.dart';
import 'package:registration_app/pages/archive_page.dart';
import 'package:registration_app/pages/currencies_page.dart';
import 'package:registration_app/pages/notification_page.dart';
import 'package:registration_app/pages/notifications_page.dart';
import 'package:registration_app/pages/orders_page.dart';
import 'package:registration_app/pages/pdf_page.dart';
import 'package:registration_app/pages/sign_up.dart';
import 'package:registration_app/services/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login.dart';
import 'firebase_options.dart';

SharedPreferences? prefs;
DB? db;
MessageNotificationController? messageNotificationController;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  messageNotificationController = Get.put(MessageNotificationController());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  db = DB();
  Get.put(SideBarController());
  Get.put(ShowPagesController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(name: '/', page: () => Login(), middlewares: [
        AuthMiddleware(),
      ]),
      GetPage(name: '/archive', page: () => const ArchivePage()),
      GetPage(name: '/orders', page: () => const OrdersPage()),
      GetPage(name: '/currencies', page: () => const CurrenciesPage()),
      GetPage(name: '/addCurrency', page: () => AddCurrency()),
      GetPage(name: '/addOrder', page: () => AddOrder()),
      GetPage(name: '/signUp', page: () => SignUp()),
      GetPage(name: '/pdfPage', page: () => PdfView()),
      GetPage(name: '/notificationPage', page: () => const NotificationPage()),
      GetPage(name: '/notifications', page: () => const NotificationsPage()),
    ],
  ));
}
