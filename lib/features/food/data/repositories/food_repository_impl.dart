import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/food_local_datasource.dart';
import '../datasources/food_remote_datasource.dart';
import '../models/food_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodLocalDataSource localDataSource;
  final FoodRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FoodRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Category>> getCategories() async {
    try {
      // Try local first for speed
      var localCategories = await localDataSource.getCategories();

      if (localCategories.isEmpty && await networkInfo.isConnected) {
        // If empty and connected, fetch remote
        final remoteCategories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(remoteCategories);
        return remoteCategories;
      }

      return localCategories.isEmpty
          ? _getDefaultCategories()
          : localCategories;
    } catch (e) {
      return _getDefaultCategories();
    }
  }

  List<Category> _getDefaultCategories() {
    // Fallback if everything fails
    return [
      const Category(id: '1', name: 'Fast Food', imageUrl: ''),
      const Category(id: '2', name: 'Healthy', imageUrl: ''),
      const Category(id: '3', name: 'Drinks', imageUrl: ''),
    ];
  }

  @override
  Future<List<Food>> getAllFoods() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFoods = await remoteDataSource.getFoods();
        await localDataSource.cacheFoods(remoteFoods);
        return remoteFoods;
      } catch (e) {
        // Fallback to local on error
        return await localDataSource.getFoods();
      }
    } else {
      return await localDataSource.getFoods();
    }
  }

  @override
  Future<List<Food>> getFoodsByIds(List<String> ids) async {
    // 1. Try to get all from local first as we typically cache all
    final allLocal = await localDataSource.getFoods();
    return allLocal.where((f) => ids.contains(f.id)).toList();
  }

  @override
  Future<List<Food>> getFoodsByCategory(String categoryId) async {
    final allFoods = await getAllFoods();
    return allFoods.where((food) => food.categoryId == categoryId).toList();
  }

  @override
  Future<Food?> getFoodById(String id) async {
    final allFoods = await getAllFoods();
    try {
      return allFoods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addFood(Food food) async {
    final foodModel = FoodModel.fromEntity(food);

    // Always save local
    await localDataSource.addFood(foodModel);

    // Sync remote if connected
    if (await networkInfo.isConnected) {
      await remoteDataSource.addFood(foodModel);
    }
  }

  @override
  Future<void> updateFood(Food food) async {
    final foodModel = FoodModel.fromEntity(food);
    await localDataSource.updateFood(foodModel);

    if (await networkInfo.isConnected) {
      await remoteDataSource.updateFood(foodModel);
    }
  }

  @override
  Future<void> deleteFood(String id) async {
    await localDataSource.deleteFood(id);

    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteFood(id);
    }
  }
}
