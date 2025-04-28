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
      backgroundColor: AppColorsDark.primary,
      body: Column(
        children: [
          const SizedBox(height: 137),
          const SizedBox(
            height: 140,
            width: 142,
          ),
          const SizedBox(height: 100),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColorsDark.primary,
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
                    Padding(
                        padding: const EdgeInsets.only(
                    top: 20, right: 5, left: 5, bottom: 0),
                      child: CustomTextField(
                        key: const Key("lock"),
                        hintText: 'Password',
                        // controller: null,
                        leadingIconPath: 'assets/icons/lock.png',
                      ),

                    ),
                    // const SizedBox(height: 20),

                    // const SizedBox(height: 20),
                    // TextField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     hintText: 'Password',
                    //     prefixIcon: const Icon(Icons.lock),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 50),
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
                              "Sign In",
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
                            Get.toNamed(Routes.PROFILE_PAGE);
                          },
                          child: Text(
                            'daftar',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColorsDark.third,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 52),
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
