import 'package:get/get.dart';

class SelectionPageController extends GetxController {
  final selectedTrimester = RxnString();
  final selectedPose = RxnString();

  final Map<String, List<String>> trimesterPoses = {
    "Trimester 1": [
      "Latihan_Pernapasan",
      "Peregangan_Leher_dan_Bahu",
      "Senam_Kegel",
    ],
    "Trimester 2": [
      "Butterfly_Stretch",
      "Cat_Cow_Stretch",
      "Pelvic_Tilt",
    ],
    "Trimester 3": [
      "Wall_Push_Up",
      "Berjalan_jongkok",
      "Wall_Squat_Ringan",
    ],
  };

  void selectTrimester(String? value) {
    selectedTrimester.value = value;
    selectedPose.value = null;
  }

  void selectPose(String? value) {
    selectedPose.value = value;
  }
}
