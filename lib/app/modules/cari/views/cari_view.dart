import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cari_controller.dart';

class CariView extends GetView<CariController> {
  const CariView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.searchController,
                autofocus: true,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Cari berita, topik, atau penulis...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
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
                onSubmitted: (value) => controller.addToRecent(value),
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Obx(() {
              // State: Searching (Query is not empty)
              if (controller.searchText.isNotEmpty) {
                return _buildSearchResults();
              }

              // State: Initial / Recent History
              return _buildRecentSearches();
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
          ],
        ),
      ],
    );
  }

  Widget _buildRecentItem(String term) {
    return InkWell(
      onTap: () {
        controller.searchController.text = term;
      },
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
      onPressed: () {
        controller.searchController.text = label;
      },
    );
  }

  Widget _buildSearchResults() {
    // Placeholder for search results
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Mencari "${controller.searchText.value}"...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hasil akan muncul di sini',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
