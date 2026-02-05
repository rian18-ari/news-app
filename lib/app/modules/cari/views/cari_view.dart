import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news/app/data/models/news_article.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/cari_controller.dart';

class CariView extends GetView<CariController> {
  const CariView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FD),
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFF5F9FD),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: const Color(0xFFF5F9FD),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  TextField(
                    controller: controller.searchController,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Cari berita, topik, atau penulis...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: Obx(
                        () => controller.searchText.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: controller.clearSearch,
                              )
                            : const SizedBox.shrink(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (value) => controller.performSearch(value),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () => controller.performSearch(
                      controller.searchController.text,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Obx(() {
              // 1. If text is empty, show recents
              if (controller.searchText.isEmpty) {
                return _buildRecentSearches();
              }

              // 2. If loading, show spinner
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // 3. If no results, show empty state
              if (controller.searchResults.isEmpty) {
                return _buildEmptyState();
              }

              // 4. Show results
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  return _buildArticleCard(controller.searchResults[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (controller.recentSearches.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Pencarian Terakhir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...controller.recentSearches.map((term) => _buildRecentItem(term)),
          const SizedBox(height: 24),
        ],

        const Text(
          'Topik Populer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTopicChip('Teknologi'),
            _buildTopicChip('Olahraga'),
            _buildTopicChip('Ekonomi'),
            _buildTopicChip('Politik'),
            _buildTopicChip('Kesehatan'),
            _buildTopicChip('Travel'),
            _buildTopicChip('Crypto'),
            _buildTopicChip('AI'),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentItem(String term) {
    return InkWell(
      onTap: () => controller.performSearch(term),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, color: Colors.grey, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                term,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const Icon(Icons.north_west, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String label) {
    return ActionChip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => controller.performSearch(label),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Tidak ditemukan hasil untuk "${controller.searchText.value}"',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Coba kata kunci lain',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openLink(article.url ?? ""),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: article.urlToImage != null && article.urlToImage != ""
                      ? Image.network(
                          article.urlToImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                        )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source?.name ?? "Unknown Source",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title ?? "No Title",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(article.publishedAt),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date";
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _openLink(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
