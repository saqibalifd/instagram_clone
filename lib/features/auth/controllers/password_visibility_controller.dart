import 'package:get/get.dart';

class PasswordVisibilityController extends GetxController {
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
