import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/meal_remote_datasource.dart';
import '../../data/models/meal_model.dart';

final mealRemoteDataSourceProvider = Provider<MealRemoteDataSource>((ref) {
  return MealRemoteDataSourceImpl(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

final nutritionProvider =
    StateNotifierProvider<NutritionNotifier, AsyncValue<List<MealModel>>>(
        (ref) {
  return NutritionNotifier(ref.read(mealRemoteDataSourceProvider));
});

class NutritionNotifier extends StateNotifier<AsyncValue<List<MealModel>>> {
  final MealRemoteDataSource _dataSource;
  DateTime _selectedDate = DateTime.now();

  NutritionNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    getMeals(_selectedDate);
  }

  Future<void> getMeals(DateTime date) async {
    _selectedDate = date;
    state = const AsyncValue.loading();
    try {
      final meals = await _dataSource.getMeals(date);
      state = AsyncValue.data(meals);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> addMeal(MealModel meal) async {
    try {
      await _dataSource.addMeal(meal);
      getMeals(_selectedDate); // Refresh
    } catch (e) {
      // Handle error (maybe show snackbar in UI via listener)
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      await _dataSource.deleteMeal(id);
      getMeals(_selectedDate); // Refresh
    } catch (e) {
      // Handle error
    }
  }
}
