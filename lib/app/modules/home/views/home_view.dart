import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';

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
                      _buildGreeting(),
                      const SizedBox(height: 8),
                      _buildWeekTitle(),
                      const SizedBox(height: 16),
                      _buildDaySelector(),
                      const SizedBox(height: 24),
                      _buildBabyInfo(),
                      const SizedBox(height: 24),
                      _buildStats(),
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
          Row(
            children: [
            ],
          ),
          GestureDetector(
            onTap: () {
              // Navigasi ke halaman profil menggunakan GetX
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
    return const Text(
      'Hello, Yaseruuu',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildWeekTitle() {
    return const Text(
      '16th Week of Pregnancy',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDayItem('Mon', '16', false),
          _buildDayItem('Mon', '17', false),
          _buildDayItem('Tue', '18', true),
          _buildDayItem('Wed', '19', false),
          _buildDayItem('Wed', '20', false),
          _buildDayItem('Wed', '21', false),
          _buildDayItem('Wed', '22', false),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, String date, bool isSelected) {
    final Color activeColor = AppColorsDark.aksen ?? Colors.pink;

    return Container(
      width: 50,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabyInfo() {
    final Color accentColor = AppColorsDark.aksen ?? Colors.pink;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pregnant_woman_sharp,
              color: AppColorsDark.teksPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Your baby is the size of a pear',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem('Baby Height', '17 cm'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem('Baby Weight', '110 gr'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem('Days Left', '168 days'),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
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
        _buildMenuItem(Icons.medication, 'Medicines', accentColor, () {
          // Handle medicines menu click
        }),
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