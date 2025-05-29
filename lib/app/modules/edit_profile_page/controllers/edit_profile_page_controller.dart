import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePageController extends GetxController {
  var username = ''.obs;
  var photoUrl = ''.obs;
  var trimester = ''.obs;
  var usiaKehamilan = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'User';
    photoUrl.value = prefs.getString('img') ?? '';
    trimester.value = prefs.getString('trimester') ?? 'Trimester 1';
    usiaKehamilan.value = prefs.getString('usiaKehamilan') ?? '3 Minggu';
  }

  Future<void> saveUserData(
      String newUsername,
      String newPhotoUrl, {
        String? newTrimester,
        String? newUsiaKehamilan,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
    await prefs.setString('img', newPhotoUrl);

    if (newTrimester != null) {
      await prefs.setString('trimester', newTrimester);
      trimester.value = newTrimester;
    }
    if (newUsiaKehamilan != null) {
      await prefs.setString('usiaKehamilan', newUsiaKehamilan);
      usiaKehamilan.value = newUsiaKehamilan;
    }

    username.value = newUsername;
    photoUrl.value = newPhotoUrl;
  }
}
