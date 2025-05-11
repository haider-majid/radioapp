import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class FacebookTokenManager extends GetxController {
  // Your app's permanent tokens
  static const String _appId =
      '575293318384906'; // Replace with your Facebook App ID
  static const String _appSecret =
      'f60703d59a19d88944f7da4f75040856'; // Replace with your Facebook App Secret
  static const String _longLivedToken =
      'EAAbBLVFrnlwBO9MKjLCh1bxS0APs3fKB1qxvTSstZAjZClwZBQWN9jFJtKKkhCTBqfJps3ComSZBcomsi8hR2bxsFVhOL73iX3cbVAolh1mrcyz0j9x7qtmxx5NH0jyIuQ0ZBXDGhWpb1nLrvZAHxhnCZAg3Rtdl8pVYpo5ZAhjY68QHRCBNroxbZB9A3ygr1FgR8vQxN3dK24KKxoAOTL0cZAQ4TcXZB1z';

  final RxString currentToken = ''.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentToken.value = _longLivedToken;
    // Check token validity every 30 minutes
    ever(currentToken, (_) => _scheduleTokenCheck());
  }

  void _scheduleTokenCheck() {
    Future.delayed(const Duration(minutes: 30), () {
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
        await _refreshLongLivedToken();
      }
    } catch (e) {
      print('Token check failed: $e');
    }
  }

  Future<void> _refreshLongLivedToken() async {
    if (isRefreshing.value) return;

    try {
      isRefreshing.value = true;
      final response = await http.get(
        Uri.parse(
          'https://graph.facebook.com/v18.0/oauth/access_token?grant_type=fb_exchange_token&client_id=$_appId&client_secret=$_appSecret&fb_exchange_token=$_longLivedToken',
        ),
      );

      final data = json.decode(response.body);
      if (data['access_token'] != null) {
        currentToken.value = data['access_token'];
      }
    } catch (e) {
      print('Token refresh failed: $e');
      // Fallback to original long-lived token if refresh fails
      currentToken.value = _longLivedToken;
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<String> getCurrentToken() async {
    if (currentToken.isEmpty) {
      currentToken.value = _longLivedToken;
    }
    return currentToken.value;
  }
}
