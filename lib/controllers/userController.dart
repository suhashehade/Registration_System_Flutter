import 'package:get/get.dart';
import 'package:registration_app/main.dart';

class UserController extends GetxController {
  RxList users = [].obs;

  getUsers(String table) async {
    List<Map> response = await db!.read(table);
    users.addAll(response);
  }

  delete(int id) async {
    int response = await db!.delete('users', 'id=$id');
    if (response > 0) {
      users.removeWhere((user) => user!['id'] == id);
    }
  }

  getUser(int id) async {
    List<Map> response = await db!.getOne('users', "id=$id");
    return response[0];
  }

  updateUser(String table, Map<String, dynamic> user, int id) async {
    await db!.update(table, user, "id=$id");
  }

  filter(String value) {
    Iterable filterdUsers = users.where((element) =>
        element['name'].toString().toLowerCase().startsWith(value) ||
        element['title'].toString().toLowerCase().startsWith(value));
    users.replaceRange(0, users.length, filterdUsers.toList());
  }

  @override
  void onInit() {
    super.onInit();
    getUsers('users');
  }
}
