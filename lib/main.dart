import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radioapp/screen/splash_page.dart';
import 'controllers/facebook_banner_controller.dart';
import 'services/facebook_api_service.dart';
import 'services/facebook_token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  // Initialize token manager
  final tokenManager = Get.put(FacebookTokenManager());

  // Initialize API service with token manager
  final apiService = FacebookApiService(tokenManager);

  // Initialize banner controller
  Get.put(FacebookBannerController(apiService));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صوت السلام',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF232323),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
