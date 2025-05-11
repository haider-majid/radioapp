class FacebookPost {
  final String? fullPicture;
  final String id;

  FacebookPost({
    this.fullPicture,
    required this.id,
  });

  factory FacebookPost.fromJson(Map<String, dynamic> json) {
    return FacebookPost(
      fullPicture: json['full_picture'] as String?,
      id: json['id'] as String,
    );
  }
}
