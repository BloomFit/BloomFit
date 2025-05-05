import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';

void main() {
  runApp(const SafeBumpApp());
}

class SafeBumpApp extends StatelessWidget {
  const SafeBumpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Bump',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF4081),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFFF4081),
          secondary: const Color(0xFF6B8CEE),
        ),
        fontFamily: 'Poppins',
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  // Use initialized values instead of late variables to avoid initialization errors
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animations properly
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFFCF0F3).withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // App Logo/Name with animation
                    FadeTransition(
                      opacity: _fadeAnimation!,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                        ).animate(_animationController!),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bloom',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              TextSpan(
                                text: 'Fit',
                                style: TextStyle(
                                  color: Color(0xFFFF4081),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Pregnancy illustration with animation
                    FadeTransition(
                      opacity: _fadeAnimation!,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_animationController!),
                        child: _buildBeautifulIllustration(),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Welcome text with animation
                    FadeTransition(
                      opacity: _fadeAnimation!,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController!,
                            curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'Welcome to BloomFit,your trusted partner for a safe and healthy pregnancy journey.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Get Started button with animation
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - _animationController!.value)),
                        child: child,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4081).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF4081), Color(0xFFFF6A9E)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                         Get.offAllNamed(Routes.LOGIN_PAGE);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GET STARTED',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeautifulIllustration() {
    return Container(
      height: 320,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative circles
          Positioned(
            right: 50,
            top: 20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAFF).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 60,
            bottom: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6E5).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main mother figure
          Center(
            child: Container(
              width: 140,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6E5),
                borderRadius: BorderRadius.circular(70),
              ),
            ),
          ),

          // Bump/belly
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4081).withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF4081).withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Head
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD6E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Clock element
          Positioned(
            top: 50,
            right: 70,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAFF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.access_time,
                color: Color(0xFF6B8CEE),
                size: 28,
              ),
            ),
          ),

          // Heart elements
          Positioned(
            bottom: 90,
            left: 70,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6E5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: Color(0xFFFF4081),
                size: 24,
              ),
            ),
          ),

          // Small decorative hearts
          Positioned(
            top: 120,
            right: 100,
            child: Icon(
              Icons.favorite,
              color: const Color(0xFFFF4081).withOpacity(0.6),
              size: 18,
            ),
          ),
          Positioned(
            bottom: 150,
            left: 80,
            child: Icon(
              Icons.favorite,
              color: const Color(0xFFFF4081).withOpacity(0.6),
              size: 14,
            ),
          ),

          // Gender symbols
          Positioned(
            top: 50,
            left: 90,
            child: Row(
              children: [
                Icon(Icons.female, color: const Color(0xFFFF4081).withOpacity(0.8), size: 22),
                const SizedBox(width: 4),
                Icon(Icons.male, color: const Color(0xFF6B8CEE).withOpacity(0.8), size: 22),
              ],
            ),
          ),

          // Decorative elements
          Positioned(
            bottom: 40,
            right: 90,
            child: Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAFF),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}