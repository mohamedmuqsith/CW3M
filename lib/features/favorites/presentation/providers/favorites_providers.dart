import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_food_ordering_nutrition_assistant/core/utils/constants.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/food/presentation/providers/food_providers.dart';
import 'package:smart_food_ordering_nutrition_assistant/features/food/domain/entities/food.dart';
import '../../data/repositories/favorites_repository.dart';

final favoritesBoxProvider =
    Provider((ref) => Hive.box(AppConstants.favoritesBox));

final favoritesRepositoryProvider = Provider((ref) {
  return FavoritesRepository(
    ref.read(favoritesBoxProvider),
    ref.read(foodRepositoryProvider),
  );
});

// Stream provider to listen to Hive changes for real-time updates
final favoritesStreamProvider =
    StreamProvider.autoDispose<List<Food>>((ref) async* {
  final repo = ref.read(favoritesRepositoryProvider);
  final box = ref.read(favoritesBoxProvider);

  // Initial emit
  yield await repo.getFavorites();

  // Listen to changes
  await for (final _ in box.watch()) {
    yield await repo.getFavorites();
  }
});

final isFavoriteProvider = Provider.family<bool, String>((ref, foodId) {
  // This is a bit tricky with StreamProvider, so we might just use the box directly for sync check in UI
  final box = ref.watch(favoritesBoxProvider);
  // To make it reactive, we need to listen to the box.
  // Ideally we use a ValueListenableBuilder or consume the stream.
  // But purely provider-based:
  // We can't watch a specific key easily in standard Riverpod without a specific notifier.
  // We'll let the UI use the repo method or check the list from favoritesStreamProvider.
  return box.containsKey(foodId);
});
