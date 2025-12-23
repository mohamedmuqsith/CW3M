import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../../features/food/data/models/food_model.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedData() async {
    try {
      log('Starting data seeding...');

      // Check if data already exists to avoid duplicates/overwrites (optional, but good practice)
      // For this demo request, we'll just overwrite/merge.

      final batch = _firestore.batch();

      // --- Categories ---
      final categories = [
        {
          'id': '1',
          'name': 'Burger',
          'imageUrl':
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
        },
        {
          'id': '2',
          'name': 'Pizza',
          'imageUrl':
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&q=80',
        },
        {
          'id': '3',
          'name': 'Salad',
          'imageUrl':
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80',
        },
        {
          'id': '4',
          'name': 'Drinks',
          'imageUrl':
              'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&q=80',
        },
      ];

      for (var cat in categories) {
        final docRef = _firestore.collection('categories').doc(cat['id']);
        batch.set(docRef, cat);
      }

      // --- Food Items ---
      final foods = [
        FoodModel(
          id: 'f1',
          name: 'Classic Cheeseburger',
          description:
              'Juicy beef patty with cheddar cheese, lettuce, tomato, and house sauce.',
          price: 12.99,
          categoryId: '1',
          imageUrl:
              'https://img.freepik.com/free-photo/delicious-burger-with-fresh-ingredients_23-2150857908.jpg',
          calories: 850,
          protein: 45,
          carbs: 50,
          fat: 55,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f2',
          name: 'Veggie Supreme Burger',
          description:
              'Plant-based patty with avocado, sprouts, and vegan mayo.',
          price: 14.50,
          categoryId: '1',
          imageUrl:
              'https://img.freepik.com/free-photo/front-view-burger-stand_141793-15542.jpg',
          calories: 620,
          protein: 25,
          carbs: 65,
          fat: 30,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f3',
          name: 'Margherita Pizza',
          description: 'Classic tomato and mozzarella pizza with fresh basil.',
          price: 10.99,
          categoryId: '2',
          imageUrl:
              'https://img.freepik.com/free-photo/freshly-baked-pizza-rustic-wooden-table_23-2149489673.jpg',
          calories: 1200,
          protein: 40,
          carbs: 140,
          fat: 50,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f4',
          name: 'Pepperoni Feast',
          description: 'Loaded with pepperoni slices and extra cheese.',
          price: 13.99,
          categoryId: '2',
          imageUrl:
              'https://img.freepik.com/free-photo/pizza-time-tasty-homemade-traditional-pizza-italian-recipe_144627-42528.jpg',
          calories: 1450,
          protein: 55,
          carbs: 140,
          fat: 75,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f5',
          name: 'Caesar Salad',
          description:
              'Crisp romaine lettuce, croutons, parmesan, and caesar dressing.',
          price: 8.99,
          categoryId: '3',
          imageUrl:
              'https://img.freepik.com/free-photo/fresh-salad-with-vegetables_23-2148057211.jpg',
          calories: 350,
          protein: 12,
          carbs: 20,
          fat: 28,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f6',
          name: 'Greek Salad',
          description: 'Cucumber, tomato, onions, olives, and feta cheese.',
          price: 9.50,
          categoryId: '3',
          imageUrl:
              'https://img.freepik.com/free-photo/greek-salad-with-fresh-vegetables-feta-cheese-kalamata-olives_2829-19694.jpg',
          calories: 320,
          protein: 10,
          carbs: 15,
          fat: 25,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f7',
          name: 'Cola',
          description: 'Chilled classic cola.',
          price: 2.50,
          categoryId: '4',
          imageUrl:
              'https://img.freepik.com/free-photo/fresh-cola-drink-glass_144627-16201.jpg',
          calories: 140,
          protein: 0,
          carbs: 39,
          fat: 0,
          isAvailable: true,
        ),
        FoodModel(
          id: 'f8',
          name: 'Fresh Orange Juice',
          description: 'Freshly squeezed orange juice.',
          price: 4.50,
          categoryId: '4',
          imageUrl:
              'https://img.freepik.com/free-photo/glass-orange-juice-placed-wood_1150-9670.jpg',
          calories: 110,
          protein: 2,
          carbs: 26,
          fat: 0,
          isAvailable: true,
        ),
      ];

      for (var food in foods) {
        final docRef = _firestore.collection('foods').doc(food.id);
        batch.set(docRef, food.toJson());
      }

      await batch.commit();
      log('Data seeding completed successfully!');
    } catch (e) {
      log('Error seeding data: $e');
    }
  }
}
