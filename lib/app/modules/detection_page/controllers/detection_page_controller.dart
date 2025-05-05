import 'package:get/get.dart';

class DetectionPageController extends GetxController {
  //TODO: Implement DetectionPageController
  var isLoading = false.obs;
  var selectedDetectionMode = 'QR Code'.obs;
  var recentDetections = [].obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  void loadInitialData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi delay loading

    // Tambahkan data deteksi awal (dalam aplikasi nyata, ini mungkin dari database)
    recentDetections.value = [
      {
        'type': 'QR Code',
        'content': 'https://example.com',
        'time': '2 minutes ago',
        'icon': 'qr_code_scanner',
      },
      {
        'type': 'Text',
        'content': 'Meeting at 3 PM',
        'time': '1 hour ago',
        'icon': 'text_fields',
      },
      {
        'type': 'Face',
        'content': 'John Doe',
        'time': 'Yesterday',
        'icon': 'face',
      },
    ];

    isLoading.value = false;
  }

  void changeDetectionMode(String mode) {
    selectedDetectionMode.value = mode;
  }

  void startDetection() {
    // Implementasi logika deteksi sesuai dengan mode yang dipilih
    switch (selectedDetectionMode.value) {
      case 'QR Code':
      // Mulai scanning QR code
        break;
      case 'Text':
      // Mulai deteksi teks
        break;
      case 'Face':
      // Mulai deteksi wajah
        break;
      case 'Image':
      // Mulai analisis gambar
        break;
    }
  }

  void saveDetectionResult(Map<String, dynamic> result) {
    // Menambahkan hasil deteksi ke dalam daftar riwayat
    recentDetections.insert(0, result);

    // Batasi jumlah riwayat yang ditampilkan
    if (recentDetections.length > 10) {
      recentDetections.removeLast();
    }
  }

  void clearAllDetections() {
    recentDetections.clear();
  }
}
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   void increment() => count.value++;
// }
