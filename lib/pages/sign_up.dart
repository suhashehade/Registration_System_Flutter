import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/authController.dart';
import 'package:intl/intl.dart';
import 'package:registration_app/controllers/fileUploadController.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/user.dart';
import '../controllers/userController.dart';

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
      appBar: prefs!.getString('nNumber') != null
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
                  Get.arguments == null
                      ? const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        )
                      : const Text(
                          'UPDATE',
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  GetX<FileUploadController>(
                      builder: (FileUploadController controller) {
                    return controller.imagePath!.value == ''
                        ? const Text('no picked image')
                        : GetX<FileUploadController>(
                            builder: (FileUploadController controller) {
                            return SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child:
                                  Image.file(File(controller.imagePath!.value)),
                            );
                          });
                  }),
                  MaterialButton(
                    onPressed: () {
                      fileUploadController.uplaodImage();
                    },
                    child: const Text('upload image'),
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
                    height: 40.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User user = User(
                                name: nameController.text,
                                nationalNumber: nationalNumberController.text,
                                dateOfBirth: dateOfBirthController.text,
                                title: titleController.text,
                                photo: fileUploadController.imagePath!.value,
                                phone: phoneController.text,
                                email: emailController.text);

                            if (Get.arguments == null) {
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

                                prefs!.getString('nNumber') == null
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
                            } else {
                              await userController.updateUser(
                                  'users', user, Get.arguments.id);
                              Get.back();
                            }
                          }
                        },
                        child: prefs!.getString('nNumber') == null
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
                    height: 40.0,
                  ),
                  prefs!.getString('nNumber') == null
                      ? Row(
                          children: <Widget>[
                            const Text(
                              "You you an account? ",
                            ),
                            GestureDetector(
                              onTap: () {
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
