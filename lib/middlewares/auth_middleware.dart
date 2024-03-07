// ignore: implementation_imports
import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:registration_app/main.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (prefs!.getString('name') != null && prefs!.getString('email') != null) {
      return const RouteSettings(name: "/archive");
    }
    return null;
  }
}
