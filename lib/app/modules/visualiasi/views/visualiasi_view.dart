import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile_app/app/modules/visualiasi/controllers/visualiasi_controller.dart';

class VisualiasiView extends GetView<VisualiasiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Breeds Pie Chart')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final breeds = controller.breedList.take(10).toList(); // ambil 10 data

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCircularChart(
            title: ChartTitle(text: 'Jenis jenis Anjing'),
            legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: <PieSeries>[
              PieSeries(
                dataSource: breeds,
                xValueMapper: (breed, _) => breed.name,
                yValueMapper: (breed, _) => breed.name.length, // nilai: panjang nama
                dataLabelMapper: (breed, _) => breed.name,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        );
      }),
    );
  }
}
