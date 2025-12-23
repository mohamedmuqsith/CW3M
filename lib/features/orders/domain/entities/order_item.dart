class OrderItem {
  final String foodId;
  final String foodName;
  final double price;
  final int quantity;

  const OrderItem({
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodId: json['foodId'],
      foodName: json['foodName'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }
}
