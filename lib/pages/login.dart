import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/authController.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/services/db.dart';

// ignore: must_be_immutable
class Login extends GetView<AuthController> {
  DB db = DB();
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController nationalNumber = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 204),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      await db.deleteMyDatabase();
                    },
                    child: const Text('delete db'),
                  ),
                  const Text(
                    'WELCOME BACK',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 25.0,
                      ),
                      label: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: nationalNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.key,
                        size: 25.0,
                      ),
                      label: Text(
                        'National Number',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80.0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              List res = await controller.login(
                                  name.text, nationalNumber.text);
                              if (!res.isEmpty) {
                                Get.offNamed('/archive');
                              }
                            }
                          },
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GetX<AuthController>(
                          builder: (AuthController controller) {
                        return Checkbox(
                          value: controller.isChecked.value,
                          onChanged: (bool? value) {
                            prefs!.setString('name', name.text);
                            prefs!.setString('nNumber', nationalNumber.text);
                             prefs!.setString('name', name.text);
                            controller.toggleCheck(value);
                          },
                        );
                      }),
                      const Text('Remember me'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        "Don't have an account? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/signUp');
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
