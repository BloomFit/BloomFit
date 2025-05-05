import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/app/constants/colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.bg,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // App Bar dengan tombol kembali
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol kembali
                    GestureDetector(
                      onTap: () {
                        // Navigasi kembali ke halaman Home
                        Get.offAllNamed(Routes.HOME);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColorsDark.bg,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF575757),
                              offset: Offset(-1, -1),
                              blurRadius: 2,
                            ),
                            BoxShadow(
                              color: Color(0xFF000000),
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColorsDark.teksThird,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Profile",
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColorsDark.teksThird,
                      ),
                    ),
                    // Placeholder untuk menjaga simetri layout
                    SizedBox(width: 40),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Card pertama
                  Container(
                    width: double.infinity,
                    height: 110,
                    margin: const EdgeInsets.only(top: 60),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColorsDark.bg,
                        borderRadius: BorderRadius.circular(16),
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
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 16.0),
                        child: Column(
                          children: [
                            Text(
                              'yaseruuu',
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColorsDark.teksThird,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/gweh.png'),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 75,
                    right: 30,
                    child: GestureDetector(
                      onTap: () {
                        print("Edit Profile Button Pressed");
                        Get.offAllNamed(Routes.EDIT_PROFILE_PAGE);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColorsDark.bg,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF575757),
                              offset: Offset(-1, -1),
                              blurRadius: 2,
                            ),
                            BoxShadow(
                              color: Color(0xFF000000),
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          'Edit',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColorsDark.teksThird,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColorsDark.bg,
                  borderRadius: BorderRadius.circular(16),
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
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Feature Card 1',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColorsDark.teksThird,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColorsDark.bg,
                  borderRadius: BorderRadius.circular(16),
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
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Feature Card 2',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColorsDark.teksThird,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}