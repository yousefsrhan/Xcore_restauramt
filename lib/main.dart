import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xcore_restaurant/screens/promotion-screen.dart';

import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';
import 'screens/staff_profile_screen.dart';
import 'screens/about_us.dart';
import 'screens/payment_selection.dart';
import 'screens/payment_successful.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBEv@CLp3tYUnFG3zKgBHJeec4dqasGZJc",
          authDomain: "xcorerestaurant.firebaseapp.com",
          projectId: "xcorerestaurant",
          storageBucket: "xcorerestaurant.appspot.com",
          messagingSenderId: "845776385789",
          appId: "1:845776385789:web:83ddbe48c9d89b56ab42a4",
          measurementId: "G-16VHDJHJ3P",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    debugPrint("Firebase initialized successfully");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

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

      // --- [التعديل الجوهري للخط اللوكال] ---
      theme: AppTheme.dark.copyWith(
        textTheme: AppTheme.dark.textTheme.apply(
          fontFamily: 'Cairo', // نفس الاسم اللي في الـ pubspec.yaml
        ),
        primaryTextTheme: AppTheme.dark.primaryTextTheme.apply(
          fontFamily: 'Cairo',
        ),
      ),
      // ------------------------------------

      initialRoute: '/',
      routes: {
        '/':        (_) => const SplashScreen(),
        '/login':   (_) => const LoginScreen(),
        '/menu':    (_) => const MenuScreen(),
        '/promotion-screen': (context) => const PromotionScreen(),
        '/orders':  (_) => const OrderScreen(),
        '/profile': (context) => const StaffProfileScreen(),
        '/about':   (_) => const AboutUsScreen(),
        '/billing': (_) => const PaymentSelectionScreen(),
        '/payment-success': (_) => const PaymentSuccessfulScreen(),
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