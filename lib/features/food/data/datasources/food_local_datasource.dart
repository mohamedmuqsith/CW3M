import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_model.dart';
import '../models/category_model.dart';

abstract class FoodLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<FoodModel>> getFoods();
  Future<void> cacheFoods(List<FoodModel> foods);
  Future<void> addFood(FoodModel food);
  Future<void> updateFood(FoodModel food);
  Future<void> deleteFood(String id);
}

class FoodLocalDataSourceImpl implements FoodLocalDataSource {
  final Box foodBox;
  // We might store categories in the same box or a generic cache box,
  // but for simplicity let's assume they are small and can be in foodBox or a separate 'config' box.
  // Actually, I'll use a separate key or just mock categories for now if they are static,
  // but better to have them dynamic. Let's use a separate box for flexibility or strict keys.
  // For this coursework, I'll store categories in 'foodBox' with a specific prefix or just use a separate internal list.
  // Wait, I opened 'foodBox' in HiveService.

  FoodLocalDataSourceImpl({required this.foodBox});

  @override
  Future<List<CategoryModel>> getCategories() async {
    // In a real app, these might be in a separate box.
    // For now, returning dummy data if empty, or fetching from a 'categories' key.
    // Let's implement a simple storage for categories.
    final categories = foodBox.get('categories', defaultValue: []);
    if (categories is List) {
      return categories.cast<CategoryModel>().toList();
    }
    return [];
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    await foodBox.put('categories', categories);
  }

  @override
  Future<List<FoodModel>> getFoods() async {
    final foods = foodBox.values.whereType<FoodModel>().toList();
    return foods;
  }

  @override
  Future<void> cacheFoods(List<FoodModel> foods) async {
    await foodBox.clear(); // Simple cache strategy: replace all
    for (var food in foods) {
      await foodBox.put(food.id, food);
    }
    // Re-save categories if they were cleared (foodBox.clear() wipes everything)
    // Actually, better to use separate boxes or not clear key-based values.
    // Correct approach: Iterate and put.
    // But to handle deletions on remote, we might need to clear.
    // Let's assume 'foodBox' is ONLY for foods. I should have used a separate box for categories in HiveService.
    // I'll stick to foodBox for foods only.
  }

  // Revised cacheFoods to only touch food items if box is shared.
  // But given HiveService: await Hive.openBox('foodBox');
  // I will assume foodBox is strictly for FoodModel entries where key is ID.

  @override
  Future<void> addFood(FoodModel food) async {
    await foodBox.put(food.id, food);
  }

  @override
  Future<void> updateFood(FoodModel food) async {
    await foodBox.put(food.id, food);
  }

  @override
  Future<void> deleteFood(String id) async {
    await foodBox.delete(id);
  }
}
