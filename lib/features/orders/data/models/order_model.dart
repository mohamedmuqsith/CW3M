import 'package:hive/hive.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderModel extends OrderEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<Map<String, dynamic>> itemsJson; // Hive doesn't like custom objects easily without adapters, using JSON map for simplicity or we need OrderItemAdapter.
  // Actually, I'll use a wrapper or just simple Map List.
  @HiveField(2)
  final double totalPrice;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final bool isSynced;
  @HiveField(5)
  final String status;

  OrderModel({
    required this.id,
    required this.itemsJson,
    required this.totalPrice,
    required this.timestamp,
    required this.isSynced,
    required this.status,
  }) : super(
          id: id,
          items: itemsJson.map((e) => OrderItem.fromJson(e)).toList(),
          totalPrice: totalPrice,
          timestamp: timestamp,
          isSynced: isSynced,
          status: status,
        );
        
  factory OrderModel.fromEntity(OrderEntity order) {
    return OrderModel(
      id: order.id,
      itemsJson: order.items.map((e) => e.toJson()).toList(),
      totalPrice: order.totalPrice,
      timestamp: order.timestamp,
      isSynced: order.isSynced,
      status: order.status,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'items': itemsJson,
      'totalPrice': totalPrice,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
