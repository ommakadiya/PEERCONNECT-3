import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/models/user_model.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 1.0, curve: Curves.easeIn)),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConstants.backgroundColor, AppConstants.primaryDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (auth.isAuthenticated && auth.user != null) {
                Provider.of<ProfileProvider>(context, listen: false).setUser(auth.user!);
                if (auth.user!.role != UserRole.none) {
                  Navigator.of(context).pushReplacementNamed('/main');
                } else {
                  Navigator.of(context).pushReplacementNamed('/privacy');
                }
              }
            });
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    FadeTransition(opacity: _fade, child: _logo()),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _slide,
                      child: FadeTransition(
                        opacity: _fade,
                        child: Column(
                          children: [
                            const Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppConstants.textPrimary,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The Secure Professional Network',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppConstants.goldColor.withValues(alpha: 0.8),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    _featList(),
                    const Spacer(flex: 2),
                    if (auth.errorMessage != null) ...[
                      _errorBanner(auth),
                      const SizedBox(height: 16),
                    ],
                    _googleBtn(auth),
                    const SizedBox(height: 24),
                    const Text(
                      'By continuing, you agree to our Terms and Privacy Policy.',
                      style: TextStyle(fontSize: 11, color: AppConstants.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _logo() => Container(
    width: 140,
    height: 140,
    decoration: BoxDecoration(
      color: AppConstants.surfaceCard,
      shape: BoxShape.circle,
      border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.3), width: 2),
      boxShadow: [
        BoxShadow(
          color: AppConstants.goldColor.withValues(alpha: 0.2),
          blurRadius: 40,
          spreadRadius: 5,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Image.asset('assets/Final_profile_logo.png', fit: BoxFit.contain),
    ),
  );

  Widget _featList() => Column(
    children: [
      _feat(Icons.shield_rounded, 'Premium Security Protocol'),
      const SizedBox(height: 16),
      _feat(Icons.workspace_premium_rounded, 'Elite Community Network'),
      const SizedBox(height: 16),
      _feat(Icons.verified_user_rounded, 'Verified Guardian Protection'),
    ],
  );

  Widget _feat(IconData ic, String txt) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppConstants.surfaceCard.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
    ),
    child: Row(
      children: [
        Icon(ic, color: AppConstants.goldColor, size: 22),
        const SizedBox(width: 16),
        Text(
          txt,
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _errorBanner(AuthProvider a) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppConstants.errorColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppConstants.errorColor.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            a.errorMessage!,
            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  Widget _googleBtn(AuthProvider a) {
    final loading = a.status == AuthStatus.authenticating;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppConstants.goldShadow,
      ),
      child: ElevatedButton(
        onPressed: loading ? null : () => a.signInWithGoogle(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: AppConstants.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: loading
            ? const CircularProgressIndicator(color: AppConstants.textPrimary)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                  ),
                ],
              ),
      ),
    );
  }
}
