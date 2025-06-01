import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePageController extends GetxController {
  // Observable variables
  var username = ''.obs;
  var photoUrl = ''.obs;
  var trimester = ''.obs;
  var usiaKehamilan = ''.obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  // User ID untuk identifikasi
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Method untuk set userId dari luar (misal dari login response)
  void setUserId(String id) {
    userId.value = id;
  }

  // Method untuk mendapatkan userId dari SharedPreferences jika belum ada
  Future<void> getUserId() async {
    if (userId.value.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      userId.value = prefs.getString('userId') ?? '';

      // Jika masih kosong, mungkin perlu redirect ke login
      if (userId.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Session expired. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Redirect ke login page
        // Get.offAllNamed(Routes.LOGIN_PAGE);
      }
    }
  }

  // Load data user dari SharedPreferences atau API
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      // Load data dari local storage
      username.value = prefs.getString('username') ?? '';
      photoUrl.value = prefs.getString('photoUrl') ?? '';
      trimester.value = prefs.getString('trimester') ?? '';
      usiaKehamilan.value = prefs.getString('usiaKehamilan') ?? '';
      userId.value = prefs.getString('userId') ?? '';

      // Pastikan userId tersedia
      await getUserId();

      // Optional: Load fresh data dari server jika userId tersedia
      if (userId.value.isNotEmpty) {
        await fetchUserDataFromServer();
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data profil: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch data terbaru dari server
  Future<void> fetchUserDataFromServer() async {
    try {
      if (userId.value.isEmpty) return;

      final response = await http.get(
        Uri.parse('https://capstone6-sand.vercel.app/api/users/${userId.value}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Sesuaikan dengan struktur response API Anda
        username.value = data['data']['username'] ?? data['username'] ?? '';
        photoUrl.value = data['data']['photo_url'] ?? data['photo_url'] ?? '';
        trimester.value = data['data']['trimester'] ?? data['trimester'] ?? '';
        usiaKehamilan.value = data['data']['usia_kehamilan'] ?? data['usia_kehamilan'] ?? '';

        // Update local storage
        await _saveToLocalStorage();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Save user data
  Future<void> saveUserData(
      String newUsername,
      String newPhotoUrl, {
        String? newTrimester,
        String? newUsiaKehamilan,
      }) async {
    try {
      isUpdating.value = true;

      // Validasi input
      if (newUsername.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Username tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Jika ada perubahan foto, upload dulu
      String finalPhotoUrl = newPhotoUrl;
      if (newPhotoUrl.isNotEmpty && !newPhotoUrl.startsWith('http')) {
        Get.snackbar(
          'Info',
          'Mengupload foto...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        finalPhotoUrl = await uploadImage(newPhotoUrl);
      }

      // Prepare data untuk dikirim ke server sesuai format API
      Map<String, dynamic> updateData = {
        'username': newUsername,
        'photo_url': finalPhotoUrl,
        'trimester': newTrimester ?? trimester.value,
        'usia_kehamilan': newUsiaKehamilan ?? usiaKehamilan.value,
      };

      // Kirim ke server
      bool success = await updateUserProfile(updateData);

      if (success) {
        // Update local variables
        username.value = newUsername;
        photoUrl.value = finalPhotoUrl;
        if (newTrimester != null) trimester.value = newTrimester;
        if (newUsiaKehamilan != null) usiaKehamilan.value = newUsiaKehamilan;

        // Save to local storage
        await _saveToLocalStorage();

        Get.snackbar(
          'Sukses',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Upload image ke server
  Future<String> uploadImage(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://capstone6-sand.vercel.app/api/upload-image'),
      );

      request.headers['Authorization'] = 'Bearer ${await getAuthToken()}';
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        // Sesuaikan dengan struktur response API Anda
        return jsonData['data']['image_url'] ?? jsonData['image_url'] ?? imagePath;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return imagePath; // Return original path jika gagal upload
    }
  }

  // Update user profile ke server
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('https://capstone6-sand.vercel.app/api/users/${userId.value}/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getAuthToken()}',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Log response untuk debugging
        final responseData = json.decode(response.body);
        print('Update response: $responseData');
        return true;
      } else {
        // Log error untuk debugging
        print('Update failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Handle specific error messages
        if (response.statusCode == 400) {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Bad request');
        } else if (response.statusCode == 401) {
          throw Exception('Unauthorized - Please login again');
        } else if (response.statusCode == 404) {
          throw Exception('User not found');
        } else {
          throw Exception('Server error: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error updating profile: $e');

      // Re-throw dengan pesan yang lebih user-friendly
      if (e.toString().contains('SocketException')) {
        throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Coba lagi nanti.');
      } else {
        rethrow;
      }
    }
  }

  // Save data ke local storage
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username.value);
    await prefs.setString('photoUrl', photoUrl.value);
    await prefs.setString('trimester', trimester.value);
    await prefs.setString('usiaKehamilan', usiaKehamilan.value);
  }

  // Get auth token
  Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  // Validate username
  bool isUsernameValid(String username) {
    if (username.trim().isEmpty) return false;
    if (username.length < 3) return false;
    if (username.length > 20) return false;

    // Check for special characters (allow only alphanumeric and underscore)
    final validPattern = RegExp(r'^[a-zA-Z0-9_]+$');
    return validPattern.hasMatch(username);
  }


  // Reset form
  void resetForm() {
    loadUserData();
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Reset controller values
    username.value = '';
    photoUrl.value = '';
    trimester.value = '';
    usiaKehamilan.value = '';
    userId.value = '';
  }
}