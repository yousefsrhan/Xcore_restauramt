// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// تأكد أن هذا المسار يطابق اسم مشروعك الفعلي
import 'package:xcore_restaurant/main.dart';

void main() {
  testWidgets('Menu Screen load test', (WidgetTester tester) async {
    // 1. استدعاء اسم الكلاس الصحيح من ملف main.dart
    await tester.pumpWidget(const XcoreRestaurantApp());

    // 2. التحقق من وجود كلمة XCORE التي تظهر في عنوان التطبيق
    expect(find.text('XCORE'), findsOneWidget);
  });
}