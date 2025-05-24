import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

import 'app/modules/spalsh/bindings/spalsh_binding.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = AppPages.INITIAL;

  try {
    final appLinks = AppLinks();
    final initialLink = await appLinks.getInitialLinkString();

    if (initialLink != null) {
      print('Initial link: $initialLink'); // 👈 Tambah di sini
      final uri = Uri.parse(initialLink);
      print('Parsed path: ${uri.path}');   // 👈 Tambah di sini
      if (uri.path == '/login' || uri.path == '/login-page') {
        initialRoute = Routes.LOGIN_PAGE;
      }
    }
  } catch (e) {
    print("Failed to get initial app link: $e");
  }

  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: SpalshBinding(),
    ),
  );
}

