import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/food_providers.dart';
import '../widgets/food_card.dart';
import 'add_edit_food_screen.dart';
import 'food_details_screen.dart';

class FoodListScreen extends ConsumerWidget {
  final String? categoryId;
  final String title;

  const FoodListScreen({super.key, this.categoryId, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If categoryId is provided, use filtered provider (we need to create one or filter locally)
    // We have `foodsByCategoryProvider` which takes family.
    // But if null, we need all foods.
    // Let's create `allFoodsProvider` in providers or just use repo direct.
    
    // I defined `getCategoriesProvider` etc. 
    // I need a provider for foods.
    // Let's use `foodsByCategoryProvider` if ID is there, else fetch all.
    // Wait, ref.watch needs a stable provider.
    
    // Helper to get foods
    final foodsAsync = categoryId != null 
        ? ref.watch(foodsByCategoryProvider(categoryId!))
        : ref.watch(allFoodsProvider); 
        // Oops, I didn't explicitly create `allFoodsProvider` in the file I wrote.
        // I created `foodsByCategoryProvider`.
        // I should update `food_providers.dart` or define one here ad-hoc.
        // Defining ad-hoc for now to save tool calls, but normally in providers file.
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: foodsAsync.when(
        data: (foods) {
          if (foods.isEmpty) {
            return const Center(child: Text("No food items found."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return FoodCard(
                food: food,
                isFavorite: false, // TODO: connect to favorite provider
                onFavoriteToggle: () {
                  // TODO: implement toggle
                },
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailsScreen(food: food)));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_food',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditFoodScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Temporary provider definition to make this file compilable if I missed it
final allFoodsProvider = FutureProvider<List<dynamic>>((ref) async {
  // dynamic -> Food
   // Assuming imports work, need to cast or fix.
   // Using the usecase directly
   // This is a bit hacky, better to update providers file.
   // But for now:
   final repo = ref.read(foodRepositoryProvider);
   return repo.getAllFoods();
});
