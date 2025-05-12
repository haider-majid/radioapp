import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/facebook_page.dart';
import '../models/facebook_post.dart';
import 'facebook_token_manager.dart';

class FacebookApiService {
  static const String _baseUrl = 'https://graph.facebook.com/v18.0';
  final FacebookTokenManager _tokenManager;

  FacebookApiService(this._tokenManager);

  Future<List<FacebookPage>> getPages() async {
    try {
      final token = await _tokenManager.getCurrentToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/me/accounts?access_token=$token'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> pagesData = data['data'];
        return pagesData.map((page) => FacebookPage.fromJson(page)).toList();
      } else {
        throw Exception('Failed to load pages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pages: $e');
    }
  }

  Future<FacebookPost> getPagePosts(
      String pageAccessToken, String pageId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://graph.facebook.com/$pageId/posts?fields=full_picture&limit=4&access_token=$pageAccessToken',
        ),
      );
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);

        return data['data'] != null
            ? FacebookPost.fromJson(data)
            : FacebookPost(data: []);
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }
}
