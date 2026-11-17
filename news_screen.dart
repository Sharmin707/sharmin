import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider()..fetchArticles(),
      child: const _NewsView(),
    );
  }
}

class _NewsView extends StatelessWidget {
  const _NewsView();

  @override
  Widget build(BuildContext context) {
    final news = context.watch<NewsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
        actions: [
          // Favorites count in the AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 4),
                Text('${news.favoriteCount}'),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => context.read<NewsProvider>().search(v),
            ),
          ),
          Expanded(child: _buildBody(context, news)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewsProvider news) {
    // Loading state
    if (news.status == NewsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    // Error state with Retry button
    if (news.status == NewsStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(news.errorMessage),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<NewsProvider>().fetchArticles(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    // Success state
    final list = news.articles;
    if (list.isEmpty) {
      return const Center(child: Text('No articles found'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final a = list[i];
        return ListTile(
          title: Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(a.body, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: Icon(
              news.isFavorite(a.id) ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => context.read<NewsProvider>().toggleFavorite(a.id),
          ),
          onTap: () {
            final provider = context.read<NewsProvider>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: provider,
                  child: DetailScreen(article: a),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
