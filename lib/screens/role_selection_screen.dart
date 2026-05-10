import 'package:flutter/material.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/utils/constants.dart';
import 'package:provider/provider.dart';


/// Screen shown after sign-in asking the user "Who are you?"
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = context.read<AuthProvider>();
    final profProv = context.read<ProfileProvider>();

    Future<void> _selectRole(UserRole role) async {
      if (authProv.user != null) {
        final updatedUser = authProv.user!.copyWith(role: role);
        await profProv.saveProfile(updatedUser);
        authProv.updateLocalUser(updatedUser);
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppConstants.warmBeige,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Logo ────────────────────────────────────────────
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.premiumGold.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset('assets/Final_profile_logo.png', fit: BoxFit.contain),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Heading ──────────────────────────────────────────
                const Text(
                  'Who are you?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppConstants.charcoal,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select your role to personalize your experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.mutedOlive,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(flex: 2),

                // ── Student / Child card ──────────────────────────────
                _RoleCard(
                  icon: Icons.school_rounded,
                  title: "I'm a Student",
                  subtitle: 'Set up your profile and join your trusted peer groups',
                  onTap: () => _selectRole(UserRole.child),
                ),

                const SizedBox(height: 16),

                // ── Parent card ───────────────────────────────────────
                _RoleCard(
                  icon: Icons.family_restroom_rounded,
                  title: "I'm a Parent",
                  subtitle: 'Set up your profile and stay connected with your children',
                  onTap: () => _selectRole(UserRole.parent),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Role option card ───────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _press.forward(),
        onTapUp: (_) {
          _press.reverse();
          widget.onTap();
        },
        onTapCancel: () => _press.reverse(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppConstants.lightSand.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppConstants.forestGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  color: AppConstants.forestGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppConstants.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppConstants.mutedOlive,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppConstants.premiumGold,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
