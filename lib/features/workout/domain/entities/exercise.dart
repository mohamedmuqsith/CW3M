import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String name;
  final int sets;
  final int reps;
  final double weight; // in kg
  final int durationSeconds; // Optional

  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight = 0.0,
    this.durationSeconds = 0,
  });

  @override
  List<Object?> get props => [name, sets, reps, weight, durationSeconds];
}
