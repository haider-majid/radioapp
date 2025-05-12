import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class FacebookTokenManager extends GetxController {
  // Your app's permanent tokens
  static const String _appId =
      '1901250243960412'; // Replace with your Facebook App ID
  static const String _appSecret =
      '5e6b8d25ece9342aded1a6863651d6cd'; // Replace with your Facebook App Secret
  static const String _longLivedToken =
      'EAAbBLVFrnlwBOZCRQ4ZCdK5aOfEiWJ6oR8qzEn3rgCgT0ObYPSvfoasLKWehR559mekl0HOHXQApgpMtIdzSXh46q33VnbdUb9zuajJxv5sQczPNy3Afqh0YHZCZBVObq4YAjzHO6vj1EShQRPnS95YBoJz4ClxQx1BeULcImEyCoQBG0vZA8';
  // static final String _appId = dotenv.env['FACEBOOK_APP_ID'] ?? '';
  // static final String _appSecret = dotenv.env['FACEBOOK_APP_SECRET'] ?? '';
  // static final String _longLivedToken =
  //     dotenv.env['FACEBOOK_LONG_LIVED_TOKEN'] ?? '';

  final RxString currentToken = ''.obs;
  final RxBool isRefreshed = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentToken.value = _longLivedToken;

    _checkAndRefreshToken();
    ever(currentToken, (_) => _scheduleTokenCheck());

    // Listen if refreshed
    ever(isRefreshed, (refreshed) {
      if (refreshed == true) {
        print('🔄 Token has been refreshed and is now active!');
        isRefreshed.value = false; // Reset after showing message
      }
    });
  }

  void _scheduleTokenCheck() {
    Future.delayed(const Duration(seconds: 2), () {
      _checkAndRefreshToken();
    });
  }

  Future<void> _checkAndRefreshToken() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://graph.facebook.com/v18.0/debug_token?input_token=${currentToken.value}&access_token=$_appId|$_appSecret',
        ),
      );

      final data = json.decode(response.body);
      if (data['data']?['is_valid'] == false) {
        print('Token is invalid, refreshing...');
        await _refreshLongLivedToken();
      } else {
        print('Token is valid.');
      }
    } catch (e) {
      print('Token check failed: $e');
    }
  }

  Future<void> _refreshLongLivedToken() async {
    if (isRefreshed.value) return;

    try {
      isRefreshed.value = true;
      final response = await http.get(
        Uri.parse(
          'https://graph.facebook.com/v18.0/oauth/access_token?grant_type=fb_exchange_token&client_id=$_appId&client_secret=$_appSecret&fb_exchange_token=$_longLivedToken',
        ),
      );

      final data = json.decode(response.body);
      if (data['access_token'] != null) {
        currentToken.value = data['access_token'];
        isRefreshed.value = true;
        print('✅ Token refreshed successfully: ${currentToken.value}');
      } else {
        print('❌ Failed to refresh token: ${data['error']}');
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
      currentToken.value = _longLivedToken;
    } finally {
      isRefreshed.value = false;
    }
  }

  Future<String> getCurrentToken() async {
    if (currentToken.isEmpty) {
      currentToken.value = _longLivedToken;
    }
    return currentToken.value;
  }
}
