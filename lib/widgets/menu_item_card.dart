import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/menu_models.dart';
import '../theme/app_theme.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final Animation<double>? scale;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onAdd,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    item.description,
                    style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.price.toStringAsFixed(0)} ج',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onAdd,
                  child: scale != null
                      ? ScaleTransition(scale: scale!, child: _buildAddIcon())
                      : _buildAddIcon(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIcon() => Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
  );
}