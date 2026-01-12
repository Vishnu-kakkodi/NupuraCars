import 'package:flutter/material.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _fadeController.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final userId = await StorageHelper.getUserId();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            userId != null && userId.isNotEmpty
                ? const MainNavigationScreen()
                : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ------------------------------------------------
  // POWERED BY BRANDING
  // ------------------------------------------------
  Widget _poweredByBranding() {
    return Positioned(
      bottom: 24 + MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            "Powered by",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Pixelmindsolutions Pvt Ltd",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // BOTTOM LOADING (UNCHANGED STYLE)
  // ------------------------------------------------
  Widget _bottomLoading() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 90 + MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.15),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF22D3EE)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Getting your car ready…',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // UI
  // ------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ FULL SCREEN IMAGE (FIXED)
            Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),

            // OPTIONAL DARK OVERLAY (for readability)
            Container(
              color: Colors.black.withOpacity(0.25),
            ),

            // BOTTOM LOADING
            _bottomLoading(),

            // POWERED BY
            _poweredByBranding(),
          ],
        ),
      ),
    );
  }
}
