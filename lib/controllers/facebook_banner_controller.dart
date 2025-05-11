import 'package:get/get.dart';
import '../models/facebook_post.dart';
import '../services/facebook_api_service.dart';

class FacebookBannerController extends GetxController {
  final FacebookApiService _apiService;
  final RxList<FacebookPost> bannerImages = <FacebookPost>[].obs;
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

      // Get posts from the first page (you can modify this to use a specific page)
      final page = pages[3];
      final posts = await _apiService.getPagePosts(page.id, page.accessToken);

      bannerImages.value = posts;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
