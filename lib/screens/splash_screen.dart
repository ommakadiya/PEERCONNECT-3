import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/auth_provider.dart';

/// Splash screen displayed on app launch.
///
/// Shows [logo_appearing_while_opening.png] full-screen, holds for 3 seconds,
/// then fades out and routes to the appropriate screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Fade-in over 600 ms, hold, then fade-out over 600 ms at the end.
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    // Total duration = 3 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Fade-in: 0 → 1 during first 20% (0–600 ms)
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeIn),
      ),
    );

    // Fade-out: 1 → 0 during last 20% (2400–3000 ms)
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) => _navigateFromSplash());
  }

  void _navigateFromSplash() {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Combine fade-in and fade-out: multiply their values
          // fadeIn goes 0→1 in first 20%, stays 1 in middle
          // fadeOut goes 1→0 in last 20%
          final opacity = _fadeIn.value * _fadeOut.value;

          return Opacity(
            opacity: opacity,
            child: child,
          );
        },
        child: SizedBox.expand(
          child: Image.asset(
            'assets/logo_appearing_while_opening.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
