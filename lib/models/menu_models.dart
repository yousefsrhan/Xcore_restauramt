import 'package:flutter/material.dart';

class MenuCategory {
  final String id;
  final String label;
  final IconData icon;

  const MenuCategory({required this.id, required this.label, required this.icon});
}

class MenuItem {
  final String id, name, description, imageUrl, categoryId;
  final double price;
  final List<String> chips;
  final bool isFeatured;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.chips = const [],
    this.isFeatured = false,
  });

  factory MenuItem.fromMap(String docId, Map<String, dynamic> map) => MenuItem(
    id: docId,
    name: map['name'] ?? 'بدون اسم',
    description: map['description'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    imageUrl: map['imageUrl'] ?? '',
    categoryId: map['category'] ?? 'عام',
    isFeatured: map['isFeatured'] ?? false,
    chips: map['chips'] != null ? List<String>.from(map['chips']) : [],
  );
}

class MenuUtils {
  static const _allCategory = MenuCategory(
    id: 'all',
    label: 'all',
    icon: Icons.grid_view_rounded,
  );

  static List<MenuCategory> generateDynamicCategories(List<MenuItem> allItems) => [
    _allCategory,
    ...allItems.map((item) => item.categoryId).toSet().map(
      (name) => MenuCategory(id: name, label: name, icon: _getIconForCategory(name)),
    ),
  ];

  static IconData _getIconForCategory(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('pizza') || name.contains('بيتزا')) return Icons.local_pizza_rounded;
    if (name.contains('burger') || name.contains('برجر')) return Icons.lunch_dining_rounded;
    if (name.contains('juice') || name.contains('عصير')) return Icons.local_drink_rounded;
    if (name.contains('shawarma') || name.contains('شاورما')) return Icons.kebab_dining_rounded;
    if (name.contains('broast') || name.contains('بروست')) return Icons.set_meal_rounded;
    if (name.contains('dessert') || name.contains('حلو')) return Icons.icecream_rounded;

    return Icons.fastfood_rounded;
  }
}
