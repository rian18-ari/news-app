class NewsDetail {
  NewsDetail({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  factory NewsDetail.fromJson(Map<String, dynamic> json) => NewsDetail(
        title: json['title'] as String,
        description: json['description'] as String,
        url: json['url'] as String,
        urlToImage: json['urlToImage'] as String,
        publishedAt: json['publishedAt'] as String,
        content: json['content'] as String,
      );
}