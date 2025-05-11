class FacebookPage {
  final String accessToken;
  final String category;
  final String name;
  final String id;
  final List<String> tasks;

  FacebookPage({
    required this.accessToken,
    required this.category,
    required this.name,
    required this.id,
    required this.tasks,
  });

  factory FacebookPage.fromJson(Map<String, dynamic> json) {
    return FacebookPage(
      accessToken: json['access_token'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      id: json['id'] as String,
      tasks: List<String>.from(json['tasks'] as List),
    );
  }
}
