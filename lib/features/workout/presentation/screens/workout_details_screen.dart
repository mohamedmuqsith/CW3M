import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/workout.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(icon: Icons.calendar_today, label: DateFormat('EEEE, MMM d, y').format(workout.date)),
              _DetailRow(icon: Icons.timer, label: '${workout.durationMinutes} Minutes'),
              _DetailRow(icon: Icons.local_fire_department, label: '${workout.caloriesBurned} Calories'),
              const SizedBox(height: 20),
              const Text(
                'Exercises',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...workout.exercises.map((ex) => ListTile(
                leading: CircleAvatar(child: Text('${ex.sets}')),
                title: Text(ex.name),
                subtitle: Text('${ex.reps} reps ${ex.weight > 0 ? '@ ${ex.weight}kg' : ''}'),
              )),
              if (workout.exercises.isEmpty)
                const Text("No specific exercises logged.")
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
