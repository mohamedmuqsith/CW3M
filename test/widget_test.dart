// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_food_ordering_nutrition_assistant/main.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/workout/presentation/providers/workout_provider.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/workout/domain/repositories/workout_repository.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/workout/domain/entities/workout.dart';
import 'package:smart_food_ordering_nutrition_assistant/core/error/failures.dart';

// Mock Repository
class MockWorkoutRepository implements WorkoutRepository {
  @override
  Future<Either<Failure, List<Workout>>> getWorkouts() async {
    // Return empty list to simulate no workouts initially
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> addWorkout(Workout workout) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateWorkout(Workout workout) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteWorkout(String id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> syncWorkouts() async {
    return const Right(null);
  }
}

void main() {
  testWidgets('Fitness App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Wrap FitnessApp in ProviderScope with overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(MockWorkoutRepository()),
        ],
        child: const FitnessApp(),
      ),
    );

    // Pump to allow the Future in the provider to resolve and rebuild the UI
    await tester.pumpAndSettle();

    // Verify that our app starts with the Workout List screen.
    expect(find.text('My Workouts'), findsOneWidget);

    // The default screen says "No workouts yet. Add one!" when empty
    expect(find.text('No workouts yet. Add one!'), findsOneWidget);

    // Ensure '0' is not found (from the default flutter counter app test)
    expect(find.text('0'), findsNothing);
  });
}
