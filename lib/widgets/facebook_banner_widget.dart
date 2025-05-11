import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/facebook_banner_controller.dart';

class FacebookBannerWidget extends StatelessWidget {
  const FacebookBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FacebookBannerController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          height: 200,
          color: const Color(0xFFEF4A2B),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }

      if (controller.error.isNotEmpty) {
        return Container(
          height: 200,
          color: const Color(0xFFEF4A2B),
          child: Center(
            child: Text(
              'Error: ${controller.error.value}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }

      if (controller.bannerImages.isEmpty) {
        return Container(
          height: 200,
          color: const Color(0xFFEF4A2B),
          child: const Center(
            child: Text(
              'No banner images available',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }

      return Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Color(0xFFEF4A2B),
        ),
        child: ListView.builder(
          scrollDirection:
              Axis.horizontal, // اجعل الاتجاه أفقي ليكون مثل السلايدر
          itemCount: controller.bannerImages.length,
          itemBuilder: (context, index) {
            final post = controller.bannerImages[index];
            return Container(
              width: 300, // حدد عرض كل عنصر
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: post.fullPicture != null
                    ? Image.network(
                        post.fullPicture!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF4A2B),
                                size: 48,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFEF4A2B)),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Color(0xFFEF4A2B),
                            size: 48,
                          ),
                        ),
                      ),
              ),
            );
          },
        ),
      );
    });
  }
}
