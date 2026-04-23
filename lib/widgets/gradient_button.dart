import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum IconPosition { leading, trailing }

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final IconPosition iconPosition;
  final double height;
  final double? borderRadius;
  final bool isLoading, enabled;

  const GradientButton({
    super.key, required this.label, required this.onPressed,
    this.icon, this.iconPosition = IconPosition.trailing,
    this.height = 56, this.borderRadius, this.isLoading = false, this.enabled = true,
  });

  @override State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    _s = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }

  bool get _active => widget.enabled && !widget.isLoading;

  Future<void> _tap() async {
    if (!_active) return;
    HapticFeedback.lightImpact();
    await _c.forward(); await _c.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.borderRadius ?? AppRadius.button;
    return ScaleTransition(scale: _s,
      child: GestureDetector(
        onTap: _tap,
        onTapDown: (_) { if (_active) _c.forward(); },
        onTapUp: (_) { if (_active) _c.reverse(); },
        onTapCancel: () { if (_active) _c.reverse(); },
        child: AnimatedContainer(duration: const Duration(milliseconds: 200), height: widget.height,
          decoration: BoxDecoration(
              gradient: _active ? AppGradients.primaryCta : null,
              color: _active ? null : AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(r),
              boxShadow: _active ? AppShadows.primaryGlow : null),
          child: ClipRRect(borderRadius: BorderRadius.circular(r),
            child: Material(color: Colors.transparent,
              child: InkWell(onTap: _tap,
                splashColor: AppColors.onPrimary.withOpacity(0.08),
                highlightColor: AppColors.onPrimary.withOpacity(0.04),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _content()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    final color = _active ? AppColors.onPrimary : AppColors.onSurfaceVariant;
    final label = Text(widget.label.toUpperCase(), style: GoogleFonts.manrope(
        fontSize: 14, fontWeight: FontWeight.w800, color: color, letterSpacing: 1.2));
    final iconThemed = widget.icon != null
        ? IconTheme(data: IconThemeData(color: color, size: 20), child: widget.icon!)
        : null;

    if (widget.isLoading) return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 18, height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(color))),
      const SizedBox(width: 12), label,
    ]);
    if (iconThemed == null) return Center(child: label);
    if (widget.iconPosition == IconPosition.leading) return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      iconThemed, const SizedBox(width: 10), label]);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      label, const SizedBox(width: 10), iconThemed]);
  }
}

// Convenience variants
class PaymentButton extends StatelessWidget {
  final VoidCallback onPressed; final bool isLoading;
  const PaymentButton({super.key, required this.onPressed, this.isLoading = false});
  @override
  Widget build(BuildContext context) => GradientButton(
      label: 'Proceed to Payment', onPressed: onPressed, isLoading: isLoading,
      icon: const Icon(Icons.arrow_forward_rounded));
}

class AddToOrderButton extends StatelessWidget {
  final VoidCallback onPressed; final String price; final bool isLoading;
  const AddToOrderButton({super.key, required this.onPressed, required this.price, this.isLoading = false});
  @override
  Widget build(BuildContext context) => GradientButton(
      label: 'Add to Order  $price', onPressed: onPressed, isLoading: isLoading,
      icon: const Icon(Icons.add_rounded), iconPosition: IconPosition.leading);
}
