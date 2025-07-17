import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class EditProfilePageController extends GetxController {
  var username = ''.obs;
  var photoUrl = ''.obs;
  var trimester = ''.obs;
  var usiaKehamilan = ''.obs;

  late TextEditingController usernameController;
  RxString selectedTrimester = ''.obs;
  RxString selectedUsia = ''.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    loadUserData();
  }

  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    photoUrl.value = prefs.getString('img') ?? '';
    trimester.value = prefs.getString('trimester') ?? '';
    usiaKehamilan.value = prefs.getString('usiaKehamilan') ?? '';

    usernameController.text = username.value;
    selectedTrimester.value = trimester.value;
    selectedUsia.value = usiaKehamilan.value;
  }

  Future<void> saveUserData(
      String newUsername,
      String imagePath, {
        String? currentPassword,
        String? newPassword,
        String? newTrimester,
        String? newUsiaKehamilan,
      }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final userId = prefs.getString('id');

      if (userId == null) {
        Get.snackbar('Error', 'ID pengguna tidak ditemukan. Silakan login ulang.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final url = Uri.parse('https://backend-bloomfit.vercel.app/api/users/$userId/update');
      final request = http.MultipartRequest('PATCH', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Isi field
      request.fields['username'] = newUsername;
      if (currentPassword != null && newPassword != null) {
        request.fields['current_password'] = currentPassword;
        request.fields['new_password'] = newPassword;
      }

      if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'img',
          imagePath,
          filename: basename(imagePath),
        ));
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final user = data['user'];

        // Simpan data terbaru ke SharedPreferences
        await prefs.setString('username', user['username']);
        await prefs.setString('img', user['img'] ?? '');
        if (newTrimester != null) await prefs.setString('trimester', newTrimester);
        if (newUsiaKehamilan != null) await prefs.setString('usiaKehamilan', newUsiaKehamilan);

        // Perbarui nilai lokal
        username.value = user['username'];
        photoUrl.value = user['img'] ?? '';
        if (newTrimester != null) trimester.value = newTrimester;
        if (newUsiaKehamilan != null) usiaKehamilan.value = newUsiaKehamilan;

        Get.snackbar('Sukses', 'Profil berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final error = jsonDecode(responseBody);
        Get.snackbar('Gagal', error['message'] ?? 'Terjadi kesalahan',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
