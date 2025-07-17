import 'package:get/get.dart';
import 'package:mobile_app/app/modules/detection_page/controllers/detection_page_controller.dart';

class HistoryDeteksiController extends GetxController {
  final DetectionPageController detectionController = Get.find();

  List<String> get history => detectionController.detectionHistory;

  void clearHistory() {
    detectionController.detectionHistory.clear();
    detectionController.saveHistoryToPrefs();
  }
}
