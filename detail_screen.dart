import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'article.dart';
import 'news_provider.dart';

class DetailScreen extends StatelessWidget {
  final Article article;
  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final news = context.watch<NewsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            icon: Icon(
              news.isFavorite(article.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () =>
                context.read<NewsProvider>().toggleFavorite(article.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(article.body),
          ],
        ),
      ),
    );
  }
}
