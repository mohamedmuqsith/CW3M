import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_theme.dart';
import '../providers/nutrition_provider.dart';
import '../../data/models/meal_model.dart';
import 'package:uuid/uuid.dart';

class MealLogScreen extends ConsumerWidget {
  const MealLogScreen({super.key});

  void _showAddMealDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: caloriesController,
                decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: proteinController,
                      decoration:
                          const InputDecoration(labelText: 'Protein (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: carbsController,
                      decoration: const InputDecoration(labelText: 'Carbs (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: fatsController,
                      decoration: const InputDecoration(labelText: 'Fats (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final meal = MealModel(
                id: const Uuid().v4(),
                name: nameController.text,
                calories: double.tryParse(caloriesController.text) ?? 0,
                protein: double.tryParse(proteinController.text) ?? 0,
                carbs: double.tryParse(carbsController.text) ?? 0,
                fats: double.tryParse(fatsController.text) ?? 0,
                timestamp: DateTime.now(),
              );
              ref.read(nutritionProvider.notifier).addMeal(meal);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final displayDate = DateTime.now(); // Simplified to today for now
    final nutritionState = ref.watch(nutritionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Log'),
      ),
      body: nutritionState.when(
        data: (meals) {
          final totalCalories =
              meals.fold(0.0, (sum, item) => sum + item.calories);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Calories:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${totalCalories.toStringAsFixed(0)} kcal',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return ListTile(
                      title: Text(meal.name),
                      subtitle: Text(
                          'P: ${meal.protein}g  C: ${meal.carbs}g  F: ${meal.fats}g'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${meal.calories.toStringAsFixed(0)} kcal'),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              ref
                                  .read(nutritionProvider.notifier)
                                  .deleteMeal(meal.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealDialog(context, ref),
        label: const Text('Log Meal'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
