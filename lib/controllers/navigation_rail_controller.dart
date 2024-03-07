import 'package:get/get.dart';

class NavigationRailController extends GetxController {
  RxInt index = 0.obs;

  changeIndex(selectedIndex) {
     index.value = selectedIndex;
  }
}
