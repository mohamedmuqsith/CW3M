import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime timestamp;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.timestamp,
  });

  @override
  List<Object?> get props =>
      [id, name, calories, protein, carbs, fats, timestamp];
}
