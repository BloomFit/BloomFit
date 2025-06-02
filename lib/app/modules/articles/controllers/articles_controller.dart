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

    // Data sampel artikel seputar senam ibu hamil
    final sampleArticles = [
      Article(
        id: 1,
        title: 'Manfaat Senam Ibu Hamil untuk Persalinan yang Lancar',
        author: 'Dr. Sari Andini',
        category: 'Kesehatan',
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=300&h=200',
        content:
        'Senam ibu hamil dapat membantu memperkuat otot panggul dan meningkatkan stamina menjelang persalinan. Latihan ini juga membantu mengurangi rasa sakit punggung dan menjaga kestabilan emosional.',
        date: '3 Mei 2025',
        readTime: 6,
      ),
      Article(
        id: 2,
        title: 'Jenis-Jenis Senam yang Aman untuk Ibu Hamil Trimester Kedua',
        author: 'Bid. Lestari',
        category: 'Olahraga',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=300&h=200',
        content:
        'Beberapa jenis senam seperti yoga prenatal dan peregangan ringan sangat disarankan bagi ibu hamil di trimester kedua. Artikel ini membahas jenis latihan yang aman dan bermanfaat.',
        date: '1 Mei 2025',
        readTime: 7,
      ),
      Article(
        id: 3,
        title: 'Panduan Senam Hamil di Rumah untuk Pemula',
        author: 'Dr. Rina Pramudita',
        category: 'Panduan',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1681825575328-ae9c79f0d259?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c2VuYW0lMjBpYnUlMjBoYW1pbHxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Tidak sempat pergi ke kelas senam? Senam hamil juga bisa dilakukan di rumah dengan aman. Ikuti panduan gerakan sederhana ini yang cocok untuk pemula.',
        date: '29 April 2025',
        readTime: 5,
      ),
      Article(
        id: 4,
        title: 'Senam Hamil: Kapan Sebaiknya Dimulai?',
        author: 'Dr. Andika Hadi',
        category: 'Kesehatan',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=300&h=200',
        content:
        'Banyak ibu hamil bertanya-tanya kapan waktu terbaik untuk mulai senam. Artikel ini menjelaskan trimester mana yang paling tepat dan aman untuk memulai aktivitas fisik ini.',
        date: '27 April 2025',
        readTime: 6,
      ),
      Article(
        id: 5,
        title: 'Senam Hamil dan Kesehatan Mental Ibu',
        author: 'Psikolog Maya Yuliani',
        category: 'Mental Health',
        imageUrl: 'https://images.unsplash.com/photo-1612197315436-e9ecf682b264?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8eW9nYSUyMGlidSUyMGhhbWlsfGVufDB8fDB8fHww',
        content:
        'Selain bermanfaat secara fisik, senam ibu hamil juga berdampak positif pada kesehatan mental. Ini membantu mengurangi stres, meningkatkan kepercayaan diri, dan memperbaiki kualitas tidur.',
        date: '25 April 2025',
        readTime: 8,
      ),
      Article(
        id: 6,
        title: 'Gerakan Senam Ibu Hamil yang Perlu Dihindari',
        author: 'Dr. Hendra Utama',
        category: 'Tips Kehamilan',
        imageUrl: 'https://images.unsplash.com/photo-1725393197924-e1dff51c29f1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjN8fHNlbmFtJTIwaWJ1JTIwaGFtaWx8ZW58MHx8MHx8fDA%3D',
        content:
        'Tidak semua gerakan senam aman untuk ibu hamil. Ketahui beberapa gerakan yang harus dihindari dan bagaimana memodifikasi latihan agar tetap nyaman dan aman.',
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
