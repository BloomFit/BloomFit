import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SenamExercise {
  final String name;
  final String description;
  final String duration;
  final String difficulty;
  final String trimester;
  final List<String> benefits;
  final String imageUrl;

  SenamExercise({
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.trimester,
    required this.benefits,
    required this.imageUrl,
  });

  factory SenamExercise.fromJson(Map<String, dynamic> json) {
    return SenamExercise(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? 'Mudah',
      trimester: json['trimester'] ?? 'Semua',
      benefits: List<String>.from(json['benefits'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class SenamIbuHamilController extends GetxController {
  var exerciseList = <SenamExercise>[].obs;
  var filteredExercises = <SenamExercise>[].obs;
  var isLoading = true.obs;
  var selectedTrimester = 'Semua'.obs;
  var selectedDifficulty = 'Semua'.obs;

  // Data lokal untuk senam ibu hamil
  final List<Map<String, dynamic>> localExercises = [
    {
      'name': 'Pernapasan Dalam',
      'description': 'Latihan pernapasan untuk relaksasi dan oksigenasi yang baik untuk ibu dan bayi',
      'duration': '5-10 menit',
      'difficulty': 'Mudah',
      'trimester': 'Semua',
      'benefits': ['Mengurangi stres', 'Meningkatkan oksigen', 'Membantu relaksasi'],
      'imageUrl': 'assets/images/breathing.png'
    },
    {
      'name': 'Senam Kegel',
      'description': 'Latihan untuk memperkuat otot dasar panggul',
      'duration': '10-15 menit',
      'difficulty': 'Mudah',
      'trimester': 'Semua',
      'benefits': ['Memperkuat otot panggul', 'Mempersiapkan persalinan', 'Mencegah inkontinensia'],
      'imageUrl': 'assets/images/kegel.png'
    },
    {
      'name': 'Stretching Punggung',
      'description': 'Peregangan lembut untuk mengurangi nyeri punggung',
      'duration': '8-12 menit',
      'difficulty': 'Mudah',
      'trimester': 'Trimester 2-3',
      'benefits': ['Mengurangi nyeri punggung', 'Meningkatkan fleksibilitas', 'Memperbaiki postur'],
      'imageUrl': 'assets/images/back_stretch.png'
    },
    {
      'name': 'Prenatal Yoga',
      'description': 'Gerakan yoga yang aman untuk ibu hamil',
      'duration': '20-30 menit',
      'difficulty': 'Sedang',
      'trimester': 'Trimester 2-3',
      'benefits': ['Meningkatkan fleksibilitas', 'Mengurangi stres', 'Memperbaikan keseimbangan'],
      'imageUrl': 'assets/images/prenatal_yoga.png'
    },
    {
      'name': 'Jalan Kaki Ringan',
      'description': 'Aktivitas kardio ringan yang aman untuk semua trimester',
      'duration': '15-30 menit',
      'difficulty': 'Mudah',
      'trimester': 'Semua',
      'benefits': ['Meningkatkan stamina', 'Menjaga berat badan', 'Memperbaiki sirkulasi'],
      'imageUrl': 'assets/images/walking.png'
    },
    {
      'name': 'Senam Air',
      'description': 'Latihan di air yang lembut untuk sendi',
      'duration': '30-45 menit',
      'difficulty': 'Sedang',
      'trimester': 'Trimester 2-3',
      'benefits': ['Mengurangi beban sendi', 'Meningkatkan kekuatan', 'Efek relaksasi'],
      'imageUrl': 'assets/images/water_exercise.png'
    },
    {
      'name': 'Latihan Bola Pilates',
      'description': 'Menggunakan bola pilates untuk latihan keseimbangan dan kekuatan inti',
      'duration': '15-20 menit',
      'difficulty': 'Sedang',
      'trimester': 'Trimester 1-2',
      'benefits': ['Memperkuat inti', 'Meningkatkan keseimbangan', 'Mempersiapkan persalinan'],
      'imageUrl': 'assets/images/pilates_ball.png'
    },
    {
      'name': 'Peregangan Samping',
      'description': 'Latihan peregangan untuk otot samping dan pinggul',
      'duration': '6-10 menit',
      'difficulty': 'Mudah',
      'trimester': 'Semua',
      'benefits': ['Mengurangi ketegangan otot', 'Meningkatkan mobilitas', 'Mengurangi kram'],
      'imageUrl': 'assets/images/side_stretch.png'
    }
  ];

  @override
  void onInit() {
    loadExercises();
    super.onInit();
  }

  void loadExercises() async {
    try {
      isLoading(true);

      // Simulasi loading dari API atau database
      await Future.delayed(Duration(seconds: 1));

      // Load data lokal
      exerciseList.value = localExercises
          .map((exercise) => SenamExercise.fromJson(exercise))
          .toList();

      filteredExercises.value = exerciseList;

    } catch (e) {
      print('Error loading exercises: $e');
      Get.snackbar('Error', 'Gagal memuat data senam ibu hamil');
    } finally {
      isLoading(false);
    }
  }

  void filterExercises() {
    filteredExercises.value = exerciseList.where((exercise) {
      bool trimesterMatch = selectedTrimester.value == 'Semua' ||
          exercise.trimester.contains(selectedTrimester.value) ||
          exercise.trimester == 'Semua';

      bool difficultyMatch = selectedDifficulty.value == 'Semua' ||
          exercise.difficulty == selectedDifficulty.value;

      return trimesterMatch && difficultyMatch;
    }).toList();
  }

  void setTrimesterFilter(String trimester) {
    selectedTrimester.value = trimester;
    filterExercises();
  }

  void setDifficultyFilter(String difficulty) {
    selectedDifficulty.value = difficulty;
    filterExercises();
  }

  void refreshExercises() {
    loadExercises();
  }

  // Method untuk mendapatkan rekomendasi berdasarkan trimester
  List<SenamExercise> getRecommendedForTrimester(String trimester) {
    return exerciseList.where((exercise) =>
    exercise.trimester.contains(trimester) || exercise.trimester == 'Semua'
    ).take(3).toList();
  }

  // Method untuk mendapatkan exercise berdasarkan tingkat kesulitan
  List<SenamExercise> getExercisesByDifficulty(String difficulty) {
    return exerciseList.where((exercise) =>
    exercise.difficulty == difficulty
    ).toList();
  }
}