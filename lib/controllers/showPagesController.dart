import 'package:get/get.dart';

class ShowPagesController extends GetxController {
  RxString currentPage = "users".obs;

  toggleCurrentPage(String page) {
    currentPage.value = page;
  }
}
