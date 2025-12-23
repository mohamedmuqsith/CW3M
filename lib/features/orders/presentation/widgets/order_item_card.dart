import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order.dart';

class OrderItemCard extends StatelessWidget {
  final OrderEntity order;

  const OrderItemCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const Divider(height: 24),
            _buildItemsList(),
            const Divider(height: 24),
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMM dd, yyyy - hh:mm a').format(order.timestamp),
          style: theme.textTheme.titleSmall,
        ),
        _buildSyncStatusIndicator(theme),
      ],
    );
  }

  Widget _buildSyncStatusIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: order.isSynced ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            order.isSynced ? Icons.cloud_done : Icons.cloud_upload,
            size: 14,
            color: order.isSynced ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            order.isSynced ? 'Synced' : 'Offline',
            style: TextStyle(
              color: order.isSynced ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: order.items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${item.quantity}x ${item.foodName}'),
            Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total Amount', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(
          '\$${order.totalPrice.toStringAsFixed(2)}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
