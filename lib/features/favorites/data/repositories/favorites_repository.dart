import 'package:hive_flutter/hive_flutter.dart';
import '../../../food/domain/entities/food.dart';
import '../../../food/domain/repositories/food_repository.dart';

class FavoritesRepository {
  final Box favoritesBox;
  final FoodRepository foodRepository;

  FavoritesRepository(this.favoritesBox, this.foodRepository);

  List<String> getFavoriteIds() {
    return favoritesBox.keys.cast<String>().toList();
  }

  Future<List<Food>> getFavorites() async {
    final ids = getFavoriteIds();
    return foodRepository.getFoodsByIds(ids);
  }

  Future<void> addFavorite(String foodId) async {
    await favoritesBox.put(foodId, true);
  }

  Future<void> removeFavorite(String foodId) async {
    await favoritesBox.delete(foodId);
  }

  bool isFavorite(String foodId) {
    return favoritesBox.containsKey(foodId);
  }
}
