import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: category.imageUrl.isNotEmpty
                  ? (category.imageUrl.startsWith('http')
                      ? NetworkImage(category.imageUrl)
                      : AssetImage(category.imageUrl) as ImageProvider)
                  : null,
              child: category.imageUrl.isEmpty
                  ? const Icon(Icons.fastfood, size: 20, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
