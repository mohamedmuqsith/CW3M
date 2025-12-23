import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_workout_card.dart';
import 'add_workout_screen.dart';
import 'workout_details_screen.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.read(workoutRepositoryProvider).syncWorkouts().then((_) {
                if (context.mounted) {
                  ref.read(workoutListProvider.notifier).getWorkouts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync completed')),
                  );
                }
              });
            },
          )
        ],
      ),
      body: workoutState.when(
        data: (workouts) {
          if (workouts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No workouts yet. Add one!'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: workouts.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return CustomWorkoutCard(
                workout: workout,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutDetailsScreen(workout: workout),
                    ),
                  );
                },
                onDelete: () {
                  ref
                      .read(workoutListProvider.notifier)
                      .deleteWorkout(workout.id);
                },
              );
            },
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWorkoutScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
