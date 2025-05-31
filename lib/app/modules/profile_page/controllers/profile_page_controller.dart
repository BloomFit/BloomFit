import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var img = ''.obs;
  var trimester = ''.obs;
  var usiaKehamilan = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    email.value = prefs.getString('email') ?? 'email';
    username.value = prefs.getString('username') ?? 'User';
    img.value = prefs.getString('img') ?? '';
    trimester.value = prefs.getString('trimester') ?? 'Trimester 1';
    usiaKehamilan.value = prefs.getString('usiaKehamilan') ?? '3 Minggu';
  }
}
