import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/cart_provider.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  static final _random = Random();

  CartItem _toCartItem(Map<String, dynamic> data, String id, double discountedPrice) => CartItem(
    id: id,
    name: data['name'] ?? '',
    category: (data['category'] ?? 'PROMO').toString().toUpperCase(),
    description: data['description'] ?? '',
    detail: 'خصم العرض 25%',
    imageUrl: data['imageUrl'] ?? '',
    unitPrice: discountedPrice,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final doc = docs[_random.nextInt(docs.length)];
          final data = doc.data() as Map<String, dynamic>;
          final price = double.tryParse(data['price']?.toString() ?? '0') ?? 0;
          final discountPrice = price * 0.75;

          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'عرض اليوم!',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 35),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 160, maxWidth: 280),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.02), blurRadius: 10)],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              data['imageUrl'] ?? '',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.fastfood, color: Colors.white10, size: 60),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        data['name'] ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${price.toStringAsFixed(0)} ج',
                            style: const TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${discountPrice.toStringAsFixed(0)} ج',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 45),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            CartProvider.read(context).addItem(_toCartItem(data, doc.id, discountPrice));
                            Navigator.pushReplacementNamed(context, '/orders');
                          },
                          child: const Text(
                            'اطلب الآن بخصم 25%',
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
