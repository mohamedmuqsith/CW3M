import '../entities/category.dart';
import '../entities/food.dart';
import '../repositories/food_repository.dart';

class GetCategories {
  final FoodRepository repository;
  GetCategories(this.repository);
  Future<List<Category>> call() => repository.getCategories();
}

class GetFoodsByCategory {
  final FoodRepository repository;
  GetFoodsByCategory(this.repository);
  Future<List<Food>> call(String categoryId) => repository.getFoodsByCategory(categoryId);
}

class AddFood {
  final FoodRepository repository;
  AddFood(this.repository);
  Future<void> call(Food food) => repository.addFood(food);
}

class UpdateFood {
  final FoodRepository repository;
  UpdateFood(this.repository);
  Future<void> call(Food food) => repository.updateFood(food);
}

class DeleteFood {
  final FoodRepository repository;
  DeleteFood(this.repository);
  Future<void> call(String id) => repository.deleteFood(id);
}
