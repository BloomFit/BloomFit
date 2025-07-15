import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/modules/articles/controllers/articles_controller.dart';

class ArticlesView extends StatelessWidget {
  final ArticlesController controller = Get.put(ArticlesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Senam Ibu Hamil'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Cari artikel...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Dropdown Category Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Obx(() => DropdownButton<String>(
                value: controller.selectedCategory.value,
                isExpanded: true,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectCategory(newValue);
                  }
                },
                items: controller.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              )),
            ),

            const SizedBox(height: 10),

            // List Artikel
            Expanded(
              child: Obx(() {
                if (controller.filteredArticles.isEmpty) {
                  return const Center(child: Text('Tidak ada artikel ditemukan.'));
                }

                return ListView.builder(
                  itemCount: controller.filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = controller.filteredArticles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        leading: Image.network(
                          article.imageUrl,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(article.title),
                        subtitle: Text('${article.author} • ${article.readTime} min read'),
                        trailing: IconButton(
                          icon: Icon(
                            article.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: article.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => controller.toggleFavorite(article.id),
                        ),
                        onTap: () {
                          // Aksi saat artikel ditekan (misalnya navigasi ke detail)
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
