import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import '../../../constants/colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.fourth,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLottieSection(),
                      const SizedBox(height: 24),
                      _buildMenuGrid(),
                    ],
                  ),
                ),
              ),
            ),
            // _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting di sebelah kiri
          Expanded(
            child: _buildGreeting(),
          ),
          // Foto profil di sebelah kanan
          GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.PROFILE_PAGE);
            },
            child: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/gweh.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Obx(() => Text(
      'Hello, ${controller.username.value}🧘🏼‍♀️️',
      style: const TextStyle(
        fontFamily: 'Poppins',
        // fontFamily: , // Tambahkan font family yang sesuai
        fontSize: 25,
        color: Colors.black,
      ),
    ));
  }

  // Widget untuk menampilkan Lottie animation
  Widget _buildLottieSection() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 300,
        child: Lottie.asset(
          'assets/images/home1.json',
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppColorsDark.third?.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.animation,
                      color: Colors.white54,
                      size: 48,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Animation not found',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final Color accentColor = AppColorsDark.teksPrimary ?? Colors.pink;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMenuItem(Icons.fitness_center, 'Detection', accentColor, () {
          Get.toNamed(Routes.DETECTION_PAGE);
        }),
        _buildMenuItem(Icons.article, 'Articles', accentColor, () {
          Get.toNamed(Routes.ARTICLES);
        }),
        _buildMenuItem(Icons.video_library, 'Videos', accentColor, () {
          // Navigate to video page when clicked
          Get.toNamed(Routes.VIDEO);
        }),
        _buildMenuItem(Icons.data_object, 'Visualisasi', accentColor, (){
          Get.toNamed(Routes.VISUALIASI);
        })
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorsDark.third,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}