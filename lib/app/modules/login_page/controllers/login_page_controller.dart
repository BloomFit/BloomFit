import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';
import '../../activity/controllers/activity_controller.dart';

class LoginPageController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final AppLinks _appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    handleAppLink();
  }

  Future<void> handleAppLink() async {
    try {
      final latestLink = await _appLinks.getLatestLinkString();
      if (latestLink != null) {
        final uri = Uri.parse(latestLink);
        if (uri.path == '/login-page') {
          email.value = uri.queryParameters['email'] ?? '';
          password.value = uri.queryParameters['password'] ?? '';
          if (email.isNotEmpty && password.isNotEmpty) {
            await login();
          }
        }
      }
    } catch (e) {
      print('Error getting app link: $e');
    }
  }

  Future<void> login() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://capstone6-sand.vercel.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value.trim(),
          'password': password.value.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['access_token'];
        final userData = data['data'];
        final username = userData['username'];
        final img = userData['img'];
        final id = userData['id'];
        final emailValue = userData['email'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);
        await prefs.setString('img', img);
        await prefs.setString('id', id);
        await prefs.setString('email', emailValue);

        final activityController = Get.put(ActivityController());
        activityController.clearHistory(); // bersihkan tampilan lama
        activityController.addHistory(LoginHistory(
          email: emailValue,
          provider: 'manual',
          loginTime: DateTime.now(),
        ));

        Get.snackbar('Berhasil', 'Login berhasil');
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      await googleSignIn.signOut(); // optional
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Login Dibatalkan", "Pengguna membatalkan login Google.");
        return;
      }

      final username = googleUser.displayName ?? 'User';
      final emailValue = googleUser.email;
      final img = googleUser.photoUrl ?? '';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('email', emailValue);
      await prefs.setString('img', img);

      final activityController = Get.put(ActivityController());
      activityController.clearHistory(); // bersihkan tampilan lama
      activityController.addHistory(LoginHistory(
        email: emailValue,
        provider: 'google',
        loginTime: DateTime.now(),
      ));

      print("Login sukses: $username ($emailValue)");
      Get.snackbar("Sukses", "Login Google berhasil");
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print("Error saat login Google: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat login: $e");
    }
  }
}
