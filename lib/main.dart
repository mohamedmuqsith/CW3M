import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'core/utils/app_theme.dart';
import 'features/workout/presentation/screens/workout_list_screen.dart';
import 'features/workout/data/models/workout_model.dart';
import 'features/workout/data/models/exercise_model.dart';
import 'features/workout/data/datasources/workout_local_datasource.dart'; // for kWorkoutBox constant

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // Initialize Hive (Local Database)
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutModelAdapter());
  Hive.registerAdapter(ExerciseModelAdapter());
  await Hive.openBox<WorkoutModel>(kWorkoutBox);

  runApp(const ProviderScope(child: FitnessApp()));
}

class FitnessApp extends ConsumerWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Health & Fitness Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WorkoutListScreen(),
    );
  }
}
