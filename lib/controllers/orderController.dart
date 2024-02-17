import 'package:get/get.dart';
import 'package:registration_app/main.dart';

class OrderController extends GetxController {
  RxList orders = [].obs;
  RxList states = [].obs;
  RxBool isChecked = false.obs;
  RxInt userId = 0.obs;
  RxInt currencyId = 0.obs;
  RxDouble rate = 0.0.obs;
  RxString type = "".obs;
  RxString stateKeyword = "".obs;
  RxBool isDescSorted = false.obs;

  toggleCheck(value) {
    isChecked.value = value!;
  }

  updateStateKeyWord(value) {
    if (value == 1) {
      stateKeyword.value = "Paid";
    } else {
      stateKeyword.value = "Not Paid";
    }
    return stateKeyword.value;
  }

  updateCurrencyRate(double value) {
    rate.value = value;
  }

  updateType(String value) {
    type.value = value;
  }

  upadateSelectedCurrencyId(int value) {
    currencyId.value = value;
  }

  upadateSelectedUserId(int value) {
    userId.value = value;
  }

  getOrders() async {
    List response = await db!.readJoin('''
    SELECT users.name AS username, currencies.name AS currencyName, 
    orders.orderDate, orders.status AS state, orders.orderAmmount AS amount,
    orders.type AS type, orders.equalOrderAmmount AS equalAmount, orders.id AS orderId,
    orders.userId, orders.currencyId
    FROM orders JOIN users 
    ON users.id=orders.userId JOIN currencies 
    ON currencies.id=orders.currencyId
''');
    orders.addAll(response);
    addStates();
  }

  updateOrder(String table, Map<String, dynamic> order, int id) async {
   int res = await db!.update(table, order, "id=$id");
   return res;
  }

  addStates() {
    Iterable orderStates = orders.map((o) => o['state']);
    states.addAll(orderStates);
  }

  switchOrderState(int index, bool value) {
    states[index] = value ? 1 : 0;
  }

  invertSorting() {
    isDescSorted.value = !isDescSorted.value;
  }

  insert(String table, Map<String, dynamic> order) async {
    int response = await db!.insert(table, order);
    return response;
  }

  updateOrderState(int state, int id) async {
    int response = await db!.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE id=$id
''');
    return response;
  }

  delete(String table, int id) async {
    int response = await db!.delete(table, "id=$id");
    if (response > 0) {
      orders.removeWhere((o) => o!['orderId'] == id);
    }
  }

  int findEqualAmmount(double amount, double value) {
    double equalAmount = 0.0;
    equalAmount = amount / value;
    return equalAmount.round();
  }

  getAllPaid() {
    states.clear();
    Iterable filterdUsers = orders.where((element) => element['state'] == 1);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
    addStates();
  }

  getAllNotPaid() {
    states.clear();
    Iterable filterdUsers = orders.where((element) => element['state'] == 0);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
    addStates();
  }

  filter(String value) {
    Iterable filterdUsers = orders.where((element) =>
        element['username'].toString().toLowerCase().startsWith(value) ||
        element['amount'].toString().toLowerCase().startsWith(value));
    orders.replaceRange(0, orders.length, filterdUsers.toList());
  }

  sorting() {
    if (isDescSorted.value) {
      states.clear();
      orders.sort((a, b) => -a['amount'].compareTo(b['amount']));
      addStates();
    } else {
      states.clear();
      orders.sort((a, b) => a['amount'].compareTo(b['amount']));
      addStates();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }
}
