import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/sideBarController.dart';
import 'package:registration_app/middlewares/authMiddleware.dart';
import 'package:registration_app/pages/addCurrency.dart';
import 'package:registration_app/pages/addOrder.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/pages/currencies.dart';
import 'package:registration_app/pages/orders.dart';
import 'package:registration_app/pages/sign_up.dart';
import 'package:registration_app/pages/updateCurrency.dart';
import 'package:registration_app/pages/updateUser.dart';
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
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(name: '/', page: () => Login(), middlewares: [
        AuthMiddleware(),
      ]),
      GetPage(name: '/archive', page: () => Archive()),
      GetPage(name: '/updateUser', page: () => UpdateUser()),
      GetPage(name: '/orders', page: () => Orders()),
      GetPage(name: '/currencies', page: () => Currencies()),
      GetPage(name: '/addCurrency', page: () => AddCurrency()),
      GetPage(name: '/updateCurrency', page: () => UpdateCurrency()),
      GetPage(name: '/addOrder', page: () => AddOrder()),
      GetPage(name: '/signUp', page: () => SignUp()),
    ],
  ));
}
