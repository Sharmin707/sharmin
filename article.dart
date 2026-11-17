// Model class for one article
class Article {
  final int id;
  final String title;
  final String body;

  const Article({required this.id, required this.title, required this.body});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
