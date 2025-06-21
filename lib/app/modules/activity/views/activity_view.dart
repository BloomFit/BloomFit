import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/activity_controller.dart';
import '../../../routes/app_pages.dart';

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
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
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
          padding: const EdgeInsets.all(20),
          children: [
            // Section Title
            Text(
              'Grafik Login Harian',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ).animate().fade(duration: 500.ms).slideY(begin: -0.2),

            const SizedBox(height: 12),

            // Chart Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(
                      text: 'Login per Hari',
                      textStyle: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<LoginChartData, String>>[
                      ColumnSeries<LoginChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (LoginChartData data, _) => data.date,
                        yValueMapper: (LoginChartData data, _) => data.count,
                        name: 'Login',
                        color: Colors.pinkAccent,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 24),

            // Section Title
            Text(
              'Detail Riwayat Login',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ).animate().fade(duration: 500.ms).slideY(begin: -0.2),

            const SizedBox(height: 12),

            // Animated List of History Items
            Column(
              children: controller.historyList.map((item) {
                final isSelected = selectedItems.contains(item);
                return GestureDetector(
                  onLongPress: () => selectedItems.add(item),
                  child: Card(
                    color: isSelected
                        ? theme.primaryColor.withOpacity(0.05)
                        : Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black12,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: isSelected
                          ? BorderSide(color: theme.primaryColor, width: 2)
                          : BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
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
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.provider} • ${formatDate(item.loginTime)}',
                              style: textTheme.bodySmall,
                            ),
                            if (item.device.isNotEmpty)
                              Text(
                                'Device: ${item.device}',
                                style: textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fade(duration: 300.ms).slideX(begin: 0.2);
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}
