import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class DetectionPageController extends GetxController {
  late Interpreter interpreter;
  List<String> labels = [];

  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  var isCameraInitialized = false.obs;

  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  var predictedLabel = 'unknown'.obs;
  bool isDetecting = false;

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  @override
  void onClose() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    poseDetector.close();
    interpreter.close();
    super.onClose();
  }

  Future<void> loadModel() async {
    try {
      debugPrint('📦 Checking model existence...');
      bool modelExists = await rootBundle
          .load('assets/models/pose_cnn.tflite')
          .then((value) => true)
          .catchError((_) => false);

      debugPrint("📦 Model found: $modelExists");

      if (!modelExists) {
        debugPrint("❌ Model file not found in assets.");
        return;
      }

      interpreter = await Interpreter.fromAsset('assets/models/pose_cnn.tflite');
      debugPrint('✅ Interpreter created');

      final labelData = await rootBundle.loadString('assets/labels/label.txt');
      labels = labelData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      debugPrint('📄 Labels loaded: ${labels.length}');
    } catch (e) {
      debugPrint("❌ Error loading model: $e");
    }
  }

  Future<void> startCamera() async {
    try {
      cameras = await availableCameras();
      await initializeCamera(selectedCameraIndex);
    } catch (e) {
      debugPrint("❌ Failed to start camera: $e");
    }
  }

  Future<void> stopCamera() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    predictedLabel.value = 'unknown';
  }

  Future<void> switchCamera() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await stopCamera();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> initializeCamera(int index) async {
    try {
      final camera = cameras[index];
      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await cameraController!.initialize();
      await cameraController!.startImageStream(processCameraImage);
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint("❌ Camera initialization failed: $e");
    }
  }

  void processCameraImage(CameraImage image) async {
    if (isDetecting || cameraController == null) return;
    isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final rotation = InputImageRotationValue.fromRawValue(
        cameraController!.description.sensorOrientation,
      ) ??
          InputImageRotation.rotation0deg;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) {
        debugPrint("❌ Unsupported image format: ${image.format.raw}");
        isDetecting = false;
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        final List<double> keypoints = [];

        for (var lmType in PoseLandmarkType.values) {
          final lm = poses.first.landmarks[lmType];
          keypoints.add(lm?.x ?? 0.0);
        }

        for (var lmType in PoseLandmarkType.values) {
          final lm = poses.first.landmarks[lmType];
          keypoints.add(lm?.y ?? 0.0);
        }

        if (keypoints.length == 66) {
          final reshapedInput = List.generate(
            1,
                (_) => List.generate(
              11,
                  (i) => List.generate(
                6,
                    (j) => [keypoints[i * 6 + j]],
              ),
            ),
          );

          final outputTensor = interpreter.getOutputTensor(0);
          final output = List.generate(
            1,
                (_) => List.filled(outputTensor.shape[1], 0.0),
          );

          interpreter.run(reshapedInput, output);

          final predictions = output[0];
          debugPrint("🧠 Predictions: $predictions");

          final maxIndex =
          predictions.indexWhere((e) => e == predictions.reduce(max));

          if (maxIndex >= 0 && maxIndex < labels.length) {
            predictedLabel.value = labels[maxIndex];
            debugPrint("✅ Predicted: ${predictedLabel.value}");
          } else {
            debugPrint("⚠️ Prediction out of bounds or not confident");
          }
        } else {
          debugPrint("❌ Keypoints tidak lengkap: ${keypoints.length}");
        }
      }
    } catch (e) {
      debugPrint("❌ Error during pose detection: $e");
    } finally {
      isDetecting = false;
    }
  }
}
