import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_workout_card.dart';
import 'add_workout_screen.dart';
import 'workout_details_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../nutrition/presentation/screens/meal_log_screen.dart';
import '../../../analytics/presentation/widgets/progress_chart.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Fitness User'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Workouts'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Nutrition & Meal Logs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MealLogScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                ref.read(authRepositoryProvider).signOut();
                // AuthState change will redirect to Login
              },
            ),
          ],
        ),
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
          return Column(
            children: [
              SizedBox(
                height: 200,
                child: ProgressChart(workouts: workouts),
              ),
              Expanded(
                child: ListView.builder(
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
                            builder: (_) =>
                                WorkoutDetailsScreen(workout: workout),
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
                ),
              ),
            ],
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
