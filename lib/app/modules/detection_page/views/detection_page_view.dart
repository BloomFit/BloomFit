import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detection_page_controller.dart';

class DetectionPageView extends GetView<DetectionPageController> {
  const DetectionPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Detection'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (!controller.isCameraInitialized.value || controller.cameraController == null) {
            return Center(
              child: ElevatedButton(
                onPressed: controller.startCamera,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Start Camera'),
              ),
            );
          }

          final aspectRatio = controller.cameraController!.value.aspectRatio;

          return Column(
            children: [
              Expanded(
                child: Center( // Center akan menempatkan preview di tengah
                  child: AspectRatio(
                    aspectRatio: aspectRatio, // Ini kunci agar tidak gepeng
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        controller.predictedLabel.value != 'unknown'
                            ? 'Detected: ${controller.predictedLabel.value}'
                            : 'Detecting pose...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.stopCamera,
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: controller.switchCamera,
                          icon: const Icon(Icons.flip_camera_android),
                          label: const Text('Switch'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
