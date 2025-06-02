// user_controller.dart
import 'package:get/get.dart';

class UserController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var img = ''.obs;
  var trimester = ''.obs;
  var usiaKehamilan = ''.obs;

  void updateUser({
    String? username,
    String? email,
    String? img,
    String? trimester,
    String? usiaKehamilan,
  }) {
    if (username != null) this.username.value = username;
    if (email != null) this.email.value = email;
    if (img != null) this.img.value = img;
    if (trimester != null) this.trimester.value = trimester;
    if (usiaKehamilan != null) this.usiaKehamilan.value = usiaKehamilan;
  }
}
