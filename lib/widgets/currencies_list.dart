import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/models/currency_arguments.dart';
import '../controllers/currencies_controller.dart';
import '../models/currency.dart';

class CurrenciesList extends GetView<CurrenciesController> {
  const CurrenciesList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CurrenciesController>(
        builder: (CurrenciesController controller) {
      return Expanded(
        child: ListView.builder(
          itemCount: controller.currencies.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                color: const Color.fromARGB(255, 243, 239, 204),
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          child: Text(
                              "${controller.currencies[index]['symbol']}")),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: <Widget>[
                          Text("${controller.currencies[index]['name']}"),
                          Text("${controller.currencies[index]['rate']}"),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          await controller
                              .delete(controller.currencies[index]['id']);
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 30.0,
                          color: Color.fromARGB(255, 64, 99, 67),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed('/addCurrency',
                              arguments: CurrencyArguments(
                                  id: controller.currencies[index]['id'],
                                  currency: Currency(
                                      name: controller.currencies[index]
                                          ['name'],
                                      symbol: controller.currencies[index]
                                          ['symbol'],
                                      rate: controller.currencies[index]
                                          ['rate'])));
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 30.0,
                          color: Color.fromARGB(255, 64, 99, 67),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
