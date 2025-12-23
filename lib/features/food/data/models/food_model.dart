import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/food.dart';

part 'food_model.g.dart';

@HiveType(typeId: 0)
class FoodModel extends Food {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String categoryId;
  @HiveField(5)
  final String imageUrl;
  @HiveField(6)
  final int calories;
  @HiveField(7)
  final int protein;
  @HiveField(8)
  final int carbs;
  @HiveField(9)
  final int fat;
  @HiveField(10)
  final bool isAvailable;

  const FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isAvailable = true,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          categoryId: categoryId,
          imageUrl: imageUrl,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          isAvailable: isAvailable,
        );

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      imageUrl: json['imageUrl'] as String,
      calories: json['calories'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fat: json['fat'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  factory FoodModel.fromEntity(Food food) {
    return FoodModel(
      id: food.id,
      name: food.name,
      description: food.description,
      price: food.price,
      categoryId: food.categoryId,
      imageUrl: food.imageUrl,
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      isAvailable: food.isAvailable,
    );
  }

  factory FoodModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'isAvailable': isAvailable,
    };
  }
}
