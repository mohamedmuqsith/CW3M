import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/failures.dart';
import '../models/workout_model.dart';

abstract class WorkoutLocalDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<void> cacheWorkout(WorkoutModel workout);
  Future<void> deleteWorkout(String id);
  Future<void> updateWorkout(WorkoutModel workout);
}

const String kWorkoutBox = 'workout_box';

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  final Box<WorkoutModel> workoutBox;

  WorkoutLocalDataSourceImpl(this.workoutBox);

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      return workoutBox.values.toList();
    } catch (e) {
      throw const CacheFailure('Failed to load local workouts');
    }
  }

  @override
  Future<void> cacheWorkout(WorkoutModel workout) async {
    await workoutBox.put(workout.id, workout);
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await workoutBox.delete(id);
  }

  @override
  Future<void> updateWorkout(WorkoutModel workout) async {
    await workoutBox.put(workout.id, workout);
  }
}
