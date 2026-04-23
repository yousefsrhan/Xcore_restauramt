import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _ctrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _logo   = _interval(0.0,  0.40);
    _title  = _interval(0.25, 0.60);
    _sub    = _interval(0.45, 0.75);
    _footer = _interval(0.65, 1.00);
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  Animation<double> _interval(double b, double e) =>
      CurvedAnimation(parent: _ctrl, curve: Interval(b, e, curve: Curves.easeOut));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Widget _glow(AlignmentGeometry a) {
    final isRight = a == Alignment.topRight;
    return Align(
      alignment: a,
      child: Transform.translate(
        offset: Offset(isRight ? 128 : -128, isRight ? -128 : 128),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(width: 320, height: 320,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x0DFFFFFF))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF121212),
    body: Stack(children: [
      _glow(Alignment.topRight),
      _glow(Alignment.bottomLeft),
      SafeArea(child: Column(children: [
        Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          FadeTransition(opacity: _logo, child: SizedBox(width: 120, height: 120,
            child: Stack(alignment: Alignment.center, children: [
              ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(width: 80, height: 80,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x26FFFFFF)))),
              const Icon(Icons.restaurant, size: 96, color: Colors.white),
            ]),
          )),
          const SizedBox(height: 24),
          FadeTransition(opacity: _title,
              child: Text('XCORE', style: GoogleFonts.manrope(
                  fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.96))),
          const SizedBox(height: 16),
          FadeTransition(opacity: _sub, child: Container(width: 240, height: 1,
              decoration: const BoxDecoration(gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0x33FFFFFF), Colors.transparent])))),
          const SizedBox(height: 16),
          FadeTransition(opacity: _sub, child: Text('welcome to our restaurant Xcore',
              style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w500,
                  color: Colors.white, letterSpacing: 2.0))),
        ]))),
        FadeTransition(opacity: _footer, child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(width: 32, height: 32,
                child: CircularProgressIndicator(strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white))),
            const SizedBox(height: 12),
            Text('INITIALIZING CORE MODULES', style: GoogleFonts.manrope(
                fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 1.5)),
          ]),
        )),
      ])),
    ]),
  );
}
