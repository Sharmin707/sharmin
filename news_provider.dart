import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'article.dart';

enum NewsStatus { loading, success, error }

class NewsProvider extends ChangeNotifier {
  NewsStatus status = NewsStatus.loading;
  String errorMessage = '';
  List<Article> _articles = [];
  String _query = '';
  final Set<int> _favorites = {};

  // Articles filtered by the search query
  List<Article> get articles {
    if (_query.isEmpty) return _articles;
    return _articles
        .where((a) => a.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  int get favoriteCount => _favorites.length;

  bool isFavorite(int id) => _favorites.contains(id);

  Future<void> fetchArticles() async {
    status = NewsStatus.loading;
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _articles = data.map((e) => Article.fromJson(e)).toList();
        status = NewsStatus.success;
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
        status = NewsStatus.error;
      }
    } catch (e) {
      errorMessage = 'Could not load articles. Check your internet.';
      status = NewsStatus.error;
    }
    notifyListeners();
  }

  void search(String query) {
    _query = query;
    notifyListeners();
  }

  void toggleFavorite(int id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }
}
