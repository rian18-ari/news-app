import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  // ... import dan class tetap sama ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Obx(() {
        // Tampilkan loading jika data masih diambil
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tampilkan pesan jika data kosong
        if (controller.articles.isEmpty) {
          return const Center(child: Text("Tidak ada berita."));
        }

        return SingleChildScrollView( // Agar bisa di-scroll
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "HOT NEWS",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // MAMPILKAN DATA DARI API
                ListView.builder(
                  shrinkWrap: true, // Penting agar tidak error di dalam Column
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final news = controller.articles[index];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Gambar dari URL API
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: news.urlToImage != null && news.urlToImage != ""
                                ? Image.network(
                                    news.urlToImage!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 50),
                                  )
                                : Container(height: 200, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              news.title ?? "No Title",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}