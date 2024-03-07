import 'package:get/get.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/user.dart';

class UserController extends GetxController {
  RxList users = [].obs;
  RxInt deletedIndex = 0.obs;
  getUsers(String table) async {
    List<Map> response = await db!.read(table);
    users.addAll(response);
  }

  insert(String table, CustomUser user) async {
    Map<String, dynamic> userMap = user.toMap();
    int response = await db!.insert(table, userMap);
    if (response > 0) {
      List<Map> lastInserted = await getLast();
      Map lastUser = lastInserted[0];
      users.add(lastUser);
    }
    return response;
  }

  getLast() async {
    return await db!
        .getLast('''SELECT * FROM users ORDER BY id DESC LIMIT 1''');
  }

  delete(int id) async {
    int index = users.indexWhere((u) => u['id'] == id);
    deletedIndex.value = index;
    int response = await db!.delete('users', 'id=$id');
    if (response > 0) {
      users.removeWhere((user) => user!['id'] == id);
    }
  }

  updateUser(String table, CustomUser user, int id) async {
    Map<String, dynamic> userMap = user.toMap();
    int res = await db!.update(table, userMap, "id=$id");
    if (res > 0) {
      await updateLocalUser(id);
    }
  }

  getOne(int id) async {
    return await db!.getOne('users', "id=$id");
  }

  updateLocalUser(int id) async {
    List oneCurrency = await getOne(id);
    Map currency = oneCurrency[0];
    int index = users.indexWhere((c) => c['id'] == id);
    users.removeAt(index);
    users.insert(index, currency);
  }

  filter(String value) {
    Iterable filterdUsers = users.where((element) =>
        element['name'].toString().toLowerCase().startsWith(value) ||
        element['title'].toString().toLowerCase().startsWith(value));
    users.replaceRange(0, users.length, filterdUsers.toList());
  }

  getCurrentUser(String email) async {
    List<Map> response = await db!.getOne('users', "email=$email");
    Map user = response[0];
    return user;
  }

  @override
  void onInit() {
    super.onInit();
    getUsers('users');
  }
}
