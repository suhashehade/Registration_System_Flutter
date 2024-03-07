import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currencies_controller.dart';
import 'package:registration_app/models/currency.dart';

// ignore: must_be_immutable
class AddCurrency extends GetView<CurrenciesController> {
  final _formKey = GlobalKey<FormState>();
  AddCurrency({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController symbolController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CurrenciesController currenciesController = Get.find();

    if (Get.arguments != null) {
      nameController.text = Get.arguments.currency.name;
      symbolController.text = Get.arguments.currency.symbol;
      rateController.text = Get.arguments.currency.rate.toString();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        title: Get.arguments == null
            ? const Text(
                'New Currency',
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 239, 204),
                ),
              )
            : const Text(
                'Edit Currency',
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 239, 204),
                ),
              ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 243, 239, 204),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the input';
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Name',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the input';
                        }
                        return null;
                      },
                      controller: symbolController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Symbol',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the input';
                        }
                        return null;
                      },
                      controller: rateController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Rate',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(80.0),
                        ),
                      ),
                      color: const Color.fromARGB(255, 64, 99, 67),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Currency currency = Currency(
                              name: nameController.text,
                              symbol: symbolController.text,
                              rate: double.parse(rateController.text));
                          if (Get.arguments == null) {
                            await currenciesController.insert(
                                'currencies', currency);
                          } else {
                            await controller.updateCurrency(
                                'currencies', currency, Get.arguments.id);
                          }
                          Get.back();
                        }
                      },
                      child: Get.arguments == null
                          ? const Text(
                              'ADD CURRENCY',
                              style: TextStyle(
                                color: Color.fromARGB(255, 243, 239, 204),
                              ),
                            )
                          : const Text(
                              'SAVE CHANGES',
                              style: TextStyle(
                                color: Color.fromARGB(255, 243, 239, 204),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
