import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:registration_app/controllers/auth_controller.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/services/db.dart';

// ignore: must_be_immutable
class Login extends GetView<AuthController> {
  DB db = DB();

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
                    controller: nameController,
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
                    controller: emailController,
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
                        'Email',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GetX<AuthController>(builder: (AuthController controller) {
                    return Text(
                      controller.messageError.value,
                      style: const TextStyle(color: Colors.red),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              List<Map> res = await controller.login(
                                  nameController.text, emailController.text);
                              if (res.isNotEmpty) {
                                Get.offNamed('/archive');
                                controller.messageError.value = '';
                              } else {
                                controller.messageError.value =
                                    "It seems that you don't have an account, you have to register";
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
                        Row(
                          children: [
                            GetX<AuthController>(
                                builder: (AuthController controller) {
                              return Checkbox(
                                value: controller.isChecked.value,
                                onChanged: (bool? value) {
                                  prefs!.setString('name', nameController.text);

                                  prefs!
                                      .setString('email', emailController.text);

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
                                controller.messageError.value = '';
                                controller.isChecked.value = false;
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
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.signInWithGoogle();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Iconify(
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256"><g fill="none"><rect width="256" height="256" fill="#f4f2ed" rx="60"/><path fill="#4285f4" d="M41.636 203.039h31.818v-77.273L28 91.676v97.727c0 7.545 6.114 13.636 13.636 13.636"/><path fill="#34a853" d="M182.545 203.039h31.819c7.545 0 13.636-6.114 13.636-13.636V91.675l-45.455 34.091"/><path fill="#fbbc04" d="M182.545 66.675v59.091L228 91.676V73.492c0-16.863-19.25-26.477-32.727-16.363"/><path fill="#ea4335" d="M73.455 125.766v-59.09L128 107.583l54.545-40.909v59.091L128 166.675"/><path fill="#c5221f" d="M28 73.493v18.182l45.454 34.091v-59.09L60.727 57.13C47.227 47.016 28 56.63 28 73.493"/></g></svg>'),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.signInWithFacebook();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Iconify(
                                  '<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256"><path fill="#1877f2" d="M256 128C256 57.308 198.692 0 128 0C57.308 0 0 57.308 0 128c0 63.888 46.808 116.843 108 126.445V165H75.5v-37H108V99.8c0-32.08 19.11-49.8 48.348-49.8C170.352 50 185 52.5 185 52.5V84h-16.14C152.959 84 148 93.867 148 103.99V128h35.5l-5.675 37H148v89.445c61.192-9.602 108-62.556 108-126.445"/><path fill="#fff" d="m177.825 165l5.675-37H148v-24.01C148 93.866 152.959 84 168.86 84H185V52.5S170.352 50 156.347 50C127.11 50 108 67.72 108 99.8V128H75.5v37H108v89.445A128.959 128.959 0 0 0 128 256a128.9 128.9 0 0 0 20-1.555V165z"/></svg>'),
                              Text(
                                'Sign in with Facebook',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
