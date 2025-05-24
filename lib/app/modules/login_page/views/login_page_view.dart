import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.fourth,
      body: Column(
        children: [
          const SizedBox(height: 100),

          Center(
            child: Image.asset(
              'assets/logo/logo2.png',
              height: 80,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bloom ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Fit',
                style: TextStyle(
                  color: Color(0xFFEF5B85),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 200),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColorsDark.third,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF575757),
                    offset: Offset(-2, -2),
                    blurRadius: 1,
                  ),
                  BoxShadow(
                    color: Color(0xFF000000),
                    offset: Offset(2, 2),
                    blurRadius: 1,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  children: [
                    const SizedBox(height: 40),

                    // Email TextField
                    CustomTextField(
                      key: const Key("email"),
                      hintText: 'Email',
                      onChanged: (value) => controller.email.value = value,
                      leadingIconPath: 'assets/icons/mail.png',
                    ),

                    const SizedBox(height: 20),

                    // Password TextField
                    CustomTextField(
                      key: const Key("password"),
                      hintText: 'Password',
                      isPassword: true,
                      onChanged: (value) => controller.password.value = value,
                      leadingIconPath: 'assets/icons/lock.png',
                    ),

                    const SizedBox(height: 50),

                    // Login Button
                    Obx(() => SizedBox(
                      width: 360,
                      height: 55,
                      child: InkWell(
                        key: const Key("btn_login"),
                        onTap: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.isLoading.value
                                ? Colors.grey
                                : AppColorsDark.primary,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF575757),
                                offset: Offset(-2, -2),
                                blurRadius: 1,
                              ),
                              BoxShadow(
                                color: Color(0xFF000000),
                                offset: Offset(2, 2),
                                blurRadius: 1,
                              )
                            ],
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Text(
                              "Login",
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(Routes.REGISTER_PAGE),
                          child: Text(
                            'daftar',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColorsDark.teksPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 52),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
