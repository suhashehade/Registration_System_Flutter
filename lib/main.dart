import 'package:flutter/material.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/pages/sign_up.dart';
import 'package:registration_app/pages/updateUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MaterialApp(
    home: prefs.getString('name') == null && prefs.getString('nNumber') == null
        ? const Login()
        : const Archive(),
  ));
}
