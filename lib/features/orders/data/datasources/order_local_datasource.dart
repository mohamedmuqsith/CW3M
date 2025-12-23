import 'package:hive_flutter/hive_flutter.dart';
import '../models/order_model.dart';

class OrderLocalDataSource {
  final Box orderBox;

  OrderLocalDataSource(this.orderBox);

  Future<void> saveOrder(OrderModel order) async {
    await orderBox.put(order.id, order); // id as key
  }

  List<OrderModel> getOrders() {
    return orderBox.values.cast<OrderModel>().toList();
  }
  
  List<OrderModel> getPendingOrders() {
    return getOrders().where((o) => !o.isSynced).toList();
  }

  Future<void> markAsSynced(String orderId) async {
    final order = orderBox.get(orderId) as OrderModel?;
    if (order != null) {
      final syncedOrder = OrderModel(
        id: order.id,
        itemsJson: order.itemsJson,
        totalPrice: order.totalPrice,
        timestamp: order.timestamp,
        isSynced: true,
        status: order.status,
      );
      await orderBox.put(orderId, syncedOrder);
    }
  }
}
