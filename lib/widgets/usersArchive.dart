import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/api/user_invoice.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/controllers/userController.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/invoiceInfo.dart';
import 'package:registration_app/models/user.dart';
import 'package:registration_app/models/userArguments.dart';
import 'package:registration_app/models/userInvoice.dart';

// ignore: must_be_immutable
class Users extends GetView<UserController> {
  TextEditingController keyWordConroller = TextEditingController();
  Users({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.put(OrderController());
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        controller.users[index]['photo'] == ''
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
                                    "Title: ${controller.users[index]['title']}"),
                              ]),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "Email: ${controller.users[index]['email']}"),
                              Text(
                                  "Phone NO.: ${controller.users[index]['phone']}")
                            ],
                          ),
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
                                onPressed: () {
                                  Get.toNamed('/signUp',
                                      arguments: UserArgument(
                                          id: controller.users[index]['id'],
                                          user: User(
                                              name: controller.users[index]
                                                  ['name'],
                                              nationalNumber:
                                                  (controller.users[index]
                                                      ['national_number']),
                                              dateOfBirth:
                                                  controller.users[index]
                                                      ['date_of_birth'],
                                              title: controller.users[index]
                                                  ['title'],
                                              photo: controller.users[index]
                                                  ['photo'],
                                              phone: controller.users[index]
                                                  ['phone'],
                                              email: controller.users[index]
                                                  ['email'])));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  Map supplier =
                                      await controller.getCurrentUser(prefs!
                                          .getString('nNumber')
                                          .toString());
                                  List<Map> customerList = await controller
                                      .getOne(controller.users[index]['id']);
                                  Map customer = customerList[0];
                                  final DateTime date = DateTime.now();
                                  final DateTime dueDate =
                                      date.add(const Duration(days: 7));
                                  Iterable orders = orderController.orders
                                      .where((o) =>
                                          o['userId'] ==
                                          controller.users[index]['id']);
                                  final random = Random(4);
                                  UserInvoice invoice = UserInvoice(
                                    userOrders: orders.toList(),
                                    supplier: User(
                                        name:
                                            prefs!.getString('name').toString(),
                                        nationalNumber: '',
                                        dateOfBirth: '',
                                        title: supplier['title'],
                                        photo: '',
                                        phone: supplier['phone'],
                                        email: supplier['email']),
                                    customer: User(
                                        name: customer['name'],
                                        nationalNumber: '',
                                        dateOfBirth: '',
                                        title: customer['title'],
                                        photo: '',
                                        phone: customer['phone'],
                                        email: customer['email']),
                                    invoiceInfo: InvoiceInfo(
                                        date: date,
                                        dueDate: dueDate,
                                        number:
                                            '${DateTime.now().millisecond}-${random.nextInt(100)}',
                                        termsAndConditions: [
                                          "Payment due upon receipt.",
                                          "Late fees may apply.",
                                          "Goods remain seller's property until paid in full.",
                                          "Prices subject to change."
                                        ]),
                                  );
                                  final File pdfFile =
                                      await UserInvoicePdf.generate(invoice);
                                  Get.toNamed('/pdfPage', arguments: {
                                    "file": pdfFile.path,
                                  });
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Print Invoice'),
                                    Icon(Icons.picture_as_pdf),
                                  ],
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
    );
  }
}
