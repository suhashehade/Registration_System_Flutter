import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/controllers/dropDownController.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/controllers/userController.dart';

// ignore: must_be_immutable
class UpdateOrder extends GetView<OrderController> {
  UpdateOrder({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController equalAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.put(OrderController());
    CurrenciesController currenciesController = Get.find();
    UserController userController = Get.put(UserController());
    DropDownController dropDownController = Get.put(DropDownController());
    List<String> types = [
      "Sell Order",
      "Purshased Order",
      "Return Sell Order",
      "Return Purshased Order"
    ];
    getUser() async {
      var user = await userController.getUser(Get.arguments['userId']);
      orderController.upadateSelectedUserId(user['id']);
    }

    getCurrency() async {
      var currency =
          await currenciesController.getCurrency(Get.arguments['currencyId']);
      orderController.upadateSelectedCurrencyId(currency['id']);
      orderController.updateCurrencyRate(currency['rate']);
    }

    getUser();
    getCurrency();

    dropDownController.updateSelectedType(Get.arguments['type']);

    dateController.text = Get.arguments['orderDate'];
    amountController.text = Get.arguments['orderAmmount'].toString();
    equalAmountController.text = Get.arguments['equalOrderAmmount'].toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        title: const Text(
          'Update Order',
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
              Get.offNamed('/archive');
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 243, 239, 204),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill the input';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat.yMMMd().format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                  controller: dateController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Order Date',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                GetX<DropDownController>(
                  builder: (DropDownController dropDownController) {
                    return DropdownButtonFormField(
                        isDense: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return dropDownController.validateCurrency(value);
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide()),
                        ),
                        hint: const Text('Select Currency'),
                        items: currenciesController.currencies
                            .map<DropdownMenuItem>((value) {
                          return DropdownMenuItem(
                            onTap: () {
                              controller.upadateSelectedCurrencyId(value['id']);
                              controller.updateCurrencyRate(value['rate']);
                            },
                            value: value['id'],
                            child: Text(
                              value['name'].toString(),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          dropDownController.updateSelectedCurrency(value);
                          if (amountController.text != '') {
                            double amount = double.parse(amountController.text);
                            int equalAmount = controller.findEqualAmmount(
                                amount, controller.rate.value);
                            equalAmountController.text = equalAmount.toString();
                          }
                        },
                        value: dropDownController.selectedCurrency.value == 0
                            ? dropDownController.selectedCurrency.value =
                                Get.arguments['currencyId']
                            : dropDownController.selectedCurrency.value);
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                GetX<DropDownController>(
                    builder: (DropDownController dropDownController) {
                  return DropdownButtonFormField(
                      isDense: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return dropDownController
                            .validateUser(value.toString());
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        dropDownController.updateSelectedUser(value);
                      },
                      hint: const Text('Select User'),
                      items:
                          userController.users.map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                            onTap: () {
                              controller.upadateSelectedUserId(value['id']);
                            },
                            value: value['id'],
                            child: Text(value['name'].toString()));
                      }).toList(),
                      value: dropDownController.selectedUser.value == 0
                          ? dropDownController.selectedUser.value =
                              Get.arguments['userId']
                          : dropDownController.selectedUser.value);
                }),
                const SizedBox(
                  height: 30.0,
                ),
                GetX<DropDownController>(
                    builder: (DropDownController dropDownController) {
                  return DropdownButtonFormField(
                      isDense: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return dropDownController
                            .validateType(value.toString());
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        dropDownController.updateSelectedType(value.toString());
                      },
                      hint: const Text('Select Type'),
                      items: types.map<DropdownMenuItem>((String value) {
                        return DropdownMenuItem(
                            onTap: () {
                              controller.updateType(value);
                            },
                            value: value,
                            child: Text(value));
                      }).toList(),
                      value: dropDownController.selectedType.value == ""
                          ? dropDownController.selectedType.value =
                              Get.arguments['type']
                          : dropDownController.selectedType.value);
                }),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill the input';
                          }
                          return null;
                        },
                        controller: amountController,
                        decoration: const InputDecoration(
                          label: Text(
                            'Order Amount',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (dropDownController.selectedCurrency.value != 0 &&
                              amountController.text != '') {
                            double amount = double.parse(amountController.text);
                            int equalAmount = controller.findEqualAmmount(
                                amount, controller.rate.value);
                            equalAmountController.text = equalAmount.toString();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill the input';
                          }
                          return null;
                        },
                        controller: equalAmountController,
                        decoration: const InputDecoration(
                          label: Text(
                            'Equal Amount',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      Map<String, dynamic> order = {
                        "id": Get.arguments['id'],
                        "currencyId": controller.currencyId.value,
                        "userId": controller.userId.value,
                        "orderDate": dateController.text,
                        "orderAmmount": amountController.text,
                        "equalOrderAmmount": equalAmountController.text,
                        "status": Get.arguments['status'],
                        "type": dropDownController.selectedType.value,
                      };

                      await controller.updateOrder(
                          'orders', order, Get.arguments['id']);

                      Get.offNamed('/archive');
                    }
                  },
                  child: const Text(
                    'UPDATE ORDER',
                    style: TextStyle(
                      color: Color.fromARGB(255, 243, 239, 204),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
