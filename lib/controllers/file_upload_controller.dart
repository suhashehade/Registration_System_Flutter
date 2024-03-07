import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadController extends GetxController {
  RxString? imagePath = ''.obs;
  final imagePicker = ImagePicker();
  Future<void> uplaodImage() async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      imagePath!.value = pickedImage.path;
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }
}
