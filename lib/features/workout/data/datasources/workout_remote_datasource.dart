import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../models/workout_model.dart';

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<void> addWorkout(WorkoutModel workout);
  Future<void> updateWorkout(WorkoutModel workout);
  Future<void> deleteWorkout(String id);
}

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final FirebaseFirestore firestore;

  WorkoutRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final snapshot = await firestore.collection('workouts').get();
      return snapshot.docs
          .map((doc) => WorkoutModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw const ServerFailure('Failed to fetch workouts from server');
    }
  }

  @override
  Future<void> addWorkout(WorkoutModel workout) async {
    try {
      await firestore
          .collection('workouts')
          .doc(workout.id)
          .set(workout.toJson());
    } catch (e) {
      throw const ServerFailure('Failed to add workout to server');
    }
  }

  @override
  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      await firestore
          .collection('workouts')
          .doc(workout.id)
          .update(workout.toJson());
    } catch (e) {
      throw const ServerFailure('Failed to update workout on server');
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      await firestore.collection('workouts').doc(id).delete();
    } catch (e) {
      throw const ServerFailure('Failed to delete workout from server');
    }
  }
}
