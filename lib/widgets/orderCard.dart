import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/api/pdf_invoice_api.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/controllers/userController.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/currency.dart';
import 'package:registration_app/models/invoice.dart';
import 'package:registration_app/models/invoiceInfo.dart';
import 'package:registration_app/models/order.dart';
import 'package:registration_app/models/orderArguments.dart';
import 'package:registration_app/models/user.dart';

class OrderCard extends GetView<OrderController> {
  const OrderCard({super.key, required this.index});

  final int index;
  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());

    return Card(
      color: const Color.fromARGB(255, 243, 239, 204),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User: ${controller.orders[index]['username']}"),
            const SizedBox(
              width: 20.0,
            ),
            Text("Order Date: ${controller.orders[index]['orderDate']}"),
            Text("Order Type: ${controller.orders[index]['type']}"),
            Text("Currency: ${controller.orders[index]['currencyName']}"),
            Text("Order Amount: ${controller.orders[index]['amount']}"),
            Text(
                "Order Equal Amount: ${controller.orders[index]['equalAmount']}"),
            const Divider(
                color: Color.fromARGB(255, 64, 99, 67), thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GetX<OrderController>(
                        builder: (OrderController controller) {
                      return Switch(
                          activeColor: const Color.fromARGB(255, 64, 99, 67),
                          inactiveThumbColor:
                              const Color.fromARGB(255, 173, 188, 159),
                          value: controller.orders[index]['state'] == 1
                              ? true
                              : false,
                          onChanged: (bool value) async {
                            int res = await controller.updateOrderState(
                                value, controller.orders[index]['orderId']);

                            if (res > 0) {
                              await controller.updateLocalOrder(
                                  controller.orders[index]['orderId']);
                            }
                          });
                    }),
                    GetX<OrderController>(
                        builder: (OrderController orderController) {
                      return Text(controller.orders[index]['state'] == 1
                          ? "Paid"
                          : "Not Paid");
                    })
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      color: const Color.fromARGB(255, 64, 99, 67),
                      onPressed: () async {
                        await controller.delete(
                            'orders', controller.orders[index]['orderId']);
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 30.0,
                      ),
                    ),
                    IconButton(
                      color: const Color.fromARGB(255, 64, 99, 67),
                      onPressed: () {
                        Get.toNamed('/addOrder',
                            arguments: OrderArgument(
                                id: controller.orders[index]['orderId'],
                                user: User(
                                    name: controller.orders[index]['username'],
                                    nationalNumber: '',
                                    dateOfBirth: '',
                                    title: '',
                                    photo: '',
                                    phone: '',
                                    email: ''),
                                currency: Currency(
                                    name: controller.orders[index]
                                        ['currencyName'],
                                    symbol: '',
                                    rate: controller.orders[index]['rate']),
                                order: Order(
                                    currencyId: controller.orders[index]
                                        ['currencyId'],
                                    userId: controller.orders[index]['userId'],
                                    orderDate: controller.orders[index]
                                        ['orderDate'],
                                    orderAmount: controller.orders[index]
                                        ['amount'],
                                    equalOrderAmount: controller.orders[index]
                                        ['equalAmount'],
                                    status: controller.orders[index]['state'],
                                    type: controller.orders[index]['type'])));
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 30.0,
                      ),
                    ),
                    IconButton(
                        color: const Color.fromARGB(255, 64, 99, 67),
                        onPressed: () async {
                          Map user = await userController.getCurrentUser(
                              prefs!.getString('nNumber').toString());
                          final DateTime date = DateTime.now();
                          final DateTime dueDate =
                              date.add(const Duration(days: 7));
                          final random = Random(5);
                          final invoice = Invoice(
                            order: Order(
                                currencyId: controller.orders[index]
                                    ['currencyId'],
                                userId: controller.orders[index]['userId'],
                                orderDate: controller.orders[index]
                                    ['orderDate'],
                                orderAmount: controller.orders[index]['amount'],
                                equalOrderAmount: controller.orders[index]
                                    ['equalAmount'],
                                status: controller.orders[index]['state'],
                                type: controller.orders[index]['type']),
                            supplier: User(
                                name: prefs!.getString('name').toString(),
                                nationalNumber: '',
                                dateOfBirth: '',
                                title: user['title'],
                                photo: '',
                                phone: user['phone'],
                                email: user['email']),
                            customer: User(
                                name: controller.orders[index]['username'],
                                nationalNumber: controller.orders[index]
                                    ['nationalNumber'],
                                dateOfBirth: controller.orders[index]
                                    ['dateOfBirth'],
                                title: controller.orders[index]['title'],
                                photo: controller.orders[index]['photo'],
                                phone: controller.orders[index]['phone'],
                                email: controller.orders[index]['email']),
                            currency: Currency(
                                name: controller.orders[index]['currencyName'],
                                symbol: controller.orders[index]['symbol'],
                                rate: controller.orders[index]['rate']),
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
                              await PdfInoviceApi.generate(invoice);
                          Get.toNamed('/pdfPage', arguments: {
                            "file": pdfFile.path,
                          });
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          size: 30.0,
                        )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
