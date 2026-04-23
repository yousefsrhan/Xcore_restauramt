import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

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
      HapticFeedback.lightImpact(); // إضافة استجابة لمسية
      setState(() {
        _pin += value;
      });

      // التحقق التلقائي عند اكتمال الرمز
      if (_pin.length == _pinLength) {
        _handleLogin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _handleLogin() {
    // هنا نضع منطق التحقق من الـ PIN
    // مؤقتاً سنقوم بالانتقال للمنيو مباشرة
    Navigator.of(context).pushReplacementNamed('/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () {},
        ),
        title: Text(
          'XCORE',
          style: GoogleFonts.manrope(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ),
      // التعديل يبدأ من هنا لضبط أبعاد الويب
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480), // تحديد أقصى عرض ليناسب تصميم الموبايل
          child: Column(
            children: [
              const Spacer(),
              Text(
                'Login to Shift',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your personal security PIN',
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // مؤشرات الـ PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (index) {
                  bool isActive = index < _pin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.primary : AppColors.surfaceContainerHighest,
                      boxShadow: isActive
                          ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10)]
                          : [],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 60),

              // لوحة الأرقام
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((e) => _buildNumberButton(e)),
                      _buildIconButton(Icons.backspace_outlined, _onBackspace, color: AppColors.error),
                      _buildNumberButton('0'),
                      _buildIconButton(Icons.fingerprint, () {}, color: AppColors.outline),
                    ],
                  ),
                ),
              ),

              // زر الدخول
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GradientButton(
                  label: "ENTER SHIFT",
                  onPressed: _handleLogin,
                  enabled: _pin.length == _pinLength,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTextLink("Forgot PIN?"),
                    _buildTextLink("Manager Override"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(number),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  } // تم إضافة القوس الناقص هنا ✅

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {required Color color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Center(
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }

  Widget _buildTextLink(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.manrope(
        color: AppColors.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}