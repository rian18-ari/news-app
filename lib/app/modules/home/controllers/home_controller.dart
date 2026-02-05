import 'package:get/get.dart';
import 'package:news/app/data/models/news_article.dart';
import 'package:news/app/data/services/news_service.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final NewsService _newsService = NewsService();
  var articles = <NewsArticle>[].obs;
  var isLoading = true.obs;

  final List<String> categories = [
    "General",
    "Business",
    "Technology",
    "Health",
    "Science",
    "Sports",
    "Entertainment",
    "indonesia"
  ];

  var selectedCategory = "General".obs;

  @override
  void onInit() {
    getNews();
    super.onInit();
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    getNews(query: category);
  }

  void getNews({String query = ""}) async {
    try {
      isLoading(true);
      
      // Bersihkan list lama kalau mau refresh data
      articles.clear(); 
      
      var response = await _newsService.getNewsByCategory(
        selectedCategory.value.toLowerCase()
      );
      
      if (response != null && response.articles != null) {
        // Menggunakan operator '!' karena kita sudah cek null di atas
        articles.assignAll(response.articles as List<NewsArticle>);
      } else {
        // Opsional: Tampilkan snackbar kalau data kosong
        Get.snackbar("Info", "Tidak ada berita ditemukan");
      }
    } catch (e) {
      // Penting: Tangkap error jika network gagal
      Get.snackbar("Error", "Gagal mengambil data: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
