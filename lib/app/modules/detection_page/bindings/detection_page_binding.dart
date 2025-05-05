import 'package:get/get.dart';

import '../controllers/detection_page_controller.dart';

class DetectionPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetectionPageController>(
      () => DetectionPageController(),
    );
  }
}
