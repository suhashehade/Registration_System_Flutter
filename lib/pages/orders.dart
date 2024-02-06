import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/pages/sideBar.dart';

// ignore: must_be_immutable
class Orders extends GetView<OrderController> {
  Orders({super.key});
  TextEditingController keyWordConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    Get.put(CurrenciesController());

    return Scaffold(
      drawer: const Drawer(
        child: SideBar(),
      ),
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Form(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GetX<OrderController>(
                        builder: (OrderController controller) {
                      return GestureDetector(
                        child: controller.isDescSorted.value
                            ? const Icon(Icons.arrow_upward)
                            : const Icon(Icons.arrow_downward),
                        onTap: () {
                          controller.invertSorting();
                          controller.sorting();
                        },
                      );
                    }),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: keyWordConroller,
                        decoration: const InputDecoration(
                          hintText: 'Search by username | price | order status',
                        ),
                        onChanged: (value) {
                          if (value == '') {
                            controller.states.clear();
                            controller.orders.clear();
                            controller.getOrders();
                          }
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (keyWordConroller.text.toLowerCase() == "paid") {
                            controller.getAllPaid();
                          } else {
                            if (keyWordConroller.text.toLowerCase() ==
                                "not paid") {
                              controller.getAllNotPaid();
                            } else {
                              controller.filter(keyWordConroller.text);
                            }
                          }

                          if (keyWordConroller.text == '') {
                            controller.states.clear();
                            controller.orders.clear();
                            controller.getOrders();
                          }
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GetX<OrderController>(builder: (OrderController controller) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "User: ${controller.orders[index]['username']}"),
                                Text(
                                    "Order Date: ${controller.orders[index]['orderDate']}"),
                                GetX<OrderController>(
                                    builder: (OrderController orderController) {
                                  return Text(
                                      "Paid: ${orderController.states[index] == 1 ? "Paid" : orderController.states[index] == 0 ? "Not Paid" : null}");
                                }),
                                Text(
                                    "Order Type: ${controller.orders[index]['type']}"),
                                Text(
                                    "Order Amount: ${controller.orders[index]['amount']}"),
                                Text(
                                    "Order Equal Amount: ${controller.orders[index]['equalAmount']}"),
                                Text(
                                    "Currency: ${controller.orders[index]['currencyName']}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () async {
                                    await controller.delete('orders',
                                        controller.orders[index]['orderId']);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                GetX<OrderController>(
                                    builder: (OrderController controller) {
                                  return Switch(
                                    value: controller.states[index] == 1
                                        ? true
                                        : false,
                                    onChanged: (bool value) async {
                                      int response =
                                          await controller.updateOrderState(
                                              value ? 1 : 0,
                                              controller.orders[index]
                                                  ['orderId']);
                                      if (response > 0) {
                                        controller.switchOrderState(
                                            index, value);
                                        print(controller.states);
                                        // print(
                                        //     "${controller.orders[index]['amount']} : ${controller.states[index]}");
                                      }
                                    },
                                  );
                                }),
                              ],
                            )),
                      );
                    },
                  ),
                );
              }),
              FloatingActionButton(
                onPressed: () {
                  Get.offNamed('/addOrder');
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }
}
