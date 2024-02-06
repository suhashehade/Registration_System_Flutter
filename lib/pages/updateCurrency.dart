import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';

// ignore: must_be_immutable
class UpdateCurrency extends GetView<CurrenciesController> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController symbolController = TextEditingController();

  UpdateCurrency({super.key});

  @override
  Widget build(BuildContext context) {
    nameController.text = Get.arguments['name'];
    rateController.text = Get.arguments['rate'].toString();
    symbolController.text = Get.arguments['symbol'];

    Get.put(CurrenciesController());
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offNamed('/currencies');
            },
          ),
        ],
        title: const Text('UPDATE CURRENCY'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text(
                    'Name',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: rateController,
                decoration: const InputDecoration(
                  label: Text(
                    'Rate',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: symbolController,
                decoration: const InputDecoration(
                  label: Text(
                    'Symbol',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 120.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, String> currency = {
                        "name": nameController.text,
                        "rate": rateController.text,
                        "symbol": symbolController.text,
                      };
                      await controller.updateCurrency(
                          'currencies', currency, Get.arguments['id']);

                      Get.offNamed('/currencies');
                    },
                    child: const Text('UPDATE'),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
