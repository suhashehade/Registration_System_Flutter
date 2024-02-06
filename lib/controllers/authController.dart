import 'package:get/get.dart';
import 'package:registration_app/main.dart';

class AuthController extends GetxController {
  RxBool isChecked = false.obs;

  toggleCheck(value) {
    isChecked.value = value!;
  }

  signUp(String table, Map<String, String> user) async {
    int response = await db!.insert(table, user);
    return response;
  }

  login(name, nationalNumber) async {
    List<Map> res = await db!.login('''SELECT * FROM users WHERE 
                                name='$name' 
                                AND national_number='$nationalNumber' ''');

    return res;
  }

  logout() {
    prefs!.clear();
  }
}
