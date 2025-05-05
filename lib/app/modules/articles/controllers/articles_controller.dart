import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesController extends GetxController {
  // Observable state
  final RxList<Article> articles = <Article>[].obs;
  final RxList<Article> filteredArticles = <Article>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  // TextEditingController untuk search field
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

  // Fetch artikel dari API/database (simulasi)
  void fetchArticles() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulasi network request

    // Data sampel
    final sampleArticles = [
      Article(
        id: 1,
        title: 'Flutter GetX: Manajemen State yang Powerfull',
        author: 'Amanda Putri',
        category: 'Flutter',
        imageUrl: 'https://picsum.photos/id/237/200/300',
        content: 'GetX adalah solusi ringan dan kuat untuk Flutter. Ini menggabungkan manajemen dependensi, manajemen rute, dan manajemen status tanpa konteks. GetX memiliki tiga prinsip dasar: Performa, Produktivitas, dan Organisasi. GetX tidak menggunakan Streams atau ChangeNotifier.',
        date: '3 Mei 2025',
        readTime: 5,
      ),
      Article(
        id: 2,
        title: 'Membangun UI Responsif dengan Flutter',
        author: 'Budi Santoso',
        category: 'UI/UX',
        imageUrl: 'https://picsum.photos/id/1005/200/300',
        content: 'Flutter memungkinkan Anda membuat aplikasi yang responsif dengan sedikit kode. Dengan widget yang fleksibel dan dukungan untuk berbagai ukuran layar, Flutter adalah pilihan terbaik untuk pengembangan multi-platform.',
        date: '1 Mei 2025',
        readTime: 7,
      ),
      Article(
        id: 3,
        title: 'Arsitektur Mobile yang Skalabel',
        author: 'Cindy Wijaya',
        category: 'Architecture',
        imageUrl: 'https://picsum.photos/id/1011/200/300',
        content: 'Arsitektur yang baik adalah kunci untuk membangun aplikasi yang dapat dipelihara dan diskalakan. Artikel ini membahas pola-pola arsitektur populer seperti MVVM, MVC, dan Clean Architecture untuk pengembangan Flutter.',
        date: '29 April 2025',
        readTime: 10,
      ),
      Article(
        id: 4,
        title: 'Firebase dan Flutter: Kombinasi Sempurna',
        author: 'Deni Kurniawan',
        category: 'Backend',
        imageUrl: 'https://picsum.photos/id/1015/200/300',
        content: 'Firebase menyediakan infrastruktur backend yang kuat untuk aplikasi Flutter Anda. Dari autentikasi hingga database realtime, Firebase memudahkan pengembang untuk fokus pada pengalaman pengguna daripada backend.',
        date: '27 April 2025',
        readTime: 6,
      ),
      Article(
        id: 5,
        title: 'Tips Optimasi Performa Flutter',
        author: 'Eka Pratama',
        category: 'Flutter',
        imageUrl: 'https://picsum.photos/id/1019/200/300',
        content: 'Performa aplikasi adalah aspek penting dari pengalaman pengguna. Artikel ini memberikan tips untuk mengoptimalkan performa aplikasi Flutter Anda, termasuk menghindari rebuild yang tidak perlu dan menggunakan const constructors.',
        date: '25 April 2025',
        readTime: 8,
      ),
      Article(
        id: 6,
        title: 'Animasi Halus dengan Flutter',
        author: 'Fina Anggraini',
        category: 'UI/UX',
        imageUrl: 'https://picsum.photos/id/1025/200/300',
        content: 'Animasi dapat meningkatkan pengalaman pengguna secara signifikan. Flutter menyediakan API animasi yang kuat dan mudah digunakan untuk membuat transisi halus dan interaksi yang menarik.',
        date: '23 April 2025',
        readTime: 5,
      ),
    ];

    articles.value = sampleArticles;
    filteredArticles.value = sampleArticles;

    // Ekstrak kategori unik
    final uniqueCategories = sampleArticles.map((e) => e.category).toSet().toList();
    categories.value = ['All', ...uniqueCategories];

    isLoading.value = false;
  }

  // Toggle status favorit artikel
  void toggleFavorite(int id) {
    final index = articles.indexWhere((article) => article.id == id);
    if (index != -1) {
      final article = articles[index];
      articles[index] = Article(
        id: article.id,
        title: article.title,
        author: article.author,
        category: article.category,
        imageUrl: article.imageUrl,
        content: article.content,
        date: article.date,
        readTime: article.readTime,
        isFavorite: !article.isFavorite,
      );

      filterArticles();
    }
  }

  // Select kategori dan filter artikel
  void selectCategory(String category) {
    selectedCategory.value = category;
    filterArticles();
  }

  // Set query pencarian dan filter artikel
  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterArticles();
  }

  // Filter artikel berdasarkan kategori dan query pencarian
  void filterArticles() {
    if (selectedCategory.value == 'All' && searchQuery.isEmpty) {
      filteredArticles.value = articles;
      return;
    }

    filteredArticles.value = articles.where((article) {
      final matchesCategory = selectedCategory.value == 'All' || article.category == selectedCategory.value;
      final matchesSearch = searchQuery.isEmpty ||
          article.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          article.content.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}

// models/article.dart
class Article {
  final int id;
  final String title;
  final String author;
  final String category;
  final String imageUrl;
  final String content;
  final String date;
  final int readTime;
  final bool isFavorite;

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
}