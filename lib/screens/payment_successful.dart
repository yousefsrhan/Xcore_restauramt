import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({super.key});

  String _money(double value) => '${value.toStringAsFixed(0)} ج';
  String get _orderId => DateTime.now().millisecondsSinceEpoch.toString().substring(8);

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
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.primary
            )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 40
                  )
                ],
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 64),
            ),
            const SizedBox(height: 24),
            const Text(
                'Payment Successful!',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1.0
                )
            ),
            const SizedBox(height: 8),
            const Text(
                'The transaction has been processed securely.',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center
            ),

            const SizedBox(height: 40),

            _infoCard(
              title: 'TRANSACTION ID',
              value: 'Order #$_orderId',
              valueStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5
              ),
            ),

            const SizedBox(height: 12),

            _infoCard(
              title: 'TOTAL AMOUNT PAID',
              value: _money(total),
              valueStyle: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.0
              ),
            ),

            const SizedBox(height: 48),

            TextButton(
              onPressed: () {
                cart.clear();
                Navigator.of(context).pushNamedAndRemoveUntil('/menu', (route) => false);
              },
              child: const Text(
                  'RETURN TO MENU',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.5
                  )
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _infoCard({required String title, required String value, required TextStyle valueStyle}) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20)
    ),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            title,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5
            )
        ),
        const SizedBox(height: 8),
        Text(value, style: valueStyle),
      ],
    ),
  );
}
