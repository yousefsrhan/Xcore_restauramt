import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/menu_models.dart';
import '../theme/app_theme.dart';

class FeaturedCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const FeaturedCard({super.key, required this.item, required this.onTap, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(borderRadius: BorderRadius.circular(16),
        child: SizedBox(width: double.infinity, height: 200,
          child: Stack(fit: StackFit.expand, children: [
            Image.network(item.imageUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh)),
            Container(decoration: const BoxDecoration(gradient: LinearGradient(
                begin: Alignment.centerRight, end: Alignment.centerLeft,
                colors: [Color(0x00000000), Color(0xCC000000)], stops: [0.3, 1.0]))),
            Padding(padding: const EdgeInsets.all(20), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(item.name, style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: -0.44, height: 1.15)),
                const SizedBox(height: 4),
                Text(item.description, style: GoogleFonts.manrope(fontSize: 12, color: Colors.white70),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(children: [
                  Text('${item.price.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(
                      fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.48)),
                  const Spacer(),
                  GestureDetector(onTap: onAdd,
                      child: Container(width: 40, height: 40,
                          decoration: BoxDecoration(gradient: AppGradients.primaryCta, borderRadius: BorderRadius.circular(100)),
                          child: const Icon(Icons.add, color: AppColors.onPrimary, size: 22))),
                ]),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}