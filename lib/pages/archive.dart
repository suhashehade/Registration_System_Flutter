import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/userController.dart';
import 'package:registration_app/widgets/navigationRail.dart';

// ignore: must_be_immutable
class Archive extends GetView<UserController> {
  TextEditingController keyWordConroller = TextEditingController();

  Archive({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        onPressed: () {
          Get.offNamed('/signUp');
        },
        child: const Icon(
          Icons.add,
          size: 30.0,
          color: Color.fromARGB(255, 243, 239, 204),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            const CustomNavigationRail(),
            Expanded(
              child: Column(
                children: [
                  Form(
                      child: TextField(
                    controller: keyWordConroller,
                    decoration: const InputDecoration(
                      hintText: 'Search by title | name',
                      icon: Icon(Icons.search),
                    ),
                    onChanged: (value) async {
                      await controller.filter(keyWordConroller.text);
                      if (value == '') {
                        controller.users.clear();
                        controller.getUsers('users');
                      }
                    },
                    onSubmitted: (value) async {
                      await controller.filter(keyWordConroller.text);
                    },
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  GetX<UserController>(builder: (UserController controller) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: const Color.fromARGB(255, 243, 239, 204),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10.0),
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                controller.users[index]
                                                            ['photo'] ==
                                                        ''
                                                    ? null
                                                    : FileImage(
                                                        File(
                                                          "${controller.users[index]['photo']}",
                                                        ),
                                                      ),
                                          ),
                                        ),
                                        Text(
                                            "Name: ${controller.users[index]['name']}"),
                                        Text(
                                            "National NO.: ${controller.users[index]['national_number']}"),
                                        Text(
                                            "Title: ${controller.users[index]['title']}"),
                                      ]),
                                  subtitle: Text(
                                      "Date of birth: ${controller.users[index]['date_of_birth']}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () async {
                                          await controller.delete(
                                              controller.users[index]['id']);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Get.offNamed('/updateUser',
                                              arguments: {
                                                "id": controller.users[index]
                                                    ['id'],
                                                "name": controller.users[index]
                                                    ['name'],
                                                "title": controller.users[index]
                                                    ['title'],
                                                "dateOfBirth":
                                                    controller.users[index]
                                                        ['date_of_birth'],
                                                "nationalNumber":
                                                    controller.users[index]
                                                        ['national_number'],
                                                "photo": controller.users[index]
                                                    ['photo'],
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              ));
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
