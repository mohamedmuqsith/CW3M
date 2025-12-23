import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;

  WorkoutRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      final snapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('workouts')
          .orderBy('date', descending: true)
          .get();
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
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      await firestore
          .collection('users')
          .doc(user.uid)
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
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      await firestore
          .collection('users')
          .doc(user.uid)
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
      final user = auth.currentUser;
      if (user == null) throw const ServerFailure('User not authenticated');

      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('workouts')
          .doc(id)
          .delete();
    } catch (e) {
      throw const ServerFailure('Failed to delete workout from server');
    }
  }
}
