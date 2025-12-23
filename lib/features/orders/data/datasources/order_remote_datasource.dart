import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/constants.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> syncOrder(OrderModel order);
  Future<void> syncOrdersBatch(List<OrderModel> orders);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> syncOrder(OrderModel order) async {
    await firestore.collection(AppConstants.ordersCollection).doc(order.id).set(order.toFirestore());
  }

  @override
  Future<void> syncOrdersBatch(List<OrderModel> orders) async {
    final batch = firestore.batch();
    for (var order in orders) {
      final docRef = firestore.collection(AppConstants.ordersCollection).doc(order.id);
      batch.set(docRef, order.toFirestore());
    }
    await batch.commit();
  }
}
