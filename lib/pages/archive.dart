import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/userController.dart';
import 'package:registration_app/pages/sideBar.dart';

// ignore: must_be_immutable
class Archive extends GetView<UserController> {
  TextEditingController keyWordConroller = TextEditingController();

  Archive({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return Scaffold(
      drawer: const Drawer(
        child: SideBar(),
      ),
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 40,
                child: Form(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyWordConroller,
                        decoration: const InputDecoration(
                          hintText: 'Search by title | name',
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
                      ),
                    ),
                  ],
                )),
              ),
            ),
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
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                    ),
                                    height: 80.0,
                                    width: 80.0,
                                    child: Image.file(
                                      File(
                                        "${controller.users[index]['photo']}",
                                      ),
                                      fit: BoxFit.cover,
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
                                    await controller
                                        .delete(controller.users[index]['id']);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    Get.offNamed('/updateUser', arguments: {
                                      "id": controller.users[index]['id'],
                                      "name": controller.users[index]['name'],
                                      "title": controller.users[index]['title'],
                                      "dateOfBirth": controller.users[index]
                                          ['date_of_birth'],
                                      "nationalNumber": controller.users[index]
                                          ['national_number'],
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
            })
          ],
        ),
      ),
    );
  }
}
