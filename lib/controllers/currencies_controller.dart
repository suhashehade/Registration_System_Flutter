import 'package:get/get.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/currency.dart';

class CurrenciesController extends GetxController {
  RxList currencies = [].obs;
  RxInt deletedIndex = 0.obs;

  insert(String table, Currency currency) async {
    Map<String, dynamic> currencyMap = currency.toMap();
    int response = await db!.insert(table, currencyMap);
    List inserted = await getLast();
    Map insertedCurrency = inserted[0];
    currencies.add(insertedCurrency);
    return response;
  }

  getLast() async {
    List<Map> response = await db!.getLast('''
        SELECT * FROM currencies ORDER BY id DESC LIMIT 1
    ''');

    return response;
  }

  getCurrencies(String table) async {
    List response = await db!.read(table);
    currencies.addAll(response);
  }

  filter(String keyword) {
    Iterable filterdCurrencies = currencies.where((element) => element['name']
        .toString()
        .toLowerCase()
        .startsWith(keyword.toLowerCase()));
    currencies.replaceRange(0, currencies.length, filterdCurrencies.toList());
  }

  delete(int id) async {
    int index = currencies.indexWhere((u) => u['id'] == id);
    deletedIndex.value = index;
    int response = await db!.delete('currencies', 'id=$id');
    if (response > 0) {
      currencies.removeWhere((element) => element!['id'] == id);
    }
  }

  updateCurrency(String table, Currency currency, int id) async {
    Map<String, dynamic> currencyMap = currency.toMap();
    int response = await db!.update(table, currencyMap, "id=$id");
    if (response > 0) {
      await updateLocalCurrency(id);
    }
  }

  updateLocalCurrency(int id) async {
    List oneCurrency = await getOne(id);
    Map currency = oneCurrency[0];
    int index = currencies.indexWhere((c) => c['id'] == id);
    currencies.removeAt(index);
    currencies.insert(index, currency);
  }

  getOne(int id) async {
    List<Map> response = await db!.getOne('currencies', "id=$id");
    return response;
  }

  getCurrency(int id) async {
    var res = await db!.getOne('currencies', "id=$id");
    return res[0];
  }

  @override
  void onInit() {
    super.onInit();
    getCurrencies('currencies');
  }
}
