import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

const _kNav = [
  ('TABLES',  Icons.table_restaurant_rounded,  '/tables'),
  ('MENU',    Icons.restaurant_menu_rounded,   '/menu'),
  ('ORDERS',  Icons.shopping_cart_rounded,     '/orders'),
  ('BILLING', Icons.payments_rounded,          '/billing'),
];

class BottomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Size get preferredSize => const Size.fromHeight(64); // العودة لارتفاع قياسي

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF121212),
    child: Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x0DFFFFFF))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64, // الارتفاع القياسي
          child: Row(
            children: List.generate(_kNav.length, (i) => Expanded(
              child: _NavBtn(
                label: _kNav[i].$1,
                icon: _kNav[i].$2,
                isActive: i == currentIndex,
                onTap: () {
                  if (onTap != null) { onTap!(i); return; }
                  if (i != currentIndex) Navigator.of(context).pushReplacementNamed(_kNav[i].$3);
                },
              ),
            )),
          ),
        ),
      ),
    ),
  );
}

class _NavBtn extends StatefulWidget {
  final String label; final IconData icon; final bool isActive; final VoidCallback onTap;
  const _NavBtn({required this.label, required this.icon, required this.isActive, required this.onTap});
  @override State<_NavBtn> createState() => _NavBtnState();
}

class _NavBtnState extends State<_NavBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _s = Tween<double>(begin: 1.0, end: 0.88).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () async { await _c.forward(); await _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isActive ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, size: 24,
                color: widget.isActive ? AppColors.primary : Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(widget.label, style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w600,
              color: widget.isActive ? AppColors.primary : Colors.grey[600],
              letterSpacing: 0.5)),
        ]),
      ),
    ),
  );
}
