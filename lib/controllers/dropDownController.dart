import 'package:get/get.dart';

class DropDownController extends GetxController {
  RxInt selectedCurrency = 0.obs;
  RxInt selectedUser = 0.obs;
  RxString selectedType = "".obs;

  void updateSelectedCurrency(value) {
    selectedCurrency.value = value;
  }

  void updateSelectedUser(value) {
    selectedUser.value = value;
  }

  void updateSelectedType(String value) {
    selectedType.value = value;
  }

  String? validateCurrency(value) {
    if (value == 0) {
      return "Select Currency";
    }

    return null;
  }

  String? validateUser(value) {
    if (value == 0) {
      return "Select User";
    }

    return null;
  }


  String? validateType(String value) {
    if (value == "") {
      return "Select Type";
    }

    return null;
  }
}
