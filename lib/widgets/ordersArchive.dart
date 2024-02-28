import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/widgets/ordersList.dart';

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
                        controller.orders.clear();
                        controller.getOrders();
                      }
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 64, 99, 67),
                      size: 30.0,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
                  onTap: () async {
                    controller.invertSorting();
                    await controller.sorting();
                  },
                );
              }),
            ],
          ),
          GetX<OrderController>(builder: (OrderController controller) {
            return controller.orders.isEmpty
                ? const Center(
                    child: Text('No data here'),
                  )
                : const OrderList();
          })
        ],
      ),
    );
  }
}
