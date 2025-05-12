import 'package:get/get.dart';
import '../models/facebook_post.dart';
import '../services/facebook_api_service.dart';

class FacebookBannerController extends GetxController {
  final FacebookApiService _apiService;
  FacebookPost bannerImages = FacebookPost().obs();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  FacebookBannerController(this._apiService) {
    fetchBannerImages();
  }

  Future<void> fetchBannerImages() async {
    isLoading.value = true;
    error.value = '';

    try {
      // First get all pages
      final pages = await _apiService.getPages();

      if (pages.isEmpty) {
        throw Exception('No Facebook pages found');
      }

      final page = pages.firstWhere(
        (page) => page.name == "اذاعة صوت السلام - بغديدي",
        orElse: () => throw Exception('Page not found'),
      );

      // Get posts from the selected page
      final posts = await _apiService.getPagePosts(page.accessToken, page.id);

      bannerImages = posts.obs();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
