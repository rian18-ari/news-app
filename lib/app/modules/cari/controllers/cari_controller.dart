import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:news/app/data/models/news_article.dart';
import 'package:news/app/data/services/news_service.dart';

class CariController extends GetxController {
  final NewsService newsService = Get.find<NewsService>();
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxString searchText = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<NewsArticle> searchResults = <NewsArticle>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Debounce search input
    debounce(searchText, (String query) {
      if (query.trim().isNotEmpty) {
        searchNews(query);
      } else {
        searchResults.clear();
      }
    }, time: const Duration(milliseconds: 800));

    // Listen to changes
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    isLoading.value = true;
    addToRecent(query);

    try {
      final response = await newsService.getNews(query);
      if (response != null) {
        searchResults.assignAll(response.articles);
      } else {
        searchResults.clear();
      }
    } catch (e) {
      print("Error searching news: $e");
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Handle recent searches
  final recentSearches = <String>[
    'Teknologi',
    'Crypto',
    'Sepak Bola',
    'Politik',
  ].obs;

  void addToRecent(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    }
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    searchResults.clear();
  }

  void performSearch(String query) {
    searchController.text = query;
    // Debounce will trigger, or we can force it immediately
    searchNews(query);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearch(String query) async {
    if (query.isEmpty) {
      Get.snackbar("Error", "harap isi kolom pencarian");
      return;
    } 
    isLoading.value = true;

    try{
      final response = await newsService.getNewsSearch(query);
      if (response != null) {
        searchResults.assignAll(response.articles);
      } else {
        searchResults.clear();
      }
    }catch(e){
      print("Error searching news: $e");
      searchResults.clear();
    }finally{
      isLoading.value = false;
    }
  }
}
