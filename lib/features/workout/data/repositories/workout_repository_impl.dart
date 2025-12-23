import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_datasource.dart';
import '../datasources/workout_remote_datasource.dart';
import '../models/workout_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource remoteDataSource;
  final WorkoutLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WorkoutRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Workout>>> getWorkouts() async {
    if (await networkInfo.isConnected) {
      try {
        await syncWorkouts(); // Try to sync pending items first
        final remoteWorkouts = await remoteDataSource.getWorkouts();
        // Cache them
        for (var workout in remoteWorkouts) {
          await localDataSource.cacheWorkout(workout);
        }
        return Right(remoteWorkouts);
      } catch (e) {
        // Fallback to local if remote fails
        try {
          final localWorkouts = await localDataSource.getWorkouts();
          return Right(localWorkouts);
        } catch (e) {
          return const Left(CacheFailure('No local data found'));
        }
      }
    } else {
      try {
        final localWorkouts = await localDataSource.getWorkouts();
        return Right(localWorkouts);
      } catch (e) {
        return const Left(CacheFailure('No local data found'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> addWorkout(Workout workout) async {
    try {
      if (await networkInfo.isConnected) {
        final model = WorkoutModel.fromEntity(workout).copyWith(isSynced: true);
        await remoteDataSource.addWorkout(model);
        await localDataSource.cacheWorkout(model);
      } else {
        final model =
            WorkoutModel.fromEntity(workout).copyWith(isSynced: false);
        await localDataSource.cacheWorkout(model);
      }
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to add workout'));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkout(Workout workout) async {
    try {
      if (await networkInfo.isConnected) {
        final model = WorkoutModel.fromEntity(workout).copyWith(isSynced: true);
        await remoteDataSource.updateWorkout(model);
        await localDataSource.updateWorkout(model);
      } else {
        final model =
            WorkoutModel.fromEntity(workout).copyWith(isSynced: false);
        await localDataSource.updateWorkout(model);
      }
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to update workout'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkout(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteWorkout(id);
        await localDataSource.deleteWorkout(id);
      } else {
        // Handling offline delete is tricky without a separate "deleted" queue.
        // For simplicity, we'll just delete locally. Sync might conflict later.
        // A robust solution would mark as 'deleted' and sync later.
        // We will just delete locally for now.
        await localDataSource.deleteWorkout(id);
      }
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to delete workout'));
    }
  }

  @override
  Future<Either<Failure, void>> syncWorkouts() async {
    try {
      final localWorkouts = await localDataSource.getWorkouts();
      final unsynced = localWorkouts.where((w) => !w.isSynced).toList();

      for (var workout in unsynced) {
        // Push to server
        final syncedWorkout = workout.copyWith(isSynced: true);
        await remoteDataSource.addWorkout(syncedWorkout); // Or update/set
        await localDataSource.cacheWorkout(syncedWorkout);
      }
      return const Right(null);
    } catch (e) {
      // Ignore sync errors silently usually, or log
      return const Left(ServerFailure('Sync failed'));
    }
  }
}

extension WorkoutModelCopy on WorkoutModel {
  WorkoutModel copyWith({bool? isSynced}) {
    return WorkoutModel(
      id: this.id,
      title: title,
      date: date,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      exercises: exercises,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
