import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/orders/presentation/screens/offline_orders_screen.dart';

import '../providers/food_providers.dart';
import '../widgets/category_card.dart';
import 'add_edit_food_screen.dart';
import 'food_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Food Ordering'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
             onPressed: () {
               // Navigation to Orders
               Navigator.push(context, MaterialPageRoute(builder: (_) => const OfflineOrdersScreen()));
             },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
              ),
              Text(
                'What do you want to eat?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              
              // Search Bar (Visual only for now)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                       ref.read(selectedCategoryProvider.notifier).state = null; // Clear filter
                       Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodListScreen(title: "All Foods")));
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 120, // Height for CategoryCard
                child: categoriesAsync.when(
                  data: (categories) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        category: category,
                        isSelected: selectedCategory == category.id,
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state = category.id;
                          Navigator.push(context, MaterialPageRoute(builder: (_) => FoodListScreen(categoryId: category.id, title: category.name)));
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),

              const SizedBox(height: 24),
              
              // Recent / Popular (Reusing FoodList provider for "All" or similar)
              // For simplicity, we just show a button or another section.
              // Let's show "Popular Foods" (All foods limited)
              Text(
                'Popular Foods',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              // Just a sneak peek of FoodListScreen embedded? 
              // Or better, keep it simple and rely on navigation.
              // I'll show a "Start Ordering" CTA or generic banner.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                   children: [
                     const Text(
                       "30% OFF\non your first order",
                       textAlign: TextAlign.center,
                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                     ),
                     const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, 
                          foregroundColor: theme.primaryColor,
                        ),
                        onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodListScreen(title: "All Foods")));
                        },
                        child: const Text("Order Now"),
                      )
                   ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditFoodScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
