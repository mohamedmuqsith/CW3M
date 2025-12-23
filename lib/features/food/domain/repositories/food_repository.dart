import '../entities/category.dart';
import '../entities/food.dart';

abstract class FoodRepository {
  Future<List<Category>> getCategories();
  Future<List<Food>> getFoodsByCategory(String categoryId);
  Future<List<Food>> getAllFoods();
  Future<List<Food>> getFoodsByIds(List<String> ids);
  Future<Food?> getFoodById(String id);
  Future<void> addFood(Food food);
  Future<void> updateFood(Food food);
  Future<void> deleteFood(String id);
}
