import 'package:hive_flutter/hive_flutter.dart';
import '../../features/food/data/models/food_model.dart';
import '../../features/food/data/models/category_model.dart';
import '../../features/orders/data/models/order_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(FoodModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(OrderModelAdapter());

    // Open Boxes
    await Hive.openBox('foodBox');
    await Hive.openBox('favoritesBox');
    await Hive.openBox('ordersBox');
  }
}
