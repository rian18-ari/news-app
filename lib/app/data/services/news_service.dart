// lib/app/data/services/news_service.dart
import 'package:get/get.dart';
import 'package:news/app/data/constant.dart';
import '../models/news_response.dart';

class NewsService extends GetConnect {
  Future<NewsResponse> getNews() async {
    final response = await get(
      '${ApiConstant.baseUrl}${ApiConstant.topHeadlines}',
      query: {'country': ApiConstant.country, 'apiKey': ApiConstant.apiKey},
    );
    return NewsResponse.fromJson(response.body);
  }
}
  