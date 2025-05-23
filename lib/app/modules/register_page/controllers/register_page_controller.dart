import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../routes/app_pages.dart';

class RegisterPageController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://capstone6-sand.vercel.app/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      // Log untuk debugging
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Berhasil', data['message'] ?? 'Registrasi sukses');
        Get.offAllNamed(Routes.LOGIN_PAGE);
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
