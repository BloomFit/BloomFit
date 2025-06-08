import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../../../routes/app_pages.dart'; // Pastikan import route profile

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Login'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed(Routes.PROFILE_PAGE);
          },
        ),
      ),
      body: Obx(() {
        final historyList = controller.historyList;

        if (historyList.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada riwayat login.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final item = historyList[index];
            return ListTile(
              leading: const Icon(Icons.login, color: Colors.blue),
              title: Text(item.email),
              subtitle: Text(
                '${item.provider} • ${item.loginTime.toLocal()}',
              ),
            );
          },
        );
      }),
    );
  }
}
