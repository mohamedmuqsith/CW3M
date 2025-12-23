import 'order_item.dart';

class OrderEntity {
  final String id;
  final List<OrderItem> items;
  final double totalPrice;
  final DateTime timestamp;
  final bool isSynced;
  final String status; // 'pending', 'completed', 'cancelled'

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.timestamp,
    this.isSynced = false,
    this.status = 'pending',
  });
}
