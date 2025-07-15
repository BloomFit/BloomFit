import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Pilih Latihan Senam",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kartu untuk Pilihan
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
                      // Dropdown Trimester
                      Obx(() => DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration(
                          label: "Trimester Kehamilan",
                          icon: Icons.filter_alt_rounded,
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
                      // Dropdown Pose
                      Obx(() {
                        final selected = controller.selectedTrimester.value;
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
                              ? const SizedBox.shrink()
                              : DropdownButtonFormField<String>(
                            key: ValueKey(selected),
                            decoration: _buildInputDecoration(
                              label: "Jenis Pose Senam",
                              icon: Icons.self_improvement,
                              primaryColor: accentColor,
                            ),
                            value: controller.selectedPose.value,
                            items: controller
                                .trimesterPoses[selected]!
                                .map((pose) => DropdownMenuItem(
                              value: pose,
                              child: Text(
                                  pose.replaceAll("_", " ")),
                            ))
                                .toList(),
                            onChanged: controller.selectPose,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Video Tutorial
              Obx(() {
                final pose = controller.selectedPose.value;
                final videoPath = controller.poseVideos[pose];
                if (videoPath == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contoh Gerakan:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _PoseVideoPlayer(videoPath: videoPath),
                    ],
                  ),
                );
              }),

              const Spacer(),
              // Tombol Mulai Deteksi
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
                    : null,
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
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: primaryColor.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  ButtonStyle _buildButtonStyle(Color primaryColor, Color accentColor) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      minimumSize: const Size.fromHeight(56),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      elevation: 5,
      shadowColor: primaryColor.withOpacity(0.4),
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.grey.shade500,
    );
  }
}

// Widget untuk video tutorial langsung dalam file yang sama
class _PoseVideoPlayer extends StatefulWidget {
  final String videoPath;
  const _PoseVideoPlayer({required this.videoPath});

  @override
  State<_PoseVideoPlayer> createState() => _PoseVideoPlayerState();
}

class _PoseVideoPlayerState extends State<_PoseVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void didUpdateWidget(covariant _PoseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller.pause();
      _controller.dispose();
      _controller = VideoPlayerController.asset(widget.videoPath)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
          _controller.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 450, // tinggi video dibatasi
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
