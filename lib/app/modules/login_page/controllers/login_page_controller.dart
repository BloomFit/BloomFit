import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class LoginPageController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

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
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final token = data['access_token'];
        final username = data['data']['username'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);

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
}
