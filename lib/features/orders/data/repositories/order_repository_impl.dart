import 'dart:developer'; // For safe logging
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order.dart';
import '../datasources/order_local_datasource.dart';
import '../models/order_model.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl {
  final OrderLocalDataSource localDataSource;
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<void> createOrder(OrderEntity order) async {
    var orderModel = OrderModel.fromEntity(order);
    await localDataSource.saveOrder(orderModel);

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.syncOrder(orderModel);
        await localDataSource.markAsSynced(order.id);
      } catch (e) {
        log('Sync failed for order ${order.id}', error: e);
      }
    }
  }

  Future<void> syncPendingOrders() async {
    if (!await networkInfo.isConnected) return;

    final pending = localDataSource.getPendingOrders();
    if (pending.isEmpty) return;

    try {
      // Use batch sync for efficiency
      await remoteDataSource.syncOrdersBatch(pending);

      // Mark all as synced locally
      for (var order in pending) {
        await localDataSource.markAsSynced(order.id);
      }
    } catch (e) {
      log('Background batch sync failed', error: e);
    }
  }

  List<OrderEntity> getOrders() {
    final list = localDataSource.getOrders();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }
}
