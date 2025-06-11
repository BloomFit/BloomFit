import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  final ActivityController controller = Get.find();
  final RxSet<LoginHistory> selectedItems = <LoginHistory>{}.obs;

  String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        actions: [
          Obx(() {
            if (selectedItems.isEmpty) return const SizedBox();
            return IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                controller.removeSelectedHistory(selectedItems.toList());
                selectedItems.clear();
              },
            );
          })
        ],
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

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: historyList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = historyList[index];

            return Obx(() {
              final isSelected = selectedItems.contains(item);
              return GestureDetector(
                onLongPress: () {
                  selectedItems.add(item);
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: theme.primaryColor, width: 2)
                        : BorderSide.none,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (val) {
                        if (val == true) {
                          selectedItems.add(item);
                        } else {
                          selectedItems.remove(item);
                        }
                      },
                    ),
                    title: Text(
                      item.email,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.provider} • ${formatDate(item.loginTime)}'),
                        if (item.device.isNotEmpty)
                          Text('Device: ${item.device}'),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }
}
