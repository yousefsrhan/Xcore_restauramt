import 'package:flutter/material.dart';

// نموذج التصنيف: يتم إنشاؤه لحظياً بناءً على بيانات الداتابيز
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

  // تحويل البيانات من Firestore
  factory MenuItem.fromMap(String docId, Map<String, dynamic> map) {
    return MenuItem(
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
}

// ── المحرك الديناميكي للتصنيفات ──
class MenuUtils {

  static List<MenuCategory> generateDynamicCategories(List<MenuItem> allItems) {
    // 1. استخراج كل الكلمات الفريدة من حقل category في الداتابيز
    final categoryNames = allItems.map((item) => item.categoryId).toSet().toList();

    // 2. تحويل كل كلمة إلى "مربع" (MenuCategory)
    List<MenuCategory> dynamicCategories = categoryNames.map((name) {
      return MenuCategory(
        id: name,
        label: name,
        icon: _getIconForCategory(name), // تم تفعيل الاستدعاء
      );
    }).toList();

    // 3. إضافة مربع "الكل" في البداية
    dynamicCategories.insert(
      0,
      const MenuCategory(id: 'all', label: 'الكل', icon: Icons.grid_view_rounded),
    );

    return dynamicCategories;
  }

  // تم إلغاء التعليق وإضافتها كـ static لتصحيح الخطأ
  static IconData _getIconForCategory(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('pizza') || name.contains('بيتزا')) {
      return Icons.local_pizza_rounded;
    }
    if (name.contains('burger') || name.contains('برجر')) {
      return Icons.lunch_dining_rounded;
    }
    if (name.contains('juice') || name.contains('عصير')) {
      return Icons.local_drink_rounded;
    }
    if (name.contains('shawarma') || name.contains('شاورما')) {
      return Icons.kebab_dining_rounded;
    }
    if (name.contains('broast') || name.contains('بروست')) {
      return Icons.set_meal_rounded;
    }
    if (name.contains('dessert') || name.contains('حلو')) {
      return Icons.icecream_rounded;
    }

    // أيقونة افتراضية لأي قسم غير معروف
    return Icons.fastfood_rounded;
  }
}