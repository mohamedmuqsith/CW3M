import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../../../food/presentation/providers/food_providers.dart';
import '../../domain/entities/order.dart';
import '../../data/datasources/order_local_datasource.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';

final orderBoxProvider = Provider((ref) => Hive.box(AppConstants.ordersBox));

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSourceImpl(firestore: ref.read(firestoreProvider));
});

final orderRepositoryProvider = Provider((ref) {
  return OrderRepositoryImpl(
    localDataSource: OrderLocalDataSource(ref.read(orderBoxProvider)),
    remoteDataSource: ref.read(orderRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// Notifier to manage orders list (since it's a mix of local reading and manual refreshing)
class OrderListNotifier extends StateNotifier<List<OrderEntity>> {
  final OrderRepositoryImpl repository;

  OrderListNotifier(this.repository) : super([]) {
    loadOrders();
  }

  void loadOrders() {
    state = repository.getOrders();
  }

  Future<void> createOrder(OrderEntity order) async {
    await repository.createOrder(order);
    loadOrders(); // Refresh state
  }

  Future<void> syncOrders() async {
    await repository.syncPendingOrders();
    loadOrders();
  }
}

final orderListProvider =
    StateNotifierProvider<OrderListNotifier, List<OrderEntity>>((ref) {
  return OrderListNotifier(ref.read(orderRepositoryProvider));
});
