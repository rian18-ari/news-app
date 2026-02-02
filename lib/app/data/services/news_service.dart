// lib/app/data/services/news_service.dart
import 'package:get/get.dart';
import 'package:news/app/data/constant.dart';
import '../models/news_response.dart';

class NewsService extends GetConnect {
  Future<NewsResponse?> getNews() async {
    final response = await get(
      '${ApiConstant.baseUrl}${ApiConstant.topHeadlines}',
      query: {
        'q': 'tesla',
        // 'from': '2026-01-01',
        // 'sortBy': 'relevancy',
        'apiKey': ApiConstant.apiKey,
      },
    );

    if (response.status.hasError || response.body == null) {
      return null;
    }

    return NewsResponse.fromJson(response.body);
  }
}
  