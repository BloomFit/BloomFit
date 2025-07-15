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

  final Map<String, String> poseVideos = {
    "Latihan_Pernapasan": "assets/videos/latihan_pernapasan.mp4",
    "Peregangan_Leher_dan_Bahu": "assets/videos/peregangan_leher_bahu.mp4",
    "Senam_Kegel": "assets/videos/senam_kegel.mp4",
    "Butterfly_Stretch": "assets/videos/butterfly_stretch.mp4",
    "Cat_Cow_Stretch": "assets/videos/cat_cow_stretch.mp4",
    "Pelvic_Tilt": "assets/videos/pelvic_tilt.mp4",
    "Wall_Push_Up": "assets/videos/wall_push_up.mp4",
    "Berjalan_jongkok": "assets/videos/berjalan_jongkok.mp4",
    "Wall_Squat_Ringan": "assets/videos/wall_squat_ringan.mp4",
  };

  void selectTrimester(String? value) {
    selectedTrimester.value = value;
    selectedPose.value = null;
  }

  void selectPose(String? value) {
    selectedPose.value = value;
  }
}
