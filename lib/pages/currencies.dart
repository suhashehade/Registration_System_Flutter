import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/pages/sideBar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

// ignore: must_be_immutable
class Currencies extends GetView<CurrenciesController> {
  Currencies({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController keyWordConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(CurrenciesController());
    return Scaffold(
      drawer: const Drawer(
        child: SideBar(),
      ),
      appBar: AppBar(
        title: const Text('Currencies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: <Widget>[
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: keyWordConroller,
                    decoration: const InputDecoration(
                      hintText: 'Search by name',
                      icon: Icon(Icons.search),
                    ),
                    onChanged: (value) async {
                      await controller.filter(keyWordConroller.text);
                      if (value == '') {
                        controller.currencies.clear();
                        controller.getCurrencies('currencies');
                      }
                    },
                    onSubmitted: (value) async {
                      await controller.filter(keyWordConroller.text);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          GetX<CurrenciesController>(
              builder: (CurrenciesController controller) {
            return Expanded(
              child: ListView.builder(
                itemCount: controller.currencies.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            SizedBox(
                                child: Iconify(
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
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.offNamed('/updateCurrency', arguments: {
                                  "id": controller.currencies[index]['id'],
                                  "name": controller.currencies[index]['name'],
                                  "rate": controller.currencies[index]['rate'],
                                  "symbol": controller.currencies[index]
                                      ['symbol'],
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
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
          }),
          FloatingActionButton(
            onPressed: () {
              Get.offNamed('/addCurrency');
            },
            child: const Icon(Icons.add),
          ),
        ]),
      ),
    );
  }
}
