import 'package:get/get.dart';
import 'package:registration_app/main.dart';

class CurrenciesController extends GetxController {
  RxList currencies = [].obs;

  insert(String table, Map<String, String> currency) async {
    int response = await db!.insert(table, currency);
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
    int response = await db!.delete('currencies', 'id=$id');
    if (response > 0) {
      currencies.removeWhere((element) => element!['id'] == id);
    }
  }

  updateCurrency(String table, Map<String, String> currency, int id) async {
    await db!.update(table, currency, "id=$id");
  }

  getCurrency(int id) async {
   var res = await db!.getOne('currencies',"id=$id");
   return res[0];
  }

  @override
  void onInit() {
    super.onInit();
    getCurrencies('currencies');
  }
}
