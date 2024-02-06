import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    nameController.text = Get.arguments['name'];
    titleController.text = Get.arguments['title'];
    dateOfBirthController.text = Get.arguments['dateOfBirth'];
    nationalNumberController.text = Get.arguments['nationalNumber'];
    Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offNamed('/archive');
            },
          ),
        ],
        title: const Text('UPDATE USER'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, String> user = {
                        "name": nameController.text,
                        "title": titleController.text,
                        "date_of_birth": dateOfBirthController.text,
                        "national_number": nationalNumberController.text
                      };
                      await controller.updateUser(
                          'users', user, Get.arguments['id']);

                      Get.offNamed('/archive');
                    },
                    child: const Text('UPDATE'),
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
