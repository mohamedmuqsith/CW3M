import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getMeals(DateTime date);
  Future<void> addMeal(MealModel meal);
  Future<void> deleteMeal(String id);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  MealRemoteDataSourceImpl(this.firestore, this.auth);

  @override
  Future<List<MealModel>> getMeals(DateTime date) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('meals')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw const ServerFailure('Failed to fetch meals');
    }
  }

  @override
  Future<void> addMeal(MealModel meal) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('meals')
          .doc(meal.id)
          .set(meal.toJson());
    } catch (e) {
      throw const ServerFailure('Failed to add meal');
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('meals')
          .doc(id)
          .delete();
    } catch (e) {
      throw const ServerFailure('Failed to delete meal');
    }
  }
}
