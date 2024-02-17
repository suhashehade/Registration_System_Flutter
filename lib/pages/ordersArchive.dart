import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/orderController.dart';

// ignore: must_be_immutable
class Orders extends GetView<OrderController> {
  TextEditingController keyWordConroller = TextEditingController();
  Orders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Form(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                    tooltip: "search",
                    color: const Color.fromARGB(255, 243, 239, 204),
                    onPressed: () {
                      if (keyWordConroller.text.toLowerCase() == "paid") {
                        controller.getAllPaid();
                      } else {
                        if (keyWordConroller.text.toLowerCase() == "not paid") {
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
                    icon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 64, 99, 67),
                      size: 30.0,
                    )),
                const SizedBox(
                  width: 5.0,
                ),
                GetX<OrderController>(builder: (OrderController controller) {
                  return GestureDetector(
                    child: controller.isDescSorted.value
                        ? const Icon(
                            Icons.arrow_upward,
                            color: Color.fromARGB(255, 64, 99, 67),
                            size: 30.0,
                          )
                        : const Icon(
                            Icons.arrow_downward,
                            color: Color.fromARGB(255, 64, 99, 67),
                            size: 30.0,
                          ),
                    onTap: () {
                      controller.invertSorting();
                      controller.sorting();
                    },
                  );
                }),
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
                    color: const Color.fromARGB(255, 243, 239, 204),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User: ${controller.orders[index]['username']}"),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(
                              "Order Date: ${controller.orders[index]['orderDate']}"),
                          Text(
                              "Order Type: ${controller.orders[index]['type']}"),
                          Text(
                              "Currency: ${controller.orders[index]['currencyName']}"),
                          Text(
                              "Order Amount: ${controller.orders[index]['amount']}"),
                          Text(
                              "Order Equal Amount: ${controller.orders[index]['equalAmount']}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  GetX<OrderController>(builder:
                                      (OrderController orderController) {
                                    return Switch(
                                      activeColor:
                                          const Color.fromARGB(255, 64, 99, 67),
                                      inactiveThumbColor: const Color.fromARGB(
                                          255, 173, 188, 159),
                                      value: orderController.states[index] == 1
                                          ? true
                                          : false,
                                      onChanged: (bool value) async {
                                        await orderController.updateOrderState(
                                            value ? 1 : 0,
                                            orderController.orders[index]
                                                ['orderId']);

                                        orderController.switchOrderState(
                                            index, value);
                                        orderController.orders.clear();
                                        orderController.getOrders();
                                      },
                                    );
                                  }),
                                  GetX<OrderController>(builder:
                                      (OrderController orderController) {
                                    return Text(
                                        "${orderController.states[index] == 1 ? "Paid" : orderController.states[index] == 0 ? "Not Paid" : null}");
                                  }),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    color:
                                        const Color.fromARGB(255, 64, 99, 67),
                                    onPressed: () async {
                                      await controller.delete('orders',
                                          controller.orders[index]['orderId']);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 30.0,
                                    ),
                                  ),
                                  IconButton(
                                    color:
                                        const Color.fromARGB(255, 64, 99, 67),
                                    onPressed: () {
                                      Get.offNamed('/updateOrder', arguments: {
                                        "id": controller.orders[index]
                                            ['orderId'],
                                        "currencyId": controller.orders[index]
                                            ['currencyId'],
                                        "userId": controller.orders[index]
                                            ['userId'],
                                        "orderDate": controller.orders[index]
                                            ['orderDate'],
                                        "orderAmmount": controller.orders[index]
                                            ['amount'],
                                        "equalOrderAmmount": controller
                                            .orders[index]['equalAmount'],
                                        "status": controller.orders[index]
                                            ['state'],
                                        "type": controller.orders[index]
                                            ['type'],
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
