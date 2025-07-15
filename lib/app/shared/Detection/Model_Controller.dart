// lib/services/pose_model_service.dart
import 'dart:typed_data';
import 'package:mobile_app/app/shared/Detection/Pose_Labels.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class PoseModelService {
  late final Interpreter _interpreter;
  late final int _inputSize;                // mis. 64, 128, 192, dll
  late final List<int> _inputShape;         // [1, H, W, 3]
  late final int _numClasses;               // = poseLabels.length (10)

  /// Inisialisasi model sekali saja (mis. di initState).
  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/model_pose_cnn.tflite',
    );
    _inputShape = _interpreter.getInputTensor(0).shape; // [1, H, W, 3]
    _inputSize  = _inputShape[1];                       // H == W
    _numClasses = _interpreter.getOutputTensor(0).shape.last;
    assert(_numClasses == poseLabels.length,
    'Jumlah label (${poseLabels.length}) ≠ output model ($_numClasses)');
    // ignore: avoid_print
    print('✅ Model loaded ($_inputSize×$_inputSize) | $_numClasses classes');
  }

  /// Prediksi pose dari satu frame (objek `img.Image`).
  ///
  /// return Map {label, confidence}.
  Map<String, dynamic> predict(img.Image frame) {
    // Dapatkan H dan W langsung dari shape, jangan berasumsi persegi
    final int inputHeight = _inputShape[1];
    final int inputWidth = _inputShape[2];

    // --- 1. Resize frame ke ukuran input model ---
    final resized = img.copyResize(frame, width: inputWidth, height: inputHeight);

    // --- 2. Konversi ke Float32List [1, H, W, 3] dan normalisasi 0‑1 ---
    // Membuat list flat, lebih efisien
    final input = Float32List(1 * inputHeight * inputWidth * 3);
    int bufferIndex = 0;
    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        final pix = resized.getPixel(x, y);
        input[bufferIndex++] = pix.r / 255.0;
        input[bufferIndex++] = pix.g / 255.0;
        input[bufferIndex++] = pix.b / 255.0;
      }
    }

    // --- 3. Siapkan output tensor ---
    final output = List.filled(_numClasses, 0.0).reshape([1, _numClasses]);

    // --- 4. Inferensi ---
    // Reshape input dari flat list ke [1, H, W, 3] sebelum dijalankan
    _interpreter.run(input.reshape(_inputShape), output);
    final probs = output[0] as List<double>;

    // --- 5. Ambil prediksi tertinggi (kode Anda sudah benar) ---
    int maxIdx = 0;
    double maxConf = probs[0];
    for (var i = 1; i < probs.length; i++) {
      if (probs[i] > maxConf) {
        maxConf = probs[i];
        maxIdx = i;
      }
    }

    return {
      'label': poseLabels[maxIdx],
      'confidence': maxConf,
      'allProbs': probs,
    };
  }
  /// True jika pose yang terdeteksi sama dengan `targetPose`
  /// dan confidence ≥ `threshold` (default 0.6 = 60 %)
  bool isPoseMatch(
      img.Image frame,
      String targetPose, {
        double threshold = 0.6,
      }) {
    final pred = predict(frame);
    return pred['label'] == targetPose && pred['confidence'] >= threshold;
  }

  void close() {
    _interpreter.close();
  }
}
