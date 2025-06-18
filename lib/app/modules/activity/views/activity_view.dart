import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/activity_controller.dart';
import '../../../routes/app_pages.dart';

// Model data chart
class LoginChartData {
  final String date;
  final int count;

  LoginChartData(this.date, this.count);
}

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
  List<LoginChartData> getChartData(List<LoginHistory> historyList) {
    final Map<String, int> frequencyMap = {};

    for (var item in historyList) {
      final dateKey = DateFormat('dd/MM').format(item.loginTime);
      frequencyMap[dateKey] = (frequencyMap[dateKey] ?? 0) + 1;
    }

    final sortedKeys = frequencyMap.keys.toList()..sort();

    return sortedKeys
        .map((key) => LoginChartData(key, frequencyMap[key]!))
        .toList();
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
          }),
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

        final chartData = getChartData(historyList);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Grafik Login Harian',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Login per Hari'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<LoginChartData, String>>[
                  ColumnSeries<LoginChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (LoginChartData data, _) => data.date,
                    yValueMapper: (LoginChartData data, _) => data.count,
                    name: 'Login',
                    color: theme.primaryColor,
                    dataLabelSettings:
                    const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Detail Riwayat Login',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...historyList.map((item) {
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
                          Text(
                              '${item.provider} • ${formatDate(item.loginTime)}'),
                          if (item.device.isNotEmpty)
                            Text('Device: ${item.device}'),
                        ],
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ],
        );
      }),
    );
  }
}
