// lib/app/data/services/news_service.dart
import 'package:get/get.dart';
import 'package:news/app/data/constant.dart';
import '../models/news_response.dart';

class NewsService extends GetConnect {
  Future<NewsResponse?> getNews(String query) async {
    final response = await get(
      '${ApiConstant.baseUrl}${ApiConstant.topHeadlines}',
      query: {
        'q': query,
        'apiKey': ApiConstant.apiKey,
      },
    );

    if (response.status.hasError || response.body == null) {
      return null;
    }

    return NewsResponse.fromJson(response.body);
  }

  Future<NewsResponse?> getNewsByCategory(String category) async {
    final response = await get(
      '${ApiConstant.baseUrl}/top-headlines',
      query: {'category': category, 'apiKey': ApiConstant.apiKey},
    );

     if (response.status.hasError || response.body == null) {
      return null;
    }

    return NewsResponse.fromJson(response.body);
  }

  Future<NewsResponse?> getNewsSearch(String query) async {
    final response = await get(
      '${ApiConstant.baseUrl}${ApiConstant.topHeadlines}',
      query: {
        'q': query,
        'apiKey': ApiConstant.apiKey,
      },
    );

    if (response.status.hasError || response.body == null) {
      return null;
    }

    return NewsResponse.fromJson(response.body);
  }
}
