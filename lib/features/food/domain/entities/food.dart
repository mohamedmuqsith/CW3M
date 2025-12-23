class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String imageUrl;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final bool isAvailable;

  const Food({
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
  });
}
