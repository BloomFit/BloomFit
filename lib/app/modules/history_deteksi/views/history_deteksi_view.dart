import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../detection_page/controllers/detection_page_controller.dart'; // pastikan path-nya sesuai

class HistoryDeteksiView extends StatelessWidget {
  const HistoryDeteksiView({super.key});

  @override
  Widget build(BuildContext context) {
    final detectionController = Get.find<DetectionPageController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Deteksi'),
        centerTitle: true,
      ),
      body: Obx(() {
        final history = detectionController.detectionHistory;
        if (history.isEmpty) {
          return const Center(
            child: Text('Belum ada riwayat deteksi.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final reversed = history.reversed.toList();
            final label = reversed[index];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(label),
              ),
            );
          },
        );
      }),
    );
  }
}
