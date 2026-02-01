import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CariController extends GetxController {
  final searchController = TextEditingController();
  final searchText = ''.obs;

  // Dummy recents for UI demo
  final recentSearches = <String>[
    'Flutter tutorials',
    'GetX state management',
    'News api integration',
    'Dart null safety',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
  }

  void addToRecent(String query) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
