import 'package:get/get.dart';
import 'package:news/app/data/models/news_article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailController extends GetxController {
  final article = Rx<NewsArticle?>(null);
  final isLoading = true.obs;

  void openLink(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open link");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is NewsArticle) {
      article.value = Get.arguments;
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

  void launchArticleUrl() async {
    if (article.value?.url != null) {
      final uri = Uri.parse(article.value!.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
