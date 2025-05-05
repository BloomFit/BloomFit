import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_app/app/modules/spalsh/views/spalsh_view.dart';

import 'app/modules/spalsh/bindings/spalsh_binding.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: SpalshBinding(),
    ),
  );
}
