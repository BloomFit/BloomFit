import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/modules/visualiasi/controllers/visualiasi_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SenamIbuHamilView extends GetView<SenamIbuHamilController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualisasi Senam Ibu Hamil'),
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                ),
                SizedBox(height: 16),
                Text('Memuat data senam ibu hamil...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter Senam',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedTrimester.value,
                                decoration: const InputDecoration(
                                  labelText: 'Trimester',
                                  border: OutlineInputBorder(),
                                ),
                                items: ['Semua', 'Trimester 1', 'Trimester 2', 'Trimester 3']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.setTrimesterFilter(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedDifficulty.value,
                                decoration: const InputDecoration(
                                  labelText: 'Tingkat Kesulitan',
                                  border: OutlineInputBorder(),
                                ),
                                items: ['Semua', 'Mudah', 'Sedang', 'Sulit']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.setDifficultyFilter(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Pie Chart - Distribusi Tingkat Kesulitan
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Distribusi Tingkat Kesulitan Senam',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: SfCircularChart(
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                            series: <PieSeries>[
                              PieSeries<MapEntry<String, int>, String>(
                                dataSource: _getDifficultyDistribution(),
                                xValueMapper: (MapEntry<String, int> data, _) => data.key,
                                yValueMapper: (MapEntry<String, int> data, _) => data.value,
                                dataLabelMapper: (MapEntry<String, int> data, _) =>
                                '${data.key}\n${data.value} senam',
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                ),
                                pointColorMapper: (MapEntry<String, int> data, _) =>
                                    _getColorForDifficulty(data.key),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Bar Chart - Durasi Senam
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Durasi Senam (dalam menit)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              labelRotation: -45,
                              majorGridLines: const MajorGridLines(width: 0),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Durasi (menit)'),
                              majorGridLines: const MajorGridLines(width: 0.5),
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<SenamExercise, String>(
                                dataSource: controller.filteredExercises,
                                xValueMapper: (SenamExercise exercise, _) =>
                                exercise.name.length > 15
                                    ? '${exercise.name.substring(0, 12)}...'
                                    : exercise.name,
                                yValueMapper: (SenamExercise exercise, _) =>
                                    _parseDuration(exercise.duration),
                                color: Colors.pink.shade300,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Doughnut Chart - Distribusi Berdasarkan Trimester
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Distribusi Senam Berdasarkan Trimester',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: SfCircularChart(
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.right,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                            series: <DoughnutSeries>[
                              DoughnutSeries<MapEntry<String, int>, String>(
                                dataSource: _getTrimesterDistribution(),
                                xValueMapper: (MapEntry<String, int> data, _) => data.key,
                                yValueMapper: (MapEntry<String, int> data, _) => data.value,
                                dataLabelMapper: (MapEntry<String, int> data, _) =>
                                '${data.value}',
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.inside,
                                ),
                                innerRadius: '60%',
                                pointColorMapper: (MapEntry<String, int> data, _) =>
                                    _getColorForTrimester(data.key),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Summary Card
                Card(
                  color: Colors.pink.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Data',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              'Total Senam',
                              controller.exerciseList.length.toString(),
                              Icons.fitness_center,
                              Colors.pink,
                            ),
                            _buildSummaryItem(
                              'Sedang Ditampilkan',
                              controller.filteredExercises.length.toString(),
                              Icons.visibility,
                              Colors.blue,
                            ),
                            _buildSummaryItem(
                              'Senam Mudah',
                              controller.getExercisesByDifficulty('Mudah').length.toString(),
                              Icons.thumb_up,
                              Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Helper method untuk mendapatkan distribusi tingkat kesulitan
  List<MapEntry<String, int>> _getDifficultyDistribution() {
    Map<String, int> distribution = {};
    for (var exercise in controller.exerciseList) {
      distribution[exercise.difficulty] = (distribution[exercise.difficulty] ?? 0) + 1;
    }
    return distribution.entries.toList();
  }

  // Helper method untuk mendapatkan distribusi trimester
  List<MapEntry<String, int>> _getTrimesterDistribution() {
    Map<String, int> distribution = {};
    for (var exercise in controller.exerciseList) {
      String trimester = exercise.trimester == 'Semua' ? 'Semua Trimester' : exercise.trimester;
      distribution[trimester] = (distribution[trimester] ?? 0) + 1;
    }
    return distribution.entries.toList();
  }

  // Helper method untuk parsing durasi
  double _parseDuration(String duration) {
    // Ekstrak angka dari string durasi (misal: "5-10 menit" -> 7.5)
    final regex = RegExp(r'(\d+)(?:-(\d+))?');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final min = int.parse(match.group(1)!);
      final max = match.group(2) != null ? int.parse(match.group(2)!) : min;
      return (min + max) / 2.0;
    }
    return 10.0; // default value
  }

  // Helper method untuk warna tingkat kesulitan
  Color _getColorForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'Mudah':
        return Colors.green;
      case 'Sedang':
        return Colors.orange;
      case 'Sulit':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method untuk warna trimester
  Color _getColorForTrimester(String trimester) {
    switch (trimester) {
      case 'Semua Trimester':
        return Colors.purple;
      case 'Trimester 1':
        return Colors.blue;
      case 'Trimester 2':
        return Colors.green;
      case 'Trimester 3':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Helper widget untuk summary item
  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}