// ==========================================
// widgets/category_selector.dart
// ==========================================
import 'package:flutter/material.dart';
import '../models/menu_models.dart';
import '../theme/app_theme.dart';

class CategorySelector extends StatelessWidget {
  final List<MenuCategory> categories;
  final String selectedId;
  final Function(String) onSelect;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final active = cat.id == selectedId;

          return GestureDetector(
            onTap: () => onSelect(cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  gradient: active ? AppGradients.primaryCta : null,
                  color: active ? null : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(100)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                      cat.icon,
                      size: 16,
                      color: active ? AppColors.onPrimary : AppColors.onSurfaceVariant
                  ),
                  const SizedBox(width: 8),
                  Text(
                      cat.label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: active ? AppColors.onPrimary : AppColors.onSurface
                      )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}