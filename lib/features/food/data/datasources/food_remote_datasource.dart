import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/constants.dart';
import '../models/food_model.dart';
import '../models/category_model.dart';

abstract class FoodRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<FoodModel>> getFoods();
  Future<void> addFood(FoodModel food);
  Future<void> updateFood(FoodModel food);
  Future<void> deleteFood(String id);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  final FirebaseFirestore firestore;

  FoodRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> getCategories() async {
    // For coursework, we might hardcode categories on the server or fetch a collection.
    // Let's assume a 'categories' collection exists or I return static for now if offline.
    // I'll implement it as a collection fetch.
    try {
      final snapshot = await firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel(
          id: doc.id,
          name: data['name'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      // If categories don't exist, return default ones for the demo
      return [
        const CategoryModel(id: '1', name: 'Fast Food', imageUrl: 'assets/fast_food.png'),
        const CategoryModel(id: '2', name: 'Healthy', imageUrl: 'assets/healthy.png'),
        const CategoryModel(id: '3', name: 'Drinks', imageUrl: 'assets/drinks.png'),
        const CategoryModel(id: '4', name: 'Dessert', imageUrl: 'assets/dessert.png'),
      ];
    }
  }

  @override
  Future<List<FoodModel>> getFoods() async {
    final snapshot = await firestore.collection(AppConstants.foodsCollection).get();
    return snapshot.docs.map((doc) => FoodModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addFood(FoodModel food) async {
    await firestore.collection(AppConstants.foodsCollection).doc(food.id).set(food.toJson());
  }

  @override
  Future<void> updateFood(FoodModel food) async {
    await firestore.collection(AppConstants.foodsCollection).doc(food.id).update(food.toJson());
  }

  @override
  Future<void> deleteFood(String id) async {
    await firestore.collection(AppConstants.foodsCollection).doc(id).delete();
  }
}
