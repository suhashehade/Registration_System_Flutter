import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/showPagesController.dart';
import 'package:registration_app/controllers/sideBarController.dart';
import 'package:registration_app/middlewares/authMiddleware.dart';
import 'package:registration_app/pages/addCurrency.dart';
import 'package:registration_app/pages/addOrder.dart';
import 'package:registration_app/pages/archivePage.dart';
import 'package:registration_app/pages/currenciesPage.dart';
import 'package:registration_app/pages/ordersPage.dart';
import 'package:registration_app/pages/pdfPage.dart';
import 'package:registration_app/pages/sign_up.dart';
import 'package:registration_app/pages/userOrdersInvoicePdf.dart';
import 'package:registration_app/services/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';

SharedPreferences? prefs;
DB? db;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
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
      GetPage(name: '/userOrdersInvoice', page: () => UserInvoiceOrdersPdf()),
    ],
  ));
}
