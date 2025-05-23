import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/visualiasi_controller.dart';

class VisualiasiView extends GetView<VisualiasiController> {
  const VisualiasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VisualiasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VisualiasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
