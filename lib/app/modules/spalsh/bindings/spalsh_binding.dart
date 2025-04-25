import 'package:get/get.dart';

import '../controllers/spalsh_controller.dart';

class SpalshBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SpalshController>(
    //   () => SpalshController(),
    // );
    Get.put(SpalshController());
  }
}
