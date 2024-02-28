import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/widgets/currenciesList.dart';

// ignore: must_be_immutable
class Currencies extends GetView<CurrenciesController> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController keyWordConroller = TextEditingController();
  Currencies({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
        GetX<CurrenciesController>(builder: (CurrenciesController controller) {
          return controller.currencies.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(100.0),
                  child: Center(
                    child: Text('No data here'),
                  ),
                )
              : const CurrenciesList();
        })
      ]),
    );
  }
}
