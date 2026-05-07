// ==========================================
// widgets/app_drawer.dart
// ==========================================
import 'package:flutter/material.dart';
// تم حذف مكتبة google_fonts لزيادة سرعة استجابة القائمة الجانبية
import '../screens/settings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF131313),
      child: Column(
        children: [
          const SizedBox(height: 60),

          // 1. قسم "About Us"
          _buildDrawerItem(
            context: context,
            icon: Icons.info_outline_rounded,
            label: 'About Us',
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),

          // 2. قسم "Staff"
          _buildDrawerItem(
            context: context,
            icon: Icons.people_outline_rounded,
            label: 'Staff',
            onTap: () => Navigator.of(context).pushNamed('/profile'),
          ),

          // 3. قسم "Settings"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white38,
                  size: 22
              ),
              title: const Text(
                  'SETTINGS',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      letterSpacing: 0.8
                  )
              ),
              onTap: () {
                Navigator.pop(context); // إغلاق الـ Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),

          const Spacer(),

          // زر تسجيل الخروج
          _buildLogoutButton(context),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    bool isSubItem = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSubItem ? 32 : 16, vertical: 4),
      child: Container(
        decoration: isActive
            ? BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6BFE9C), Color(0xFF1FC46A)]),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(icon, color: isActive ? const Color(0xFF005F2F) : Colors.white38, size: 22),
          title: Text(
            label.toUpperCase(),
            style: TextStyle(
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'LOG OUT',
              style: TextStyle(
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