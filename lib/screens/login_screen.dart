import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peerconnect/providers/auth_provider.dart';
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
        decoration: const BoxDecoration(
          gradient: AppConstants.backgroundGradient,
        ),
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (auth.isAuthenticated) {
                Navigator.of(context).pushReplacementNamed('/privacy');
              }
            });
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SlideTransition(
                  position: _slide,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        _logo(),
                        const SizedBox(height: 24),
                        const Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.textPrimary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppConstants.appTagline,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                        const Spacer(flex: 2),
                        _feat(Icons.group_rounded, 'Peer Networking'),
                        const SizedBox(height: 14),
                        _feat(Icons.flash_on_rounded, 'Oppurunity and Helping'),
                        const SizedBox(height: 14),
                        _feat(
                          Icons.chat_bubble_outline,
                          'Seamless Connections',
                        ),
                        const Spacer(flex: 2),
                        if (auth.errorMessage != null) ...[
                          _errorBanner(auth),
                          const SizedBox(height: 16),
                        ],
                        _googleBtn(auth),
                        const SizedBox(height: 20),
                        Text(
                          'By signing in, you agree to our Terms of Service',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textMuted.withValues(
                              alpha: 0.7,
                            ),
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
    width: 110,
    height: 110,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: AppConstants.primaryColor.withValues(alpha: 0.45),
          blurRadius: 32,
          spreadRadius: 6,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.asset('assets/app_logo2.png', fit: BoxFit.cover),
    ),
  );

  Widget _feat(IconData ic, String txt) => Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(ic, color: AppConstants.accentColor, size: 20),
      ),
      const SizedBox(width: 14),
      Text(
        txt,
        style: const TextStyle(
          color: AppConstants.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _errorBanner(AuthProvider a) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppConstants.errorColor.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppConstants.errorColor.withValues(alpha: 0.3)),
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
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : () => a.signInAsGuest(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.surfaceCard,
          foregroundColor: AppConstants.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppConstants.primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(AppConstants.primaryColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFF4285F4),
                                Color(0xFF34A853),
                                Color(0xFFFBBC05),
                                Color(0xFFEA4335),
                              ],
                            ).createShader(const Rect.fromLTWH(0, 0, 20, 20)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
