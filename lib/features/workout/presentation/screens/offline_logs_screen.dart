import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_workout_card.dart';

class OfflineLogsScreen extends ConsumerWidget {
  const OfflineLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Logs')),
      body: workoutState.when(
        data: (workouts) {
          final offlineWorkouts = workouts.where((w) => !w.isSynced).toList();
          if (offlineWorkouts.isEmpty) {
            return const Center(child: Text("No offline logs pending sync."));
          }
          return ListView.builder(
            itemCount: offlineWorkouts.length,
            itemBuilder: (context, index) {
              final workout = offlineWorkouts[index];
              return CustomWorkoutCard(
                workout: workout,
                onTap: () {}, // Just view
                onDelete: () {
                  ref
                      .read(workoutListProvider.notifier)
                      .deleteWorkout(workout.id);
                },
              );
            },
          );
        },
        error: (e, s) => Center(child: Text("Error: $e")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(workoutRepositoryProvider).syncWorkouts().then((_) {
            if (context.mounted) {
              ref.read(workoutListProvider.notifier).getWorkouts();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync attempted')),
              );
            }
          });
        },
        label: const Text("Sync All"),
        icon: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
