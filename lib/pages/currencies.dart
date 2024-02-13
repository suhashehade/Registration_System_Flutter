import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/widgets/navigationRail.dart';

// ignore: must_be_immutable
class Currencies extends GetView<CurrenciesController> {
  Currencies({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController keyWordConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(CurrenciesController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 239, 204),
        title: const Text('Currencies'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        onPressed: () {
          Get.offNamed('/addCurrency');
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
                                      Text(
                                          "${controller.currencies[index]['name']}"),
                                      Text(
                                          "${controller.currencies[index]['rate']}"),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () async {
                                      await controller.delete(
                                          controller.currencies[index]['id']);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 30.0,
                                      color: Color.fromARGB(255, 64, 99, 67),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.offNamed('/updateCurrency',
                                          arguments: {
                                            "id": controller.currencies[index]
                                                ['id'],
                                            "name": controller.currencies[index]
                                                ['name'],
                                            "rate": controller.currencies[index]
                                                ['rate'],
                                            "symbol": controller
                                                .currencies[index]['symbol'],
                                          });
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
                }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
