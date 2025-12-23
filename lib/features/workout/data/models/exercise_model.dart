import 'package:hive/hive.dart';
import '../../domain/entities/exercise.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 1)
class ExerciseModel extends Exercise {
  @override
  @HiveField(0)
  final String name;
  @override
  @HiveField(1)
  final int sets;
  @override
  @HiveField(2)
  final int reps;
  @override
  @HiveField(3)
  final double weight;
  @override
  @HiveField(4)
  final int durationSeconds;

  const ExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight = 0.0,
    this.durationSeconds = 0,
  }) : super(
          name: name,
          sets: sets,
          reps: reps,
          weight: weight,
          durationSeconds: durationSeconds,
        );

  factory ExerciseModel.fromEntity(Exercise exercise) {
    return ExerciseModel(
      name: exercise.name,
      sets: exercise.sets,
      reps: exercise.reps,
      weight: exercise.weight,
      durationSeconds: exercise.durationSeconds,
    );
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      weight: (json['weight'] ?? 0.0).toDouble(),
      durationSeconds: json['durationSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'durationSeconds': durationSeconds,
    };
  }
}
