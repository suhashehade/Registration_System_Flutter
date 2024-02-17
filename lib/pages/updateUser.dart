import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/fileUploadController.dart';
import 'package:registration_app/controllers/userController.dart';

// ignore: must_be_immutable
class UpdateUser extends GetView<UserController> {
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();

  UpdateUser({super.key});

  @override
  Widget build(BuildContext context) {
    FileUploadController fileUploadController = Get.put(FileUploadController());
    nameController.text = Get.arguments['name'];
    titleController.text = Get.arguments['title'];
    dateOfBirthController.text = Get.arguments['dateOfBirth'];
    nationalNumberController.text = Get.arguments['nationalNumber'];

    Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 243, 239, 204),
            ),
            onPressed: () {
              Get.offNamed('/archive');
            },
          ),
        ],
        title: const Text(
          'UPDATE USER',
          style: TextStyle(
            color: Color.fromARGB(255, 243, 239, 204),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 243, 239, 204),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GetX<FileUploadController>(
                  builder: (FileUploadController controller) {
                return controller.imagePath!.value == ''
                    ? SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Get.arguments['photo'] == ''
                            ? const Icon(Icons.photo)
                            : Image.file(File(controller.imagePath!.value =
                                Get.arguments['photo'])),
                      )
                    : GetX<FileUploadController>(
                        builder: (FileUploadController controller) {
                        return SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: Image.file(File(controller.imagePath!.value)),
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
                decoration: const InputDecoration(
                  label: Text(
                    'Username',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  label: Text(
                    'Title',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: dateOfBirthController,
                decoration: const InputDecoration(
                  label: Text(
                    'date of birth',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  FocusScope.of(context).unfocus();
                },
                controller: nationalNumberController,
                decoration: const InputDecoration(
                  label: Text(
                    'national number',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 120.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(80.0),
                      ),
                    ),
                    color: const Color.fromARGB(255, 64, 99, 67),
                    onPressed: () async {
                      Map<String, dynamic> user = {
                        "name": nameController.text,
                        "title": titleController.text,
                        "date_of_birth": dateOfBirthController.text,
                        "national_number": nationalNumberController.text,
                        "photo": fileUploadController.imagePath!.value,
                      };
                      await controller.updateUser(
                          'users', user, Get.arguments['id']);

                      Get.offNamed('/archive');
                    },
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Color.fromARGB(255, 243, 239, 204),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
