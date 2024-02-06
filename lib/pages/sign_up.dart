import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/authController.dart';
import 'package:intl/intl.dart';
import 'package:registration_app/controllers/fileUploadController.dart';

// ignore: must_be_immutable
class SignUp extends GetView<AuthController> {
  SignUp({super.key});
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    FileUploadController fileUploadController = Get.put(FileUploadController());
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'SIGN UP',
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
                  const SizedBox(
                    height: 120.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, String> user = {
                              "name": nameController.text,
                              "national_number": nationalNumberController.text,
                              "date_of_birth": dateOfBirthController.text,
                              "title": titleController.text,
                              "photo": fileUploadController.imagePath!.value
                            };

                            await controller.signUp('users', user);
                            Get.offNamed('/archive');
                          }
                        },
                        child: const Text('SIGN UP'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 120.0,
                  ),
                  Row(
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
                ],
              ),
            )),
      ),
    );
  }
}
