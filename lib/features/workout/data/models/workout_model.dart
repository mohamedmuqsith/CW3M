import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/workout.dart';
import 'exercise_model.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
class WorkoutModel extends Workout {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final DateTime date;
  @override
  @HiveField(3)
  final int durationMinutes;
  @override
  @HiveField(4)
  final double caloriesBurned;
  @override
  @HiveField(5)
  final List<ExerciseModel> exercises;
  @override
  @HiveField(6)
  final bool isSynced;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.exercises,
    this.isSynced = false,
  }) : super(
          id: id,
          title: title,
          date: date,
          durationMinutes: durationMinutes,
          caloriesBurned: caloriesBurned,
          exercises: exercises,
          isSynced: isSynced,
        );

  factory WorkoutModel.fromEntity(Workout workout) {
    return WorkoutModel(
      id: workout.id,
      title: workout.title,
      date: workout.date,
      durationMinutes: workout.durationMinutes,
      caloriesBurned: workout.caloriesBurned,
      exercises:
          workout.exercises.map((e) => ExerciseModel.fromEntity(e)).toList(),
      isSynced: workout.isSynced,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json, String id) {
    return WorkoutModel(
      id: id,
      title: json['title'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      durationMinutes: json['durationMinutes'] ?? 0,
      caloriesBurned: (json['caloriesBurned'] ?? 0.0).toDouble(),
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseModel.fromJson(e))
              .toList() ??
          [],
      isSynced: true, // If coming from Firestore, it is synced
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
