import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF131313), // لون الخلفية الداكن الموحد
      child: Column(
        children: [
          // ترويسة البروفايل (Julian V.)
          _buildHeader(),

          const SizedBox(height: 20),

          // أزرار التنقل
          _buildDrawerItem(
            context: context,
            icon: Icons.history_rounded,
            label: 'Orders History',
            onTap: () => Navigator.pushNamed(context, '/orders-history'),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.receipt_long_rounded,
            label: 'Active Orders',
            onTap: () => Navigator.pushNamed(context, '/orders'),
            isActive: true, // تمييز الزر النشط بالأخضر
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.restaurant_menu_rounded,
            label: 'Menu Editor',
            onTap: () => Navigator.pushNamed(context, '/menu-editor'),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.analytics_outlined,
            label: 'Analytics',
            onTap: () => Navigator.pushNamed(context, '/analytics'),
          ),

          const Spacer(),

          // تنبيه المخزون (اختياري كما في التصميم الأصلي)
          _buildInventoryAlert(),

          // زر تسجيل الخروج في الأسفل
          _buildLogoutButton(context),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- ميثود بناء الزر المعدلة (تم حل مشكلة الـ decoration) ---
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        // حل المشكلة: وضعنا الـ decoration هنا في الـ Container
        decoration: isActive
            ? BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6BFE9C), Color(0xFF1FC46A)],
          ),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(
            icon,
            color: isActive ? const Color(0xFF005F2F) : Colors.white38,
            size: 22,
          ),
          title: Text(
            label.toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              color: isActive ? const Color(0xFF005F2F) : Colors.white70,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  // ترويسة البروفايل
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2ECC71), width: 2),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF1E1E1E),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Julian V.',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'LEAD SOMMELIER',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // تنبيه بسيط للمخزون كما ظهر في كود الـ HTML
  Widget _buildInventoryAlert() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('INVENTORY ALERT',
                  style: GoogleFonts.manrope(
                      fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                child: Text('3 LOW', style: GoogleFonts.manrope(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Barolo '18 stock is critically low.",
              style: GoogleFonts.manrope(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  // زر تسجيل الخروج
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C2C2C),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'CLOCK OUT',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}