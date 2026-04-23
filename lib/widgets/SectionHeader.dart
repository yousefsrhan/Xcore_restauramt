import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart'; // الوصول إلى ملف الألوان والتنسيقات

/// ويدجت لإظهار عنوان للقسم مع زر اختياري على اليمين
class SectionHeader extends StatelessWidget {
  final String title;        // عنوان القسم (مثل: الأطباق المميزة)
  final String actionLabel;  // النص الظاهر على الزر (افتراضياً: عرض الكل)
  final VoidCallback? onAction; // الوظيفة التي تعمل عند الضغط على الزر

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'عرض الكل', // نص افتراضي باللغة العربية
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // إضافة مسافات حول الهيدر لضمان تناسق التصميم
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عنوان القسم بتنسيق عريض ولون أبيض
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          
          // إظهار الزر فقط في حال تمرير وظيفة (onAction)
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // إزالة المسافات الزائدة ليكون النص محاذياً تماماً
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary, // استخدام اللون الأخضر الأساسي من الثيم
                ),
              ),
            ),
        ],
      ),
    );
  }
}
