import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/controllers/dropDownController.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/controllers/userController.dart';
import 'package:registration_app/models/order.dart';

// ignore: must_be_immutable
class AddOrder extends GetView<OrderController> {
  AddOrder({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController equalAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    CurrenciesController currenciesController = Get.find();
    UserController userController = Get.put(UserController());
    DropDownController dropDownController = Get.put(DropDownController());

    List<String> types = [
      "Sell Order",
      "Purshased Order",
      "Return Sell Order",
      "Return Purshased Order"
    ];

    // getUser() async {
    //   var user = await userController.getOne(Get.arguments['order'].userId);
    //   controller.upadateSelectedUserId(user[0]['id']);
    // }

    // getCurrency() async {
    //   var currency = await currenciesController
    //       .getCurrency(Get.arguments['order'].currencyId);
    //   controller.upadateSelectedCurrencyId(currency['id']);
    //   controller.updateCurrencyRate(currency['rate']);
    // }

    if (Get.arguments != null) {
      controller.updateCurrencyRate(Get.arguments['currency'].rate);
      controller.upadateSelectedCurrencyId(Get.arguments['order'].currencyId);
      controller.upadateSelectedUserId(Get.arguments['order'].userId);
      dateController.text = Get.arguments['order'].orderDate;
      amountController.text = Get.arguments['order'].orderAmount.toString();
      equalAmountController.text =
          Get.arguments['order'].equalOrderAmount.toString();
      dropDownController.selectedCurrency.value =
          Get.arguments['order'].currencyId;
      dropDownController.selectedUser.value = Get.arguments['order'].userId;
      dropDownController.selectedType.value = Get.arguments['order'].type;
      controller.isChecked.value =
          Get.arguments['order'].status == 1 ? true : false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 99, 67),
        title: Get.arguments == null
            ? const Text(
                'New Order',
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 239, 204),
                ),
              )
            : const Text(
                'Edit Order',
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 239, 204),
                ),
              ),
        centerTitle: true,
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
                                controller
                                    .upadateSelectedCurrencyId(value['id']);
                                controller.updateCurrencyRate(value['rate']);
                              },
                              value: value['id'],
                              child: Text(value['name'].toString()));
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
                            ? null
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
                          ? null
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
                          ? null
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
                Row(
                  children: [
                    GetX<OrderController>(
                        builder: (OrderController controller) {
                      return Checkbox(
                        value: controller.isChecked.value,
                        onChanged: (bool? value) {
                          controller.toggleCheck(value);
                        },
                      );
                    }),
                    const Text('Paid'),
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
                      Order order = Order(
                          currencyId: controller.currencyId.value,
                          userId: controller.userId.value,
                          orderDate: dateController.text,
                          orderAmount: int.parse(amountController.text),
                          equalOrderAmount:
                              double.parse(equalAmountController.text),
                          status: controller.isChecked.value ? 1 : 0,
                          type: dropDownController.selectedType.value);
                      if (Get.arguments == null) {
                        await controller.insert('orders', order);
                        
                      } else {
                        await controller.updateOrder(
                            'orders', order, Get.arguments['id']);
                      }
                      controller.isChecked.value = false;
                      Get.back();
                    }
                  },
                  child: Get.arguments == null
                      ? const Text(
                          'ADD ORDER',
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
      ),
    );
  }
}
