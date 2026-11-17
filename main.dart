import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'news/news_screen.dart';

void main() => runApp(const MyApp());

// Simple data model for a food item
class Food {
  final String name;
  final double price;
  final double rating;
  final String image;
  const Food(this.name, this.price, this.rating, this.image);
}

const List<Food> foods = [
  Food('Beef Burger', 250, 4.5,
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400'),
  Food('Cheese Pizza', 450, 4.7,
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400'),
  Food('Chicken Biryani', 320, 4.8,
      'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400'),
  Food('Fresh Salad', 180, 4.2,
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400'),
  Food('Creamy Pasta', 380, 4.4,
      'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400'),
  Food('Ice Cream', 120, 4.6,
      'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400'),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  // Build a custom light or dark theme with the Poppins font
  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: brightness,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Menu',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: FoodMenuScreen(
        isDark: _isDark,
        onToggleTheme: () => setState(() => _isDark = !_isDark),
      ),
    );
  }
}

class FoodMenuScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  const FoodMenuScreen(
      {super.key, required this.isDark, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Menu'),
        actions: [
          // Button to open the News Reader screen
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsScreen()),
            ),
            child: const Text('News'),
          ),
          // Button to switch between light and dark theme
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Wide screen: GridView, phone: ListView
          if (constraints.maxWidth >= 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450,
                mainAxisExtent: 130,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: foods.length,
              itemBuilder: (context, i) => FoodCard(food: foods[i]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: foods.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(height: 130, child: FoodCard(food: foods[i])),
            ),
          );
        },
      ),
    );
  }
}

// Reusable custom widget using Row, Column, Stack and Expanded
class FoodCard extends StatelessWidget {
  final Food food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  food.image,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: theme.colorScheme.secondaryContainer,
                    child: const Icon(Icons.restaurant, size: 40),
                  ),
                ),
                // Rating badge on top of the image
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          food.rating.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tk ${food.price.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
