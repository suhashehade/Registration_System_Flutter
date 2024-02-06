import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:registration_app/controllers/currenciesController.dart';
import 'package:registration_app/controllers/dropDownController.dart';
import 'package:registration_app/controllers/orderController.dart';
import 'package:registration_app/controllers/userController.dart';
import 'package:registration_app/pages/sideBar.dart';

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

    return Scaffold(
      drawer: const Drawer(
        child: SideBar(),
      ),
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offNamed('/orders');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
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
                          if (dropDownController.selectedCurrency.value != 0) {
                            double amount = double.parse(amountController.text);
                            double equalAmount = controller.findEqualAmmount(
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
                            double equalAmount = controller.findEqualAmmount(
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> order = {
                        "currencyId": controller.currencyId.value,
                        "userId": controller.userId.value,
                        "orderDate": dateController.text,
                        "orderAmmount": amountController.text,
                        "equalOrderAmmount": equalAmountController.text,
                        "status": controller.isChecked.value ? 1 : 0,
                        "type": controller.type.value,
                      };

                      await controller.insert('orders', order);
                      Get.offNamed('/orders');
                    }
                  },
                  child: const Text('ADD ORDER'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
