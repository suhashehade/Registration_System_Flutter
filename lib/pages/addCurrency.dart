import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/pages/sideBar.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        title: const Text(
          'Add Currency',
          style: TextStyle(
            color: Color.fromARGB(255, 243, 239, 204),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 243, 239, 204),
            ),
            onPressed: () {
              Get.offNamed('/currencies');
            },
          ),
        ],
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
                          Map<String, String> currency = {
                            "name": nameController.text,
                            "symbol": symbolController.text,
                            "rate": rateController.text,
                          };

                          await currenciesController.insert(
                              'currencies', currency);
                          Get.offNamed('/currencies');
                        }
                      },
                      child: const Text(
                        'ADD CURRENCY',
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
