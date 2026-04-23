import 'package:flutter/foundation.dart'; // ضروري لاستخدام kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart'; // This file should contain AppColors or AppTheme
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/staff_profile_screen.dart'; // تأكد من أن هذا هو اسم الملف الذي وضعنا فيه كود الـ Staff
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // إعدادات الويب من الصورة التي أرفقتها
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBEv@CLp3tYUnFG3zKgBHJeec4dqasGZJc", // انقلها بدقة كما في الصورة
        authDomain: "xcorerestaurant.firebaseapp.com",
        projectId: "xcorerestaurant",
        storageBucket: "xcorerestaurant.appspot.com",
        messagingSenderId: "845776385789",
        appId: "1:845776385789:web:83ddbe48c9d89b56ab42a4",
        measurementId: "G-16VHDJHJ3P",
      ),
    );
  } else {
    // للأندرويد سيستخدم ملف google-services.json تلقائياً
    await Firebase.initializeApp();
  }

  // كود الـ SystemChrome الخاص بك
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const XcoreRestaurantApp());
}

class XcoreRestaurantApp extends StatefulWidget {
  const XcoreRestaurantApp({super.key});
  @override
  State<XcoreRestaurantApp> createState() => _XcoreRestaurantAppState();
}

class _XcoreRestaurantAppState extends State<XcoreRestaurantApp> {
  final _cart = CartNotifier();
  @override void dispose() { _cart.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => CartProvider(
    notifier: _cart,
    child: MaterialApp(
      title: 'XCORE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark, darkTheme: AppTheme.dark, themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/':        (_) => const SplashScreen(),
        '/login':   (_) => const LoginScreen(),
        '/menu':    (_) => const MenuScreen(),
        '/orders':  (_) => const OrderScreen(),
        '/tables':  (_) => const _StubScreen('Tables'),
        '/profile': (_) => const StaffProfileScreen(),
        '/billing': (_) => const _StubScreen('Billing'),
      },
      scrollBehavior: const _BouncingScrollBehavior(),
      builder: (_, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF121212),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: child!,
      ),
    ),
  );
}

class _BouncingScrollBehavior extends ScrollBehavior {
  const _BouncingScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails _) => child;
}

class _StubScreen extends StatelessWidget {
  final String title;
  const _StubScreen(this.title);

  int _getIndex() {
    if (title.toLowerCase() == 'tables') return 0;
    if (title.toLowerCase() == 'billing') return 3;
    return 1;
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false, // منع الرجوع العادي الذي يسبب الشاشة السوداء
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      // بدلاً من الخروج، نعود دائماً للمنيو
      Navigator.of(context).pushReplacementNamed('/menu');
    },
    child: Scaffold(
      backgroundColor: const Color(0xFF121212), // Or AppTheme.dark.scaffoldBackgroundColor
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text(title.toUpperCase(), style: const TextStyle(
            color: Color(0xFF2ECC71), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.2)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/menu');
            }),
      ),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.construction_rounded, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        Text('$title screen coming soon', style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ])),
      bottomNavigationBar: BottomNavBar(currentIndex: _getIndex()),
    ),
  );
}
