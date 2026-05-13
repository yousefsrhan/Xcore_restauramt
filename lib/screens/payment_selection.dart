import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';

const _methods = [
  ('Cash', 'Physical currency & bills', Icons.payments_rounded),
  ('Credit Card', 'Visa, Mastercard, AMEX', Icons.credit_card_rounded),
  ('Apple Pay', 'Express NFC mobile payment', Icons.contactless_rounded)
];

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({super.key});
  @override State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String _selectedMethod = 'Credit Card';

  String _money(double value) => '${value.toStringAsFixed(0)} ج';

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final total = cart.grandTotal;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
            'XCORE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)
        ),
        actions: [
          Center(
              child: Text(
                  'ORDER #${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w700)
              )
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'SECURE CHECKOUT',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.0)
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Total to Pay:\n${_money(total)}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1, letterSpacing: -1.5)
                  ),

                  const SizedBox(height: 32),
                  for (var i = 0; i < _methods.length; i++) ...[
                    _buildMethodCard(_methods[i].$1, _methods[i].$2, _methods[i].$3),
                    if (i < _methods.length - 1) const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'QUICK BILL SUMMARY',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant, letterSpacing: 1.5)
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Subtotal', _money(cart.subtotal)),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Service Charge (15%)', _money(cart.service)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: GestureDetector(
              onTap: () { if (total > 0) Navigator.of(context).pushNamed('/payment-success'); },
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryCta,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.primaryGlow,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Confirm Payment',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.onPrimary)
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward_rounded, color: AppColors.onPrimary, size: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildMethodCard(String title, String subtitle, IconData icon) {
    final isSelected = _selectedMethod == title;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerHigh.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Icon(icon, color: isSelected ? AppColors.onPrimary : AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)
                  ),
                  const SizedBox(height: 4),
                  Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                child: const Text(
                    'SELECTED',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.0)
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
      Text(value, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
    ],
  );
}
