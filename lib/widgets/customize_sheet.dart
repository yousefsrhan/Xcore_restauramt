import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

void showCustomizeSheet(BuildContext context, {CartItem? prefillItem}) =>
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => CustomizeSheet(prefillItem: prefillItem),
    );

class _Option {
  final String label;
  final double price;
  bool on;
  _Option(this.label, {this.price = 0, this.on = false});
}

class CustomizeSheet extends StatefulWidget {
  final CartItem? prefillItem;
  const CustomizeSheet({super.key, this.prefillItem});
  @override State<CustomizeSheet> createState() => _CustomizeSheetState();
}

class _CustomizeSheetState extends State<CustomizeSheet> with TickerProviderStateMixin {
  int _qty = 1;
  final _toppings = [
    _Option('جبنة إضافية', price: 15, on: true),
    _Option('صوص حار', price: 5),
    _Option('مخلل زيادة', price: 5),
    _Option('بطاطس داخلية', price: 20),
  ];
  final _dietary = [
    _Option('بدون مخلل'),
    _Option('بدون ثومية'),
  ];
  late final AnimationController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    if (widget.prefillItem != null) _qty = widget.prefillItem!.quantity;
  }
  @override void dispose() { _qtyCtrl.dispose(); super.dispose(); }

  Future<void> _bump() async { await _qtyCtrl.forward(); await _qtyCtrl.reverse(); }

  double get _total {
    double base = widget.prefillItem?.unitPrice ?? 0;
    double extras = _toppings.where((t) => t.on).fold(0, (sum, t) => sum + t.price);
    return (base + extras) * _qty;
  }

  void _addToOrder() {
    HapticFeedback.mediumImpact();
    double base = widget.prefillItem?.unitPrice ?? 0;
    double extras = _toppings.where((t) => t.on).fold(0, (sum, t) => sum + t.price);
    
    CartProvider.read(context).addItem(CartItem(
      id: widget.prefillItem?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: widget.prefillItem?.name ?? 'Custom Item',
      category: widget.prefillItem?.category ?? 'OTHER',
      description: widget.prefillItem?.description ?? '',
      detail: _toppings.where((t) => t.on).map((t) => t.label).join(', '),
      imageUrl: widget.prefillItem?.imageUrl ?? '',
      unitPrice: base + extras, // السعر يشمل الإضافات
      quantity: _qty,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Drag handle
        Padding(padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Center(child: Container(width: 48, height: 6,
                decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(3))))),
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20, 8, 12, 16), child: Row(children: [
          Text('تخصيص الطلب', style: GoogleFonts.manrope(
              fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.48)),
          const Spacer(),
          GestureDetector(onTap: () => Navigator.of(context).pop(),
              child: Container(width: 40, height: 40,
                  decoration: const BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 20))),
        ])),
        // Body
        Flexible(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 0, 20, inset + 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Hero
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(borderRadius: BorderRadius.circular(16),
                  child: SizedBox(width: 96, height: 96,
                      child: Image.network(widget.prefillItem?.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest,
                              child: const Icon(Icons.restaurant_rounded, color: AppColors.outlineVariant, size: 32))))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.prefillItem?.name ?? 'Item', style: GoogleFonts.manrope(
                    fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.4)),
                const SizedBox(height: 6),
                Text(widget.prefillItem?.description ?? '', style: GoogleFonts.manrope(
                    fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5)),
              ])),
            ]),
            const SizedBox(height: 28),
            // Toppings
            Row(children: [
              Text('اختر الإضافات', style: GoogleFonts.manrope(
                  fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                  child: Text('اختياري', style: GoogleFonts.manrope(
                      fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onPrimary, letterSpacing: 0.8))),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: _toppings.map((t) => GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); setState(() => t.on = !t.on); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                    gradient: t.on ? AppGradients.primaryCta : null,
                    color: t.on ? null : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: t.on ? [BoxShadow(color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 12, offset: const Offset(0, 4))] : null),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(t.on ? Icons.check_circle : Icons.add_rounded, size: 16,
                      color: t.on ? AppColors.onPrimary : Colors.white),
                  const SizedBox(width: 8),
                  Text(t.label, style: GoogleFonts.manrope(fontSize: 13,
                      fontWeight: t.on ? FontWeight.w700 : FontWeight.w600,
                      color: t.on ? AppColors.onPrimary : Colors.white)),
                  if (t.price > 0) ...[
                    const SizedBox(width: 6),
                    Text('+${t.price.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(
                        fontSize: 11, fontWeight: FontWeight.w800,
                        color: t.on ? AppColors.onPrimary.withOpacity(0.8) : AppColors.primary)),
                  ],
                ]),
              ),
            )).toList()),
            const SizedBox(height: 28),
            // Dietary
            Text('ملاحظات غذائية', style: GoogleFonts.manrope(
                fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            ..._dietary.asMap().entries.map((e) => Padding(
              padding: EdgeInsets.only(bottom: e.key < _dietary.length - 1 ? 10 : 0),
              child: GestureDetector(
                onTap: () { HapticFeedback.selectionClick(); setState(() => e.value.on = !e.value.on); },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFF131313), borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      Text(e.value.label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                      const Spacer(),
                      AnimatedContainer(duration: const Duration(milliseconds: 200),
                          width: 24, height: 24,
                          decoration: BoxDecoration(shape: BoxShape.circle,
                              color: e.value.on ? AppColors.primary : Colors.transparent,
                              border: e.value.on ? null : Border.all(color: AppColors.outlineVariant, width: 2),
                              boxShadow: e.value.on ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)] : null),
                          child: e.value.on ? const Icon(Icons.check_rounded, size: 16, color: AppColors.onPrimary) : null),
                    ])),
              ),
            )),
            const SizedBox(height: 28),
            // Special Instructions
            Text('تعليمات خاصة', style: GoogleFonts.manrope(
                fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Container(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                child: TextFormField(
                  minLines: 4, maxLines: 6,
                  style: GoogleFonts.manrope(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'مثال: بدون بصل، صوص خارجي...', filled: false,
                    hintStyle: GoogleFonts.manrope(fontSize: 13, color: AppColors.outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.primaryDim.withOpacity(0.4), width: 2)),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                )),
            const SizedBox(height: 12),
          ]),
        )),
        // Footer
        Container(
          decoration: BoxDecoration(color: const Color(0xFF1E1E1E),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07)))),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + inset),
          child: Row(children: [
            // Stepper
            Container(padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _QtyBtn(icon: Icons.remove_rounded, enabled: _qty > 1,
                    onTap: () async { if (_qty <= 1) return; await _bump(); setState(() => _qty--); }),
                SizedBox(width: 36, child: Text('$_qty', textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white))),
                _QtyBtn(icon: Icons.add_rounded, enabled: true,
                    onTap: () async { await _bump(); setState(() => _qty++); }),
              ]),
            ),
            const SizedBox(width: 12),
            // CTA
            Expanded(child: _AddBtn(price: _total, onTap: _addToOrder)),
          ]),
        ),
      ]),
    );
  }
}

class _QtyBtn extends StatefulWidget {
  final IconData icon; final bool enabled; final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.enabled, required this.onTap});
  @override State<_QtyBtn> createState() => _QtyBtnState();
}
class _QtyBtnState extends State<_QtyBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState();
  _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  _s = Tween<double>(begin: 1.0, end: 0.78).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _s,
      child: GestureDetector(
          onTap: () async { if (!widget.enabled) return; await _c.forward(); await _c.reverse(); widget.onTap(); },
          child: Container(width: 40, height: 40,
              child: Icon(widget.icon, size: 22, color: widget.enabled ? AppColors.primary : AppColors.outlineVariant))));
}

class _AddBtn extends StatefulWidget {
  final double price; final VoidCallback onTap;
  const _AddBtn({required this.price, required this.onTap});
  @override State<_AddBtn> createState() => _AddBtnState();
}
class _AddBtnState extends State<_AddBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState();
  _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
  _s = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _s,
      child: GestureDetector(
          onTap: () async { await _c.forward(); await _c.reverse(); widget.onTap(); },
          onTapDown: (_) => _c.forward(), onTapUp: (_) => _c.reverse(), onTapCancel: () => _c.reverse(),
          child: Container(height: 60,
              decoration: BoxDecoration(gradient: AppGradients.primaryCta,
                  borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.primaryGlow),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Text('إضافة للطلب', style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onPrimary, letterSpacing: -0.2)),
                const Spacer(),
                Text('${widget.price.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onPrimary, letterSpacing: -0.3)),
              ]))));
}
