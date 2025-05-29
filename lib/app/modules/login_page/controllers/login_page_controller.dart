import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';

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
        print('Latest link: $latestLink');
        print('Parsed path: ${uri.path}');

        if (uri.path == '/login-auto') {
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
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final token = data['access_token'];
        final username = data['data']['username'];
        final img = data['data']['img'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);
        await prefs.setString('img', img);

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
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut(); // Optional: logout sebelumnya
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Login Google dibatalkan pengguna");
        Get.snackbar("Login Dibatalkan", "Pengguna membatalkan login Google.");
        return;
      }

      // Simpan data ke GetStorage dengan struktur yang sama seperti login API
      // final box = get();
      // box.write('userName', googleUser.displayName);
      // box.write('userEmail', googleUser.email);
      // box.write('userPassword', '*******'); // Kosong karena Google login
      // box.write('authType', 'google'); // Buat pembeda


      print("Login sukses: ${googleUser.displayName} (${googleUser.email})");

      Get.snackbar("Sukses", "Login Google berhasil");

      // Navigasi ke halaman utama
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print("Error saat login Google: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat login: $e");
    }
  }
}