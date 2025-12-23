import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../../../core/network/network_info.dart';
import '../../data/datasources/workout_local_datasource.dart';
import '../../data/datasources/workout_remote_datasource.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';

// Dependencies
final connectivityProvider = Provider((ref) => Connectivity());
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final hiveBoxProvider = Provider<Box<WorkoutModel>>((ref) {
  // Box should be opened before accessing this provider in main
  return Hive.box<WorkoutModel>(kWorkoutBox);
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.read(connectivityProvider));
});

final workoutLocalDataSourceProvider = Provider<WorkoutLocalDataSource>((ref) {
  return WorkoutLocalDataSourceImpl(ref.read(hiveBoxProvider));
});

final workoutRemoteDataSourceProvider =
    Provider<WorkoutRemoteDataSource>((ref) {
  return WorkoutRemoteDataSourceImpl(ref.read(firestoreProvider));
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepositoryImpl(
    remoteDataSource: ref.read(workoutRemoteDataSourceProvider),
    localDataSource: ref.read(workoutLocalDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// State
final workoutListProvider =
    StateNotifierProvider<WorkoutListNotifier, AsyncValue<List<Workout>>>(
        (ref) {
  return WorkoutListNotifier(ref.read(workoutRepositoryProvider));
});

class WorkoutListNotifier extends StateNotifier<AsyncValue<List<Workout>>> {
  final WorkoutRepository repository;

  WorkoutListNotifier(this.repository) : super(const AsyncValue.loading()) {
    getWorkouts();
  }

  Future<void> getWorkouts() async {
    state = const AsyncValue.loading();
    final result = await repository.getWorkouts();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (workouts) => state = AsyncValue.data(workouts),
    );
  }

  Future<void> addWorkout(Workout workout) async {
    final result = await repository.addWorkout(workout);
    result.fold(
      (failure) {}, // Handle error
      (_) => getWorkouts(), // Refresh list
    );
  }

  Future<void> deleteWorkout(String id) async {
    await repository.deleteWorkout(id);
    getWorkouts();
  }
}
