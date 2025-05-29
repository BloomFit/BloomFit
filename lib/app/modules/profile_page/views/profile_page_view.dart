import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';  // Import Lottie
import 'package:mobile_app/app/constants/colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.fourth,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildAppBar(),
              const SizedBox(height: 20),
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildPregnancyInfoCard(),
              const SizedBox(height: 50),

              // Tambahkan Lottie animation di sini
              SizedBox(
                height: 300,
                child: Lottie.asset(
                  'assets/images/home1.json',
                  fit: BoxFit.contain,
                ),
              ),

              Spacer(), // Mendorong tombol logout ke bawah
              _buildLogoutButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.HOME);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorsDark.aksen,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF575757), offset: Offset(-1, -1), blurRadius: 2),
                  BoxShadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
                ],
              ),
              child: Icon(Icons.arrow_back, color: AppColorsDark.teksOnPrimary, size: 20),
            ),
          ),
          Text(
            "Profile",
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColorsDark.teksOnPrimary,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 110,
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColorsDark.aksen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
                BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 16.0),
              child: Column(
                children: [
                  Obx(() => Text(
                    controller.username.value,
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColorsDark.teksOnPrimary,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Obx(() {
              final imgUrl = controller.img.value;
              return CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFE91E63),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imgUrl.isNotEmpty
                      ? NetworkImage(imgUrl)
                      : const AssetImage('assets/images/gweh.png') as ImageProvider,
                ),
              );
            }),
          ),
        ),

        Positioned(
          top: 75,
          right: 30,
          child: GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.EDIT_PROFILE_PAGE);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColorsDark.aksen,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF575757), offset: Offset(-1, -1), blurRadius: 2),
                  BoxShadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
                ],
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  color: AppColorsDark.teksOnPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPregnancyInfoCard() {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColorsDark.aksen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
          BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Kehamilan",
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColorsDark.teksOnPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              "Trimester: ${controller.trimester.value}",
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: AppColorsDark.teksOnPrimary,
              ),
            )),
            const SizedBox(height: 8),
            Obx(() => Text(
              "Usia Kehamilan: ${controller.usiaKehamilan.value}",
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: AppColorsDark.teksOnPrimary,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        // Tambahkan logika logout jika diperlukan
        Get.offAllNamed(Routes.LOGIN_PAGE);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColorsDark.aksen,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
            BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            'Logout',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
