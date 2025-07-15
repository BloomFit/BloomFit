import 'package:get/get.dart';

import '../controllers/selection_page_controller.dart';

class SelectionPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectionPageController>(
      () => SelectionPageController(),
    );
  }
}
