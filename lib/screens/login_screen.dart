import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _pin = "";
  final int _pinLength = 4;

  void _onKeyPress(String value) {
    if (_pin.length < _pinLength) {
      HapticFeedback.lightImpact();
      setState(() => _pin += value);

      if (_pin.length == _pinLength) {
        if (_pin == "1111") {
          Future.delayed(const Duration(milliseconds: 300), _handleLogin);
        } else {
          HapticFeedback.vibrate();
          Future.delayed(const Duration(milliseconds: 500), () => setState(() => _pin = ""));
        }
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _onClear() {
    if (_pin.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() => _pin = "");
    }
  }

  void _handleLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/promotion-screen');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // استبدال GoogleFonts بـ TextStyle عادي (سيقرأ Cairo تلقائياً من الـ Theme)
              const Text(
                'Login to Enter',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter your personal security PIN',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 50),

              // PIN Dots
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pinLength, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 16, height: 16,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < _pin.length ? Colors.white : Colors.white10
                      )))),

              const SizedBox(height: 60),

              // Numbers pad
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, mainAxisSpacing: 25, crossAxisSpacing: 25,
                children: [
                  ...['1','2','3','4','5','6','7','8','9'].map((n) => _btn(label: n, tap: () => _onKeyPress(n))),
                  _btn(label: '0', tap: () => _onKeyPress('0')),
                  _btn(icon: Icons.backspace_outlined, tap: _onBackspace, color: Colors.redAccent),
                  _btn(label: 'C', tap: _onClear, color: Colors.white54),
                ],
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    ),
  );

  Widget _btn({String? label, IconData? icon, required VoidCallback tap, Color? color}) => InkWell(
    onTap: tap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: icon != null
              ? Icon(icon, size: 28, color: color ?? Colors.white)
              : Text(
            label!,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: color ?? Colors.white),
          )),
    ),
  );
}