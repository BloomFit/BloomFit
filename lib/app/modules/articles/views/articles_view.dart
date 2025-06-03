import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/constants/colors.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import '../controllers/articles_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesView extends GetView<ArticlesController> {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 180,
                floating: true,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.pinkAccent,
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.offAllNamed(Routes.HOME);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColorsDark.aksen,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0xFF575757),
                                              offset: Offset(-1, -1),
                                              blurRadius: 2),
                                          BoxShadow(
                                              color: Color(0xFF000000),
                                              offset: Offset(1, 1),
                                              blurRadius: 2),
                                        ],
                                      ),
                                      child: Icon(Icons.arrow_back,
                                          color: AppColorsDark.teksOnPrimary, size: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Center(
                                      child: const Text(
                                        'BloomFit',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 40),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.setSearchQuery,
                                  decoration: InputDecoration(
                                    hintText: 'Cari artikel...',
                                    prefixIcon: const Icon(Icons.search,
                                        color: Colors.pinkAccent),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: CategoryHeaderDelegate(
                  categories: controller.categories,
                  selectedCategory: controller.selectedCategory.value,
                  onCategorySelected: controller.selectCategory,
                ),
              ),
            ];
          }
          ,
          body: controller.filteredArticles.isEmpty
              ? const Center(
            child: Text(
              'Tidak ada artikel yang ditemukan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredArticles.length,
            itemBuilder: (context, index) {
              final article = controller.filteredArticles[index];
              return ArticleCard(
                article: article,
                onTap: () => Get.to(() => ArticleDetailView(article: article)),
                onFavoriteToggle: () => controller.toggleFavorite(article.id),
              );
            },
          ),
        ),
        ),
      ),
    );
  }
}

class CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryHeaderDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    article.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.primaries[article.id % Colors.primaries.length],
                        radius: 16,
                        child: Text(
                          article.author[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${article.readTime} min read',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onFavoriteToggle,
                        icon: Icon(
                          article.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: article.isFavorite ? Colors.red : Colors.grey,
                        ),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({super.key, required this.article});

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed(Routes.HOME);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorsDark.aksen,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF575757), offset: Offset(-1, -1), blurRadius: 2),
                  BoxShadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
                ],
              ),
              child: Icon(Icons.arrow_back, color: AppColorsDark.teksOnPrimary, size: 20),
            ),
          ),
          Text(
            "Article Detail",
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildAppBar(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Image
                    Container(
                      height: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported, size: 50,
                                    color: Colors.grey),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  article.category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                article.date,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.primaries[article.id %
                                    Colors.primaries.length],
                                radius: 20,
                                child: Text(
                                  article.author[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.author,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${article.readTime} min read',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GetBuilder<ArticlesController>(
                                builder: (controller) {
                                  final isFavorite = controller.articles
                                      .firstWhere((a) => a.id == article.id)
                                      .isFavorite;
                                  return IconButton(
                                    onPressed: () =>
                                        controller.toggleFavorite(article.id),
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons
                                          .favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '${article.content}\n\nTerima kasih telah membaca!',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Artikel Terkait',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: GetBuilder<ArticlesController>(
                              builder: (controller) {
                                final relatedArticles = controller.articles
                                    .where((a) =>
                                a.id != article.id && a.category == article.category)
                                    .take(3)
                                    .toList();

                                if (relatedArticles.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'Tidak ada artikel terkait',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: relatedArticles.length,
                                  itemBuilder: (context, index) {
                                    final relatedArticle = relatedArticles[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.off(() =>
                                            ArticleDetailView(article: relatedArticle));
                                      },
                                      child: Container(
                                        width: 250,
                                        margin: const EdgeInsets.only(right: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                relatedArticle.imageUrl,
                                                height: 120,
                                                width: 250,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) =>
                                                    Container(
                                                      height: 120,
                                                      width: 250,
                                                      color: Colors.grey.shade300,
                                                      child: const Icon(
                                                          Icons.image_not_supported,
                                                          size: 30, color: Colors.grey),
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              relatedArticle.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              relatedArticle.author,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}