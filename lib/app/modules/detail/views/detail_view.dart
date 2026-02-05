import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.article.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final article = controller.article.value!;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (article.urlToImage != null &&
                        article.urlToImage!.isNotEmpty)
                      Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[300]),
                      )
                    else
                      Container(color: Colors.grey[300]),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(
                              0.4,
                            ), // For status bar readability
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.6), // Bottom darken
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                transform: Matrix4.translationValues(
                  0,
                  -24,
                  0,
                ), // Negative overlap
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          article.source?.name ?? "Global News",
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        article.title ?? "No Title",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: Color(0xFF1E293B), // Slate 800
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Author & Date Row
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getAuthor(article.author),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(article.publishedAt),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(
                        height: 48,
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      ),

                      // Content Body
                      Text(
                        article.content != null
                            ? article.content!.split(
                                '[',
                              )[0] // Remove [+chars] suffix often sent by API
                            : (article.description ??
                                  "No specific content details available. Please visit the full article to read more."),
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.8,
                          color: Color(0xFF334155), // Slate 700
                        ),
                      ),

                      const SizedBox(height: 40),

                      // "Read Full Article" Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.launchArticleUrl,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shadowColor: Colors.blueAccent.withOpacity(0.4),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: InkWell(
                            onTap: () => controller.openLink(article.url!),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Read Full Article",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getAuthor(dynamic author) {
    if (author == null) return "Unknown Author";
    return author.toString();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date";
    return "${date.day} ${_getMonth(date.month)} ${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

    
}
