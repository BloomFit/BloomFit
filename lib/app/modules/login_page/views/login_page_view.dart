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

          // App Logo
          Container(
            child: Center(
              child: Image.asset(
                'assets/logo/logo2.png',
              ),
            ),
          ),

          // App Name - Safe Bump
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

          // Login Form Container
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
                    // inset: true
                  ),
                  BoxShadow(
                    color: Color(0xFF000000),
                    offset: Offset(2, 2),
                    blurRadius: 1,
                    // inset: true
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  children: [
                    // Email TextField
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, right: 5, left: 5, bottom: 0),
                      child: CustomTextField(
                        key: const Key("email"),
                        hintText: 'Email',
                        // controller: null,
                        leadingIconPath: 'assets/icons/mail.png',
                      ),
                    ),

                    // Password TextField
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 5, left: 5, bottom: 0),
                      child: CustomTextField(
                        key: const Key("lock"),
                        hintText: 'Password',
                        // isPassword: true,
                        // controller: null,
                        leadingIconPath: 'assets/icons/lock.png',
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Login Button
                    SizedBox(
                      width: 360,
                      height: 55,
                      child: InkWell(
                        key: const Key("btn_login"),
                        onTap: () {
                          Get.offAllNamed(Routes.HOME);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColorsDark.primary,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF575757),
                                offset: Offset(-2, -2),
                                blurRadius: 1,
                                // inset: true
                              ),
                              BoxShadow(
                                color: Color(0xFF000000),
                                offset: Offset(2, 2),
                                blurRadius: 1,
                                // inset: true
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
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
                    ),

                    const SizedBox(height: 20),

                    // Registration Text
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
                          onPressed: () {
                            Get.toNamed(Routes.REGISTER_PAGE);
                          },
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

                    // Footer Text (empty)
                    Center(
                      child: Text(
                        '',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.black,
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