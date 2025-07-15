import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import '../controllers/selection_page_controller.dart';

class SelectionPageView extends GetView<SelectionPageController> {
  const SelectionPageView({super.key});

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Colors.teal.shade400;
    final Color backgroundColor = Colors.grey.shade100;
    final Color cardColor = Colors.white;
    final Color accentColor = Colors.pink.shade300;

    return Scaffold(
      backgroundColor: backgroundColor, // Ganti warna background
      appBar: AppBar(
        title: const Text(
          "Pilih Latihan Senam",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparan agar menyatu
        elevation: 0, // Hilangkan bayangan untuk tampilan modern
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Kartu untuk Pilihan ---
              Card(
                elevation: 4,
                shadowColor: primaryColor.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // --- Dropdown Trimester ---
                      Obx(() => DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration(
                          label: "Trimester Kehamilan",
                          icon: Icons.filter_alt_rounded, // Ikon untuk trimester
                          primaryColor: accentColor,
                        ),
                        value: controller.selectedTrimester.value,
                        items: controller.trimesterPoses.keys
                            .map((trimester) => DropdownMenuItem(
                          value: trimester,
                          child: Text(trimester),
                        ))
                            .toList(),
                        onChanged: controller.selectTrimester,
                      )),
                      const SizedBox(height: 20),
                      // --- Dropdown Pose ---
                      Obx(() {
                        final selected = controller.selectedTrimester.value;
                        // Tampilkan dengan animasi saat muncul
                        return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.2),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: (selected == null)
                                ? const SizedBox.shrink() // Hilang jika belum ada trimester
                                : DropdownButtonFormField<String>(
                              key: ValueKey(selected), // Key untuk reset state
                              decoration: _buildInputDecoration(
                                label: "Jenis Pose Senam",
                                icon: Icons.self_improvement, // Ikon untuk pose
                                primaryColor: accentColor,
                              ),
                              value: controller.selectedPose.value,
                              items: controller
                                  .trimesterPoses[selected]!
                                  .map((pose) => DropdownMenuItem(
                                value: pose,
                                child: Text(pose.replaceAll("_", " ")),
                              ))
                                  .toList(),
                              onChanged: controller.selectPose,
                            )
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const Spacer(), // Mendorong tombol ke bawah
              // --- Tombol Aksi (Call to Action) ---
              Obx(() => ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_fill_rounded, size: 28),
                onPressed: (controller.selectedTrimester.value != null &&
                    controller.selectedPose.value != null)
                    ? () {
                  Get.toNamed(
                    Routes.DETECTION_PAGE,
                    arguments: controller.selectedPose.value,
                  );
                }
                    : null, // Otomatis nonaktif jika pilihan belum lengkap
                label: const Text("Mulai Deteksi"),
                style: _buildButtonStyle(accentColor, accentColor),
              )),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required Color primaryColor,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: primaryColor),
      prefixIcon: Icon(
        icon,
        color: primaryColor,
      ),
      filled: true,
      fillColor: primaryColor.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Tidak ada border di state normal
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryColor, // Border saat di-tap/fokus
          width: 2,
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle(Color primaryColor, Color accentColor) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Warna ikon dan teks
      backgroundColor: primaryColor, // Warna background tombol
      minimumSize: const Size.fromHeight(56), // Tinggi tombol
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Membuat tombol lebih bulat
      ),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      elevation: 5,
      shadowColor: primaryColor.withOpacity(0.4),
      // Style untuk state disabled (saat pilihan belum lengkap)
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.grey.shade500,
    );
  }
}