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
      duration: const Duration(milliseconds: 1200),
    );
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
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
        color: AppConstants.backgroundColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SlideTransition(
                  position: _slide,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        _logo(),
                        const SizedBox(height: 32),
                        const Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppConstants.charcoal,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppConstants.appTagline,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppConstants.mutedOlive,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(flex: 2),
                        _feat(Icons.verified_user_rounded, 'Trusted Guardian Profiles'),
                        const SizedBox(height: 16),
                        _feat(Icons.handshake_rounded, 'Secure Support Connections'),
                        const SizedBox(height: 16),
                        _feat(
                          Icons.safety_check_rounded,
                          'Professional & Secure Experience',
                        ),
                        const Spacer(flex: 3),
                        if (auth.errorMessage != null) ...[
                          _errorBanner(auth),
                          const SizedBox(height: 16),
                        ],
                        _googleBtn(auth),
                        const SizedBox(height: 24),
                        Text(
                          'By continuing, you agree to our Terms and Privacy Policy.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _logo() => Container(
    width: 130,
    height: 130,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppConstants.surfaceCard,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 30,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Image.asset('assets/Final_profile_logo.png', fit: BoxFit.contain),
    ),
  );

  Widget _feat(IconData ic, String txt) => Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppConstants.lightSand,
          ),
        ),
        child: Icon(ic, color: AppConstants.forestGreen, size: 22),
      ),
      const SizedBox(width: 16),
      Text(
        txt,
        style: const TextStyle(
          color: AppConstants.charcoal,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _errorBanner(AuthProvider a) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppConstants.errorColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppConstants.errorColor.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: AppConstants.errorColor,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            a.errorMessage!,
            style: const TextStyle(
              color: AppConstants.errorColor,
              fontSize: 13,
            ),
          ),
        ),
        GestureDetector(
          onTap: a.clearError,
          child: const Icon(
            Icons.close,
            color: AppConstants.errorColor,
            size: 18,
          ),
        ),
      ],
    ),
  );

  Widget _googleBtn(AuthProvider a) {
    final loading = a.status == AuthStatus.authenticating;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: loading ? null : () => a.signInWithGoogle(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.forestGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppConstants.forestGreen.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                        height: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
