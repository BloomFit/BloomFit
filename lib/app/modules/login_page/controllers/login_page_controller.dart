import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';
import '../../activity/controllers/activity_controller.dart';

class LoginPageController extends GetxController {
  // --- State Variables ---
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  // --- Services & Plugins ---
  final AppLinks _appLinks = AppLinks();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    handleAppLink();
  }

  /// Menangani deep link untuk auto-login.
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

  /// Mendapatkan nama perangkat untuk riwayat login.
  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return '${iosInfo.name} ${iosInfo.model}';
    } else {
      return 'Unknown Device';
    }
  }

  /// Fungsi untuk login manual dengan email dan password.
  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://backend-bloomfit.vercel.app/api/auth/login'),
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
        final id = userData['id'];
        final username = userData['username'];
        final img = userData['img'];
        final emailValue = userData['email'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('id', id);
        await prefs.setString('username', username);
        await prefs.setString('img', img ?? '');
        await prefs.setString('email', emailValue);

        // ... sisa logika setelah login berhasil ...
        final activityController = Get.put(ActivityController());
        final deviceName = await getDeviceName();
        activityController.clearHistory();
        activityController.addHistory(LoginHistory(
          email: emailValue,
          provider: 'manual',
          loginTime: DateTime.now(),
          device: deviceName,
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

  /// Fungsi untuk login dengan akun Google (Versi yang sudah diperbaiki).
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      // 1. Lakukan proses sign in dengan Google
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Dibatalkan", "Proses login dengan Google dibatalkan.");
        isLoading.value = false; // Pastikan loading berhenti
        return;
      }

      // 2. Dapatkan kredensial otentikasi dari Google untuk Firebase
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Login ke Firebase Authentication
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        Get.snackbar("Gagal", "Gagal mendapatkan data pengguna dari Firebase.");
        isLoading.value = false; // Pastikan loading berhenti
        return;
      }

      // 4. Dapatkan Firebase ID Token untuk dikirim ke backend
      final String? firebaseIdToken = await firebaseUser.getIdToken(true);

      // --- PERBAIKAN NULL SAFETY ---
      if (firebaseIdToken == null) {
        Get.snackbar("Gagal", "Gagal mendapatkan token otentikasi dari Firebase.");
        isLoading.value = false; // Pastikan loading berhenti
        return;
      }

      // 5. Kirim Firebase ID Token ke backend untuk didaftarkan/login
      final response = await http.post(
        Uri.parse('https://backend-bloomfit.vercel.app/api/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': firebaseIdToken}),
      );

      print('Backend Response Status: ${response.statusCode}');
      print('Backend Response Body: ${response.body}');

      final dynamic responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData is! Map<String, dynamic>) {
          Get.snackbar("Error", "Format respons dari server tidak valid.");
          return;
        }

        // 6. Ekstrak TOKEN dan DATA PENGGUNA dari backend
        final String? backendToken = responseData['access_token'];
        final Map<String, dynamic>? userData = responseData['user'];

        if (backendToken == null || userData == null) {
          Get.snackbar("Gagal", "Respons dari server tidak lengkap (token atau data user tidak ada).");
          return;
        }

        final String userId = (userData['id'] ?? userData['uid'] ?? '').toString();
        final String username = userData['username'] ?? googleUser.displayName ?? 'Pengguna Baru';
        final String email = userData['email'] ?? googleUser.email;
        final String imageUrl = userData['img'] ?? googleUser.photoUrl ?? '';

        if (userId.isEmpty) {
          Get.snackbar("Gagal", "ID Pengguna tidak ditemukan dari respons server.");
          return;
        }

        // 7. Simpan TOKEN dan DATA PENGGUNA ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', backendToken); // WAJIB DISIMPAN!
        await prefs.setString('id', userId);         // WAJIB DISIMPAN!
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('img', imageUrl);

        print("Data berhasil disimpan: id='$userId', token='${backendToken.substring(0, 10)}...'");

        // Lanjutkan alur aplikasi
        final activityController = Get.put(ActivityController());
        final deviceName = await getDeviceName();
        activityController.clearHistory();
        activityController.addHistory(LoginHistory(
          email: email,
          provider: 'google',
          loginTime: DateTime.now(),
          device: deviceName,
        ));

        Get.snackbar("Sukses", "Login dengan Google berhasil!");
        Get.offAllNamed(Routes.HOME);

      } else {
        final message = responseData['message'] ?? 'Terjadi kesalahan pada server.';
        Get.snackbar("Gagal Login", message);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Otentikasi", "Terjadi kesalahan Firebase: ${e.message}");
      print("FirebaseAuthException: ${e.code} - ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
      print("General Error in signInWithGoogle: $e");
    } finally {
      isLoading.value = false;
    }
  }
}