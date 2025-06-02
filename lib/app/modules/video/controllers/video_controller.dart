import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoController extends GetxController {
  static const String API_KEY = 'AIzaSyAqPexz_NSvhCgSQdnOfgASYG0HQXpNCrI';

  var isLoading = true.obs;
  var videos = <VideoModel>[].obs;
  var selectedCategoryIndex = 0.obs;

  final List<String> categories = ['Semua', 'Trimester 1', 'Trimester 2', 'Trimester 3', 'Prenatal Yoga'];

  List<VideoModel> get filteredVideos {
    if (selectedCategoryIndex.value == 0) {
      return videos;
    } else {
      final selectedCategory = categories[selectedCategoryIndex.value];
      return videos.where((video) => video.category == selectedCategory).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchYouTubeVideos();
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void fetchYouTubeVideos() async {
    try {
      isLoading(true);
      List<VideoModel> allVideos = [];

      for (int i = 1; i < categories.length; i++) {
        final category = categories[i];
        String searchQuery = '';

        // Menyesuaikan query untuk senam ibu hamil Indonesia
        switch (category) {
          case 'Trimester 1':
            searchQuery = 'senam ibu hamil trimester 1 indonesia';
            break;
          case 'Trimester 2':
            searchQuery = 'senam ibu hamil trimester 2 indonesia';
            break;
          case 'Trimester 3':
            searchQuery = 'senam ibu hamil trimester 3 indonesia';
            break;
          case 'Prenatal Yoga':
            searchQuery = 'prenatal yoga indonesia senam hamil';
            break;
          default:
            searchQuery = 'senam ibu hamil indonesia';
        }

        final categoryVideos = await _searchYouTubeVideos(searchQuery, category);
        print("Fetched ${categoryVideos.length} videos for category $category");
        allVideos.addAll(categoryVideos);
      }

      if (allVideos.isEmpty) {
        print("No videos found for any category.");
      }

      videos.assignAll(allVideos);
    } catch (e) {
      print('Error fetching YouTube videos: $e');
      Get.snackbar(
        'Error',
        'Gagal mengambil video. Silakan coba lagi nanti.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<List<VideoModel>> _searchYouTubeVideos(String query, String category) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=8&q=$encodedQuery&type=video&regionCode=ID&relevanceLanguage=id&key=$API_KEY',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        if (items.isEmpty) {
          print("No items returned for query: $query");
        }

        return items.map((item) {
          final snippet = item['snippet'];
          final videoId = item['id']['videoId'];

          return VideoModel(
            id: videoId,
            title: snippet['title'] ?? 'Tidak ada judul',
            description: snippet['description'] ?? '',
            thumbnailUrl: snippet['thumbnails']?['high']?['url'],
            videoUrl: 'https://www.youtube.com/watch?v=$videoId',
            publishedDate: _formatPublishedDate(snippet['publishedAt']),
            views: 0,
            category: category,
            author: snippet['channelTitle'] ?? 'Tidak diketahui',
          );
        }).toList();
      } else {
        print('API request failed. Status: ${response.statusCode}, Body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error searching YouTube: $e');
      return [];
    }
  }

  String _formatPublishedDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return 'Tanggal Tidak Diketahui';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void playVideo(VideoModel video) {
    if (video.id.isNotEmpty) {
      Get.to(() => YouTubePlayerScreen(videoId: video.id, video: video));
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat memutar video',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
    }
  }
}

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;
  final VideoModel video;

  const YouTubePlayerScreen({
    Key? key,
    required this.videoId,
    required this.video,
  }) : super(key: key);

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252836),
      appBar: AppBar(
        title: Text(
          widget.video.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF252836),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.pink,
              progressColors: const ProgressBarColors(
                playedColor: Colors.pink,
                handleColor: Colors.pinkAccent,
              ),
            ),
            builder: (context, player) {
              return Column(
                children: [
                  player,
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.video.author ?? 'Tidak diketahui',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.video.publishedDate,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.pink.withOpacity(0.5)),
                    ),
                    child: Text(
                      widget.video.category ?? 'Senam Ibu Hamil',
                      style: const TextStyle(
                        color: Colors.pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Colors.grey[300],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.video.description.isNotEmpty
                        ? widget.video.description
                        : 'Video senam ibu hamil untuk menjaga kesehatan dan kebugaran selama masa kehamilan.',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.pink.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.pink,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tips Senam Ibu Hamil',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Lakukan dengan gerakan pelan dan hati-hati\n• Konsultasikan dengan dokter terlebih dahulu\n• Hentikan jika merasa tidak nyaman\n• Minum air yang cukup selama olahraga',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                            height: 1.4,
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
    );
  }
}

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? videoUrl;
  final String? duration;
  final String publishedDate;
  final int views;
  final String? category;
  final String? author;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.videoUrl,
    this.duration,
    required this.publishedDate,
    required this.views,
    this.category,
    this.author,
  });
}