import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePageController extends GetxController {
  var username = ''.obs;
  var photoUrl = ''.obs;
  var trimester = ''.obs;
  var usiaKehamilan = ''.obs;

  final String apiUrl = 'https://capstone6-sand.vercel.app/api/29c2e2ae-3057-4055-b136-c644badb5b79/update';

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'User';
    photoUrl.value = prefs.getString('img') ?? '';
  }

  Future<void> updateProfile({
    required String newUsername,
    String? newPassword, // kalau ada ubah password
    String? imagePath, // path file gambar lokal, bisa null
    String? newTrimester,
    String? newUsiaKehamilan,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan');
        return;
      }

      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('PATCH', uri);

      request.headers['Authorization'] = 'Bearer $token';

      // Isi fields
      request.fields['username'] = newUsername;
      if (newPassword != null && newPassword.isNotEmpty) {
        request.fields['password'] = newPassword;
      }

      // Tambah file jika ada
      if (imagePath != null && imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Simpan data lokal (kalau API response ada update username/photo dll)
        await saveUserData(
          newUsername,
          data['user']?['img'] ?? photoUrl.value,
          newTrimester: newTrimester,
          newUsiaKehamilan: newUsiaKehamilan,
        );
        Get.snackbar('Sukses', 'Profil berhasil diperbarui');
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Gagal', data['message'] ?? 'Gagal update profil');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
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
