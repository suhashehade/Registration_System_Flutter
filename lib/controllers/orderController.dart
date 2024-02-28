import 'package:get/get.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/order.dart';

class OrderController extends GetxController {
  RxList orders = [].obs;
  RxBool isChecked = false.obs;
  RxInt userId = 0.obs;
  RxInt currencyId = 0.obs;
  RxDouble rate = 0.0.obs;
  RxString type = "".obs;
  RxString stateKeyword = "".obs;
  RxBool isDescSorted = false.obs;
  RxBool isSorted = false.obs;

  toggleCheck(value) {
    isChecked.value = value!;
  }

  changeSorted() {
    isSorted.value = true;
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
    SELECT users.name AS username, users.national_number AS nationalNumber, 
    users.date_of_birth AS dateOfBirth, users.phone, users.photo, users.email,
    users.title, currencies.name AS currencyName, currencies.symbol, currencies.rate,
    orders.orderDate, orders.status AS state, orders.orderAmount AS amount,
    orders.type AS type, orders.equalOrderAmount AS equalAmount, orders.id AS orderId,
    orders.userId, orders.currencyId
    FROM orders JOIN users 
    ON users.id=orders.userId JOIN currencies 
    ON currencies.id=orders.currencyId
''');
    orders.addAll(response);
  }

  updateOrder(String table, Order order, int id) async {
    Map<String, dynamic> orderMap = order.toMap();
    int res = await db!.update(table, orderMap, "id=$id");
    if (res > 0) {
      await updateLocalOrder(id);
    }
  }

  invertSorting() {
    isDescSorted.value = !isDescSorted.value;
  }

  insert(String table, Order order) async {
    Map<String, dynamic> orderMap = order.toMap();
    int response = await db!.insert(table, orderMap);
    List<Map> inserted = await getLast();
    Map insertedOrder = inserted[0];
    orders.add(insertedOrder);
    return response;
  }

  getLast() async {
    List<Map> response = await db!.getLast('''
 SELECT users.name AS username, users.national_number AS nationalNumber, 
    users.date_of_birth AS dateOfBirth, users.phone, users.photo, users.email,
    users.title, currencies.name AS currencyName, currencies.symbol, currencies.rate,
    orders.orderDate, orders.status AS state, orders.orderAmount AS amount,
    orders.type AS type, orders.equalOrderAmount AS equalAmount, orders.id AS orderId,
    orders.userId, orders.currencyId
    FROM orders JOIN users 
    ON users.id=orders.userId JOIN currencies 
    ON currencies.id=orders.currencyId ORDER BY orders.id DESC LIMIT 1
''');

    return response;
  }

  updateOrderState(bool state, int id) async {
    int response = await db!.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE id=$id
''');
    return response;
  }

  getOne(int id) async {
    List<Map> oneOrder = await db!.getOneOrder(''' 
    SELECT users.name AS username, users.national_number AS nationalNumber, 
    users.date_of_birth AS dateOfBirth, users.phone, users.photo, users.email,
    users.title, currencies.name AS currencyName, currencies.symbol, currencies.rate,
    orders.orderDate, orders.status AS state, orders.orderAmount AS amount,
    orders.type AS type, orders.equalOrderAmount AS equalAmount, orders.id AS orderId,
    orders.userId, orders.currencyId
    FROM orders JOIN users 
    ON users.id=orders.userId JOIN currencies 
    ON currencies.id=orders.currencyId WHERE orders.id=$id LIMIT 1
''');
    return oneOrder;
  }

  updateLocalOrder(int id) async {
    List oneOrder = await getOne(id);
    Map order = oneOrder[0];
    int index = orders.indexWhere((o) => o['orderId'] == id);
    orders.removeAt(index);
    orders.insert(index, order);
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
    Iterable filterdUsers = orders.where((element) => element['state'] == 1);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
  }

  getAllNotPaid() {
    Iterable filterdUsers = orders.where((element) => element['state'] == 0);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
  }

  filter(String value) {
    Iterable filterdUsers = orders.where((element) =>
        element['username'].toString().toLowerCase().startsWith(value) ||
        element['amount'].toString().toLowerCase().startsWith(value));
    orders.replaceRange(0, orders.length, filterdUsers.toList());
  }

  sorting() async {
    if (isDescSorted.value) {
      orders.sort((a, b) => -a['amount'].compareTo(b['amount']));
    } else {
      orders.sort((a, b) => a['amount'].compareTo(b['amount']));
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }
}
