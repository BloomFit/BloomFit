import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../controllers/video_controller.dart';

class VideoView extends StatelessWidget {
  final VideoController controller = Get.put(VideoController());

  VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDark.fourth,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingView();
          } else {
            return _buildMainContent();
          }
        }),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColorsDark.aksen,
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading pregnancy videos...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildAppBar(),
        _buildCategorySelector(),
        Expanded(
          child: _buildVideoList(),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: AppColorsDark.third,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColorsDark.fourth,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Pregnancy Videos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorsDark.fourth,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['All', 'Health', 'Baby Development', 'Nutrition', 'Exercise'];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = controller.selectedCategoryIndex.value == index;
          return GestureDetector(
            onTap: () => controller.selectCategory(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColorsDark.aksen : AppColorsDark.third,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColorsDark.aksen?.withOpacity(0.3) ?? Colors.transparent,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontSize: isSelected ? 15 : 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildVideoList() {
    return Obx(() {
      final videosToShow = controller.filteredVideos;

      if (videosToShow.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                size: 50,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No videos found',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: videosToShow.length,
        itemBuilder: (context, index) {
          final video = videosToShow[index];
          final isFeatured = index == 0 && controller.selectedCategoryIndex.value == 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFeatured)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Featured Video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              _buildVideoCard(video, isFeatured),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    });
  }

  Widget _buildVideoCard(VideoModel video, bool isFeatured) {
    final Color accentColor = AppColorsDark.aksen ?? Colors.pink;

    return GestureDetector(
      onTap: () => controller.playVideo(video),
      child: Container(
        decoration: BoxDecoration(
          color: AppColorsDark.third,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: isFeatured ? Border.all(color: accentColor, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Stack(
                children: [
                  Container(
                    height: isFeatured ? 200 : 180,
                    width: double.infinity,
                    color: AppColorsDark.fourth,
                    child: video.thumbnailUrl != null
                        ? Image.network(
                      video.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildThumbnailPlaceholder(video.category);
                      },
                    )
                        : _buildThumbnailPlaceholder(video.category),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  if (video.category != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          video.category!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  if (video.duration != null)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video.duration!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                    video.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: accentColor.withOpacity(0.3),
                            child: Icon(
                              Icons.person,
                              size: 14,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            video.author ?? 'Pregnancy Expert',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            video.publishedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.visibility_outlined,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${video.views}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
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

  Widget _buildThumbnailPlaceholder(String? category) {
    IconData icon;
    switch (category?.toLowerCase()) {
      case 'health':
        icon = Icons.favorite;
        break;
      case 'baby development':
        icon = Icons.child_care;
        break;
      case 'nutrition':
        icon = Icons.restaurant;
        break;
      case 'exercise':
        icon = Icons.fitness_center;
        break;
      default:
        icon = Icons.videocam;
    }

    return Container(
      color: AppColorsDark.aksen?.withOpacity(0.2),
      child: Center(
        child: Icon(
          icon,
          size: 60,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}
