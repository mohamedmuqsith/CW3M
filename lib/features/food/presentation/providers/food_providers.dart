import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/local/hive_service.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/constants.dart';
import '../../data/datasources/food_local_datasource.dart';
import '../../data/datasources/food_remote_datasource.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/usecases/food_usecases.dart';

// --- Core Providers ---

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final hiveBoxProvider = Provider((ref) => Hive.box(AppConstants.foodBox));

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.read(connectivityProvider));
});

// --- Data Sources ---

final foodLocalDataSourceProvider = Provider<FoodLocalDataSource>((ref) {
  return FoodLocalDataSourceImpl(foodBox: ref.read(hiveBoxProvider));
});

final foodRemoteDataSourceProvider = Provider<FoodRemoteDataSource>((ref) {
  return FoodRemoteDataSourceImpl(firestore: ref.read(firestoreProvider));
});

// --- Repository ---

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(
    localDataSource: ref.read(foodLocalDataSourceProvider),
    remoteDataSource: ref.read(foodRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// --- Use Cases ---

final getCategoriesProvider = Provider((ref) => GetCategories(ref.read(foodRepositoryProvider)));
final getFoodsByCategoryProvider = Provider((ref) => GetFoodsByCategory(ref.read(foodRepositoryProvider)));
final addFoodProvider = Provider((ref) => AddFood(ref.read(foodRepositoryProvider)));
final updateFoodProvider = Provider((ref) => UpdateFood(ref.read(foodRepositoryProvider)));
final deleteFoodProvider = Provider((ref) => DeleteFood(ref.read(foodRepositoryProvider)));

// --- State Providers ---

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(getCategoriesProvider).call();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final foodsByCategoryProvider = FutureProvider.family<List<Food>, String>((ref, categoryId) async {
  return ref.read(getFoodsByCategoryProvider).call(categoryId);
});
