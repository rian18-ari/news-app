import 'package:news/app/data/models/news_article.dart';

class NewsResponse {
  final String status;
  final int totalResults;
  final List<NewsArticle> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic>? json) => NewsResponse(
    status: json?['status'] ?? '',
    totalResults: json?['totalResults'] ?? 0,
    articles: (json?['articles'] as List<dynamic>? ?? [])
        .map((items) => NewsArticle.fromJson(items as Map<String, dynamic>))
        .toList() ?? [],
  );
}
