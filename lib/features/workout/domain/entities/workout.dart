import 'package:equatable/equatable.dart';
import 'exercise.dart';

class Workout extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final int durationMinutes;
  final double caloriesBurned;
  final List<Exercise> exercises;
  final bool isSynced;

  const Workout({
    required this.id,
    required this.title,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.exercises,
    this.isSynced = false,
  });

  @override
  List<Object?> get props =>
      [id, title, date, durationMinutes, caloriesBurned, exercises, isSynced];
}
