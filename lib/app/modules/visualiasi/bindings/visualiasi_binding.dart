import 'package:get/get.dart';

import '../controllers/visualiasi_controller.dart';

class VisualiasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SenamIbuHamilController>(
      () => SenamIbuHamilController(),
    );
  }
}
