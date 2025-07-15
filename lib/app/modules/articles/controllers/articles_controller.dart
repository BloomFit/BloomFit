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
      Article(
        id: 7,
        title: 'Senam Air untuk Ibu Hamil: Manfaat dan Cara Melakukannya',
        author: 'Dr. Kartika Dewi',
        category: 'Olahraga',
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3dpbW1pbmclMjBwcmVnbmFudHxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Senam air atau aqua prenatal menjadi pilihan favorit banyak ibu hamil karena memberikan dukungan alami pada perut dan mengurangi tekanan pada sendi.',
        date: '21 April 2025',
        readTime: 7,
      ),
      Article(
        id: 8,
        title: 'Breathing Exercise: Teknik Pernapasan dalam Senam Hamil',
        author: 'Bid. Anastasia',
        category: 'Teknik',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YnJlYXRoaW5nJTIwZXhlcmNpc2V8ZW58MHx8MHx8fDA%3D',
        content:
        'Teknik pernapasan yang benar sangat penting dalam senam ibu hamil. Pelajari berbagai teknik breathing yang dapat membantu relaksasi dan persiapan persalinan.',
        date: '19 April 2025',
        readTime: 6,
      ),
      Article(
        id: 9,
        title: 'Senam Kegel: Memperkuat Otot Dasar Panggul',
        author: 'Dr. Fitri Handayani',
        category: 'Kesehatan',
        imageUrl: 'https://images.unsplash.com/photo-1506629905607-d5b2d70fab8a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8a2VnZWwlMjBleGVyY2lzZXxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Senam Kegel merupakan latihan sederhana namun sangat efektif untuk memperkuat otot dasar panggul yang penting untuk proses persalinan dan pemulihan pasca melahirkan.',
        date: '17 April 2025',
        readTime: 5,
      ),
      Article(
        id: 10,
        title: 'Yoga Prenatal: Menyelaraskan Tubuh dan Pikiran',
        author: 'Instruktur Devi Maharani',
        category: 'Yoga',
        imageUrl: 'https://images.unsplash.com/photo-1588286840104-8957b019727f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHByZW5hdGFsJTIweW9nYXxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Yoga prenatal menggabungkan gerakan lembut, pernapasan, dan meditasi untuk menciptakan keseimbangan fisik dan mental selama kehamilan.',
        date: '15 April 2025',
        readTime: 8,
      ),
      Article(
        id: 11,
        title: 'Senam Hamil Trimester Pertama: Apa yang Boleh dan Tidak Boleh',
        author: 'Dr. Wahyu Pratama',
        category: 'Panduan',
        imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGVhcmx5JTIwcHJlZ25hbmN5fGVufDB8fDB8fHww',
        content:
        'Trimester pertama adalah periode sensitif dalam kehamilan. Pelajari aktivitas fisik yang aman dan yang harus dihindari pada masa awal kehamilan.',
        date: '13 April 2025',
        readTime: 6,
      ),
      Article(
        id: 12,
        title: 'Senam Hamil untuk Mengatasi Morning Sickness',
        author: 'Bid. Indira Sari',
        category: 'Tips Kehamilan',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bW9ybmluZyUyMHNpY2tuZXNzfGVufDB8fDB8fHww',
        content:
        'Beberapa gerakan senam ringan dapat membantu mengurangi gejala morning sickness dan meningkatkan energi di pagi hari.',
        date: '11 April 2025',
        readTime: 5,
      ),
      Article(
        id: 13,
        title: 'Peregangan untuk Mengurangi Sakit Punggung saat Hamil',
        author: 'Fisioterapis Rudi Setiawan',
        category: 'Terapi',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJhY2slMjBwYWlufGVufDB8fDB8fHww',
        content:
        'Sakit punggung adalah keluhan umum ibu hamil. Gerakan peregangan yang tepat dapat membantu meredakan nyeri dan mencegah ketegangan otot.',
        date: '9 April 2025',
        readTime: 7,
      ),
      Article(
        id: 14,
        title: 'Senam Hamil Trimester Ketiga: Persiapan Menuju Persalinan',
        author: 'Dr. Amelia Putri',
        category: 'Persiapan Persalinan',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGxhdGUlMjBwcmVnbmFuY3l8ZW58MHx8MHx8fDA%3D',
        content:
        'Trimester ketiga adalah waktu persiapan intensif menuju persalinan. Senam pada periode ini fokus pada penguatan dan persiapan mental.',
        date: '7 April 2025',
        readTime: 8,
      ),
      Article(
        id: 15,
        title: 'Senam Hamil dengan Bola Pilates: Teknik dan Manfaatnya',
        author: 'Instruktur Pilates Sarah',
        category: 'Peralatan',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cGlsYXRlcyUyMGJhbGx8ZW58MHx8MHx8fDA%3D',
        content:
        'Bola pilates atau birthing ball adalah alat bantu yang sangat efektif dalam senam ibu hamil. Pelajari cara penggunaan yang benar dan manfaatnya.',
        date: '5 April 2025',
        readTime: 6,
      ),
      Article(
        id: 16,
        title: 'Senam untuk Ibu Hamil Kembar: Panduan Khusus',
        author: 'Dr. Ratna Sari Dewi',
        category: 'Kehamilan Khusus',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHR3aW4lMjBwcmVnbmFuY3l8ZW58MHx8MHx8fDA%3D',
        content:
        'Kehamilan kembar memerlukan perhatian khusus dalam aktivitas fisik. Panduan senam yang disesuaikan dengan kondisi kehamilan multipel.',
        date: '3 April 2025',
        readTime: 7,
      ),
      Article(
        id: 17,
        title: 'Meditasi dan Relaksasi dalam Senam Ibu Hamil',
        author: 'Instruktur Mindfulness Lina',
        category: 'Mental Health',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bWVkaXRhdGlvbnxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Kombinasi antara gerakan fisik dengan teknik meditasi dan relaksasi dapat memberikan manfaat holistik untuk ibu dan bayi.',
        date: '1 April 2025',
        readTime: 6,
      ),
      Article(
        id: 18,
        title: 'Senam Hamil untuk Ibu Bekerja: Tips Efisien di Kantor',
        author: 'Dr. Melissa Anggraini',
        category: 'Lifestyle',
        imageUrl: 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHdvcmtpbmclMjBwcmVnbmFudHxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Ibu hamil yang bekerja dapat melakukan gerakan senam ringan di kantor untuk menjaga kesehatan dan mengurangi kelelahan.',
        date: '30 Maret 2025',
        readTime: 5,
      ),
      Article(
        id: 19,
        title: 'Senam Pasca Melahirkan: Memulihkan Kekuatan Tubuh',
        author: 'Fisioterapis Wanda',
        category: 'Postpartum',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9zdHBhcnR1bXxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Setelah melahirkan, tubuh membutuhkan waktu untuk pulih. Senam postpartum yang tepat dapat mempercepat proses pemulihan dengan aman.',
        date: '28 Maret 2025',
        readTime: 7,
      ),
      Article(
        id: 20,
        title: 'Nutrisi dan Hidrasi saat Senam Hamil',
        author: 'Ahli Gizi Dr. Putri Lestari',
        category: 'Nutrisi',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGh5ZHJhdGlvbnxlbnwwfHwwfHx8MA%3D%3D',
        content:
        'Memahami kebutuhan nutrisi dan hidrasi yang tepat sebelum, selama, dan setelah senam adalah kunci untuk menjaga energi dan kesehatan ibu hamil.',
        date: '26 Maret 2025',
        readTime: 6,
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
