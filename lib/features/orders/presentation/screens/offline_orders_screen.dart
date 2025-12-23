import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/order_providers.dart';
import '../widgets/order_item_card.dart';

class OfflineOrdersScreen extends ConsumerWidget {
  const OfflineOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.read(orderListProvider.notifier).syncOrders();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Syncing...')));
            },
          )
        ],
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders found', style: theme.textTheme.bodyLarge))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderItemCard(order: orders[index]);
              },
            ),
    );
  }
}
