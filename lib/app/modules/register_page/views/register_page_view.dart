import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/register_page_controller.dart';

class RegisterPageView extends GetView<RegisterPageController> {
  const RegisterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.fourth,
      body: Column(
        children: [
          const SizedBox(height: 80),

          // App Logo
          Center(
            child: Image.asset(
              'assets/logo/logo2.png',
              height: 80,
            ),
          ),

          // App Name - Bloom Fit
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

          const SizedBox(height: 150),

          // Register Form Container
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
                    const SizedBox(height: 30),

                    // Title
                    Center(
                      child: Text(
                        "Daftar Akun",
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Full Name TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomTextField(
                        key: const Key("username"),
                        hintText: 'Nama Lengkap',
                        controller: controller.usernameController,
                        leadingIconPath: 'assets/icons/account.png',
                      ),
                    ),

                    // Email TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomTextField(
                        key: const Key("email"),
                        hintText: 'Email',
                        controller: controller.emailController,
                        leadingIconPath: 'assets/icons/mail.png',
                      ),
                    ),

                    // Password TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomTextField(
                        key: const Key("password"),
                        hintText: 'Password',
                        isPassword: true,
                        controller: controller.passwordController,
                        leadingIconPath: 'assets/icons/lock.png',
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Register Button with loading state
                    Obx(() => SizedBox(
                      width: 360,
                      height: 55,
                      child: InkWell(
                        key: const Key("btn_register"),
                        onTap: controller.isLoading.value
                            ? null
                            : controller.register,
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
                              "Daftar",
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

                    const SizedBox(height: 15),

                    // Login Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun?',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.LOGIN_PAGE);
                          },
                          child: Text(
                            'login',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColorsDark.teksPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Terms and Conditions
                    Center(
                      child: Text(
                        'Dengan mendaftar, Anda menyetujui syarat dan ketentuan kami',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ),
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
