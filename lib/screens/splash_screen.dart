import 'package:flutter/material.dart';
// تم حذف google_fonts لضمان ظهور النصوص فوراً مع الأنميشن بدون تحميل

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logo, _title, _sub, _footer;

  @override
  void initState() {
    super.initState();
    // تقليل الوقت قليلاً لـ 5 ثوانٍ قد يكون أفضل لتجربة المستخدم، لكن سأتركها 7 كما طلبت
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 7));

    // توزيع الأنميشن على المسطرة الزمنية
    _logo = _interval(0.0, 0.3);
    _title = _interval(0.2, 0.5);
    _sub = _interval(0.4, 0.7);
    _footer = _interval(0.7, 1.0);

    _ctrl.forward();
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) Navigator.of(context).pushReplacementNamed('/login');
  }

  Animation<double> _interval(double b, double e) =>
      CurvedAnimation(parent: _ctrl, curve: Interval(b, e, curve: Curves.easeOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                        opacity: _logo,
                        child: const Icon(Icons.restaurant, size: 80, color: Colors.white)
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                        opacity: _title,
                        child: const Text(
                            'XCORE',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            )
                        )
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                        opacity: _sub,
                        child: const Text(
                            'welcome to our restaurant Xcore',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                                letterSpacing: 2
                            )
                        )
                    ),
                  ],
                ),
              ),
            ),
            FadeTransition(
              opacity: _footer,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}