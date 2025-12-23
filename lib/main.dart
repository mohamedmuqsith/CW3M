import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/local/hive_service.dart';
import 'core/utils/app_theme.dart';
import 'features/food/presentation/screens/home_screen.dart';
import 'firebase_options.dart';
import 'core/utils/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await HiveService.init();

  // Initialize Firebase with platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("Firebase initialized successfully");

    // TEMPORARY: Seed demo data
    // Remove this line after first run/verification
    await DataSeeder.seedData();
  } catch (e) {
    log("Firebase initialization failed: $e");
    // App will continue but Firebase features won't work
  }

  runApp(
    const ProviderScope(
      child: SmartFoodApp(),
    ),
  );
}

class SmartFoodApp extends StatelessWidget {
  const SmartFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Food Ordering',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
