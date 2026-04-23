import 'package:flutter/material.dart';

class CartItem {
  final String id, name, category, description, detail, imageUrl;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.id, required this.name, required this.category,
    this.description = '', required this.detail, required this.imageUrl,
    required this.unitPrice, this.quantity = 1,
  });

  double get total => unitPrice * quantity;
}

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int    get totalCount => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal   => _items.fold(0.0, (s, i) => s + i.total);
  double get service    => subtotal * 0.15;
  double get grandTotal => subtotal + service;

  void addItem(CartItem item) {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx >= 0) { _items[idx].quantity += item.quantity; }
    else { _items.add(item); }
    notifyListeners();
  }

  void increment(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) { _items[idx].quantity++; notifyListeners(); }
  }

  void decrement(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0 && _items[idx].quantity > 1) { _items[idx].quantity--; notifyListeners(); }
  }

  void removeItem(String id) { _items.removeWhere((e) => e.id == id); notifyListeners(); }
  void clear() { _items.clear(); notifyListeners(); }
}

class CartProvider extends InheritedNotifier<CartNotifier> {
  const CartProvider({super.key, required CartNotifier notifier, required super.child})
      : super(notifier: notifier);

  static CartNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartProvider>()!.notifier!;

  static CartNotifier read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<CartProvider>()!.notifier!;
}
