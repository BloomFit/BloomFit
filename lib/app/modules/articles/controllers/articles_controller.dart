import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// URL base untuk API artikel
const String _apiBaseUrl = 'https://backend-bloomfit.vercel.app/api/articles';

class ArticlesController extends GetxController {
  // --- State Observables ---
  final RxList<Article> articles = <Article>[].obs;
  final RxList<Article> filteredArticles = <Article>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs; // Untuk menampilkan pesan error
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // --- Logika Utama ---

  /// **[FIXED]** Mengambil data artikel dari API dengan struktur yang benar.
  Future<void> fetchArticles() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(Uri.parse(_apiBaseUrl));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // **[FIXED]** Validasi struktur API yang baru: List -> Map -> List
        // 1. Periksa apakah respons terluar adalah sebuah List dan tidak kosong.
        if (decodedData is List && decodedData.isNotEmpty) {
          // 2. Ambil elemen pertama dari List, yang seharusnya adalah Map.
          final Map<String, dynamic> dataMap = decodedData[0];

          // 3. Periksa apakah Map tersebut memiliki key 'data' dan nilainya adalah List.
          if (dataMap.containsKey('data') && dataMap['data'] is List) {
            final List<dynamic> articleListJson = dataMap['data'];

            final fetchedArticles = articleListJson
                .map((jsonItem) => Article.fromJson(jsonItem))
                .toList();

            articles.value = fetchedArticles;
            filteredArticles.value = fetchedArticles;

            final uniqueCategories =
            fetchedArticles.map((e) => e.category).toSet().toList();
            categories.value = ['All', ...uniqueCategories];
          } else {
            errorMessage.value = 'Format data di dalam API tidak valid.';
          }
        } else {
          errorMessage.value = 'Format respons dari API tidak valid (bukan List).';
        }
      } else {
        errorMessage.value = 'Gagal memuat data. Status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      printError(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle status favorit artikel.
  void toggleFavorite(Article articleToToggle) {
    final index = articles.indexWhere((article) => article.id == articleToToggle.id);

    if (index != -1) {
      articles[index].isFavorite = !articles[index].isFavorite;
      filteredArticles.refresh();
    }
  }

  /// Memilih kategori dan memfilter artikel berdasarkan pilihan.
  void selectCategory(String category) {
    selectedCategory.value = category;
    filterArticles();
  }

  /// Mengatur query pencarian dan memfilter artikel.
  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterArticles();
  }

  /// Memfilter artikel berdasarkan kategori dan query pencarian yang aktif.
  void filterArticles() {
    List<Article> tempFilteredList;

    if (selectedCategory.value == 'All') {
      tempFilteredList = List<Article>.from(articles);
    } else {
      tempFilteredList = articles
          .where((article) => article.category == selectedCategory.value)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      tempFilteredList = tempFilteredList
          .where((article) =>
      article.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          article.content.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    filteredArticles.value = tempFilteredList;
  }
}

/// Model untuk data Artikel.
class Article {
  final String id;
  final String title;
  final String author;
  final String category;
  final String imageUrl;
  final String content;
  final String date;
  final int readTime;
  bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.imageUrl,
    required this.content,
    required this.date,
    required this.readTime,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {

    final parsedReadTime = int.tryParse(json['readTime'].toString()) ?? 0;

    return Article(
      id: json['id'] as String? ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      author: json['author'] ?? 'Tanpa Penulis',
      category: json['category'] as String? ?? 'Lainnya',
      imageUrl: json['imageUrl'] ?? 'https://placehold.co/600x400/EEE/31343C?text=No+Image',
      content: json['content'] ?? 'Konten tidak tersedia.',
      date: json['created_at'] ?? '',
      readTime: parsedReadTime,
      isFavorite: false,
    );
  }
}
