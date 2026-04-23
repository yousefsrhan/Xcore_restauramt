import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_drawer.dart';

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          // 1. إضافة زر الـ Sidebar
          leadingWidth: 56,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          titleSpacing: 0,
          // 2. تغيير النص إلى XCORE
          title: Text(
            'XCORE',
            style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2ECC71),
                letterSpacing: 1.0),
          ),
        ),
        // 3. تأكد من إضافة الـ Drawer ليعمل الزر
        drawer: const AppDrawer(),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480), // ضبط الأبعاد للويب
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(),

              const SizedBox(height: 16),
              Text('Marcus V.', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 8),
              _buildTag('SENIOR WAITER', 'Floor Team Alpha'),

              const SizedBox(height: 32),
              // استدعاء الميثود بالبارامترات الصحيحة
              _buildInfoRow('SHIFT START', '5:00 PM', 'DURATION', '3h 12m', isGreen: true),
              const SizedBox(height: 16),
              _buildStatsGrid(),

              const SizedBox(height: 32),
              _buildActionTile(Icons.edit_note_rounded, 'End-of-Shift Notes'),
              const SizedBox(height: 12),
              _buildActionTile(Icons.assignment_turned_in_rounded, 'Shift Reconciliation'),

              const Spacer(),

              _buildLogoutButton(context), // زر تسجيل الخروج

              const SizedBox(height: 12),
              Text('TERMINAL ID: FLOOR-POS-01', style: GoogleFonts.manrope(fontSize: 10, color: Colors.white24)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  // --- ميثودات بناء الواجهة (UI Helpers) ---

  Widget _buildProfileImage() {
    return Container(
      width: 120, height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2ECC71), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTag(String role, String team) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: Text('$role • $team', style: GoogleFonts.manrope(fontSize: 12, color: Colors.white70)),
    );
  }

  // تصحيح تعريف البارامترات هنا
  Widget _buildInfoRow(String label1, String value1, String label2, String value2, {bool isGreen = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(label1, value1),
          _buildInfoItem(label2, value2, valueColor: isGreen ? const Color(0xFF2ECC71) : Colors.white),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color valueColor = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.manrope(fontSize: 18, color: valueColor, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.restaurant_menu_rounded, 'ORDERS SERVED', '28')),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.payments_outlined, 'NET SALES', '\$2,410')),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2ECC71), size: 24),
          const SizedBox(height: 16),
          Text(label, style: GoogleFonts.manrope(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.manrope(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // تصحيح تعريف البارامترات هنا
  Widget _buildActionTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 20),
          const SizedBox(width: 16),
          Text(title, style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushReplacementNamed('/login'), // العودة لصفحة الـ PIN
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            const SizedBox(width: 12),
            Text('Logout / End Shift',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }
}