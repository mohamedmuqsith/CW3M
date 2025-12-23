import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/exercise.dart';
import '../providers/workout_provider.dart';

class AddWorkoutScreen extends ConsumerStatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  ConsumerState<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends ConsumerState<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  
  // Simple exercises list for demo
  final List<Exercise> _exercises = [];

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        id: const Uuid().v4(),
        title: _titleController.text,
        date: DateTime.now(),
        durationMinutes: int.parse(_durationController.text),
        caloriesBurned: double.parse(_caloriesController.text),
        exercises: _exercises, // Empty for now or add exercise logic
      );

      ref.read(workoutListProvider.notifier).addWorkout(workout);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Workout Title (e.g. Leg Day)'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                   Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(labelText: 'Duration (min)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Exercise addition can be complex, simplifying for MVP
              const Text("Exercises (Simple Demo)"),
              Expanded(
                child: ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final ex = _exercises[index];
                    return ListTile(
                      title: Text(ex.name),
                      subtitle: Text('${ex.sets} sets x ${ex.reps} reps'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Mock adding an exercise
                  setState(() {
                    _exercises.add(const Exercise(name: "New Exercise", sets: 3, reps: 10));
                  });
                },
                child: const Text("Add Dummy Exercise"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveWorkout,
                  child: const Text('Save Workout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
