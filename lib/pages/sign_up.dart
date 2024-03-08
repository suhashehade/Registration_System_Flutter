import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:registration_app/controllers/file_upload_controller.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/user.dart';
import '../controllers/user_controller.dart';

// ignore: must_be_immutable
class SignUp extends GetView<AuthController> {
  SignUp({super.key});
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    FileUploadController fileUploadController = Get.put(FileUploadController());
    UserController userController = Get.put(UserController());

    if (Get.arguments != null) {
      nameController.text = Get.arguments.user.name;
      nationalNumberController.text =
          Get.arguments.user.nationalNumber.toString();
      dateOfBirthController.text = Get.arguments.user.dateOfBirth;
      titleController.text = Get.arguments.user.title;
      fileUploadController.imagePath!.value = Get.arguments.user.photo;
      phoneController.text = Get.arguments.user.phone;
      emailController.text = Get.arguments.user.email;
    }
    return Scaffold(
      appBar: prefs!.getBool('isLogin') != null
          ? Get.arguments == null
              ? AppBar(
                  title: const Text("ADD"),
                )
              : AppBar(
                  title: const Text("UPDATE"),
                )
          : null,
      backgroundColor: const Color.fromARGB(255, 243, 239, 204),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  prefs!.getBool('isLogin') != null
                      ? Get.arguments == null
                          ? const Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            )
                          : const Text(
                              'UPDATE',
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            )
                      : const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                  fileUploadController.imagePath!.value == ''
                      ? const Text('no picked image')
                      : GetX<FileUploadController>(
                          builder: (FileUploadController controller) {
                          return SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child:
                                Image.file(File(controller.imagePath!.value)),
                          );
                        }),
                  MaterialButton(
                    onPressed: () {
                      fileUploadController.uplaodImage();
                    },
                    child: const Text('upload image'),
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
                      label: Text(
                        'Username',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: nationalNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text(
                        'National Number',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                    controller: dateOfBirthController,
                    decoration: const InputDecoration(
                      label: Text(
                        'Data of birth',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat.yMMMd().format(pickedDate);
                        dateOfBirthController.text = formattedDate;
                      }
                    },
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      label: Text(
                        'Title',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      label: Text(
                        'Phone',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      label: Text(
                        'Email',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  GetX<AuthController>(builder: (AuthController controller) {
                    return Text(controller.messageError.value,
                        style: const TextStyle(color: Colors.red));
                  }),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            CustomUser user = CustomUser(
                                name: nameController.text.toLowerCase(),
                                nationalNumber: nationalNumberController.text,
                                dateOfBirth: dateOfBirthController.text,
                                title: titleController.text.toLowerCase(),
                                photo: fileUploadController.imagePath!.value,
                                phone: phoneController.text,
                                email: emailController.text);

                            if (Get.arguments == null) {
                              try {
                                int res =
                                    await userController.insert('users', user);
                                if (res > 0) {
                                  Get.back();
                                  fileUploadController.imagePath!.value = '';
                                  titleController.text = '';
                                  nameController.text = '';
                                  nameController.text = '';
                                  dateOfBirthController.text = '';
                                  phoneController.text = '';
                                  emailController.text = '';

                                  prefs!.getBool('isLogin') == null
                                      ? Get.snackbar(
                                          "DONE",
                                          "Sign Up successfully, you can login now",
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: const Color.fromARGB(
                                              255, 101, 172, 116),
                                          icon: const Icon(Icons.done),
                                        )
                                      : Get.snackbar(
                                          "DONE",
                                          "User Added successfully",
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: const Color.fromARGB(
                                              255, 101, 172, 116),
                                          icon: const Icon(Icons.done),
                                        );
                                }
                              } catch (e) {
                                controller.messageError.value =
                                    'You already have an account, try to login';
                              }
                            } else {
                              await userController.updateUser(
                                  'users', user, Get.arguments.id);
                              Get.back();
                            }
                          }
                        },
                        child: prefs!.getBool('isLogin') == null
                            ? const Text(
                                'SIGN UP',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              )
                            : Get.arguments == null
                                ? const Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                  )
                                : const Text(
                                    'UPDATE',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  prefs!.getBool('isLogin') == null
                      ? Row(
                          children: <Widget>[
                            const Text(
                              "You you an account? ",
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.messageError.value = '';
                                controller.isChecked.value = false;
                                Get.toNamed('/');
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      : const Text('')
                ],
              ),
            )),
      ),
    );
  }
}
