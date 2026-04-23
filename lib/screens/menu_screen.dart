import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/cart_provider.dart';
import '../models/menu_models.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/customize_sheet.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/category_selector.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // نغير النوع لـ String لنخزن اسم القسم المختار بدلاً من رقمه
  String _selectedCategory = 'all';

  void _openSheetFromFirebase(Map<String, dynamic> data, String id) {
    final menuItem = MenuItem.fromMap(id, data);
    showCustomizeSheet(context, prefillItem: _toCartItem(menuItem));
  }

  CartItem _toCartItem(MenuItem m) => CartItem(
    id: m.id, name: m.name, category: m.categoryId.toUpperCase(),
    description: m.description, detail: m.chips.isNotEmpty ? m.chips.first : '',
    imageUrl: m.imageUrl, unitPrice: m.price,
  );

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      drawer: const AppDrawer(),
      appBar: _buildAppBar(cart.totalCount),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('خطأ في الاتصال'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data!.docs;

          // تحويل جميع المستندات إلى قائمة من الموديل
          final allItems = allDocs.map((doc) =>
              MenuItem.fromMap(doc.id, doc.data() as Map<String, dynamic>)
          ).toList();

          // ── توليد التصنيفات ديناميكياً من البيانات ──
          final dynamicCategories = MenuUtils.generateDynamicCategories(allItems);

          // تصفية العناصر بناءً على الاختيار
          final filteredItems = _selectedCategory == 'all'
              ? allItems
              : allItems.where((item) => item.categoryId == _selectedCategory).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. شريط التصنيفات الديناميكي
              SliverToBoxAdapter(
                child: CategorySelector(
                  // نمرر القائمة الديناميكية بدلاً من الثابتة
                  categories: dynamicCategories,
                  selectedId: _selectedCategory,
                  onSelect: (id) => setState(() => _selectedCategory = id),
                ),
              ),

              // 2. عنوان القسم
              SliverToBoxAdapter(child: _buildSectionTitle(_selectedCategory)),

              // 3. قائمة العناصر المصفاة
              filteredItems.isEmpty
                  ? _buildEmptyState()
                  : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList.separated(
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final item = filteredItems[i];
                    return MenuItemCard(
                      item: item,
                      onTap: () => _openSheetFromFirebase(
                          allDocs.firstWhere((d) => d.id == item.id).data() as Map<String, dynamic>,
                          item.id
                      ),
                      onAdd: () {
                        HapticFeedback.lightImpact();
                        CartProvider.read(context).addItem(_toCartItem(item));
                        _showSuccessSnackBar(item.name);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  // ── التعديلات في التنسيقات المساعدة ──

  Widget _buildSectionTitle(String categoryId) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        categoryId == 'all' ? 'قائمة الطعام كاملة' : categoryId.toUpperCase(),
        style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.6
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int count) => AppBar(
    backgroundColor: AppColors.background,
    automaticallyImplyLeading: false,
    leading: Builder(builder: (context) => IconButton(
      icon: const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24),
      onPressed: () => Scaffold.of(context).openDrawer(),
    )),
    title: Text('XCORE', style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF2ECC71))),
    actions: [_buildCartBtn(count), _buildProfileBtn()],
  );

  Widget _buildEmptyState() => const SliverToBoxAdapter(child: Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(child: Text('لا توجد عناصر في هذا القسم'))));

  Widget _buildCartBtn(int count) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => Navigator.of(context).pushNamed('/orders')));

  Widget _buildProfileBtn() => Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(onTap: () => Navigator.of(context).pushNamed('/profile'), child: const CircleAvatar(radius: 18, child: Icon(Icons.person_rounded, size: 20))));

  void _showSuccessSnackBar(String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$name أُضيف للطلب'),
      backgroundColor: AppColors.primary,
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ));
  }
}