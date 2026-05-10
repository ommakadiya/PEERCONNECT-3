import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peerconnect/providers/auth_provider.dart';
import 'package:peerconnect/services/auth_service.dart';
import 'package:peerconnect/services/firestore_service.dart';
import 'package:peerconnect/screens/splash_screen.dart';
import 'package:peerconnect/screens/login_screen.dart';
import 'package:peerconnect/screens/home_screen.dart';
import 'package:peerconnect/screens/connections_screen.dart';
import 'package:peerconnect/screens/help_screen.dart';
import 'package:peerconnect/screens/profile_screen.dart';
import 'package:peerconnect/providers/profile_provider.dart';
import 'package:peerconnect/screens/role_selection_screen.dart';
import 'package:peerconnect/screens/privacy_policy_screen.dart';
import 'package:peerconnect/utils/constants.dart';

/// Root widget of the GuardianNet application.
///
/// Sets up Provider at the top of the widget tree and
/// defines named routes for navigation.
class GuardianNetApp extends StatefulWidget {
  const GuardianNetApp({super.key});

  @override
  State<GuardianNetApp> createState() => _GuardianNetAppState();
}

class _GuardianNetAppState extends State<GuardianNetApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ConnectionsScreen(),
    HelpScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authService: AuthService(),
            firestoreService: FirestoreService(),
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(
            firestoreService: FirestoreService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: AppConstants.primaryColor,
            secondary: AppConstants.secondaryColor,
            surface: AppConstants.surfaceCard,
            onSurface: AppConstants.textPrimary,
            onPrimary: Color(0xFF08140F),
            onSecondary: Color(0xFF08140F),
            error: AppConstants.errorColor,
          ),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.surfaceCard,
            foregroundColor: AppConstants.textPrimary,
            centerTitle: false,
            elevation: 0,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppConstants.secondaryColor,
            selectionColor: Color(0x4D7FD6AF),
            selectionHandleColor: AppConstants.secondaryColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppConstants.surfaceCardLight,
            hintStyle: const TextStyle(color: AppConstants.textMuted),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              borderSide: const BorderSide(color: AppConstants.secondaryColor),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: const Color(0xFF08140F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMd,
                ),
              ),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppConstants.secondaryColor,
            unselectedItemColor: AppConstants.textSecondary,
            backgroundColor: AppConstants.surfaceCard,
          ),
          cardTheme: CardThemeData(
            color: AppConstants.surfaceCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/privacy': (_) => const PrivacyPolicyScreen(),
          '/role': (_) => const RoleSelectionScreen(),
          '/main': (routeCtx) => Consumer2<AuthProvider, ProfileProvider>(
            builder: (context, auth, profileProv, __) {
              final displayName = profileProv.displayName.isNotEmpty
                  ? profileProv.displayName
                  : (auth.user?.name ?? 'User');
              final displayEmail = profileProv.displayEmail.isNotEmpty
                  ? profileProv.displayEmail
                  : (auth.user?.email ?? '');

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppConstants.surfaceCard,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: AppConstants.secondaryColor),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/Final_profile_logo.png',
                          width: 38,
                          height: 38,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                ),
                body: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
                drawer: _buildDrawer(context, auth, profileProv, displayName, displayEmail),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people),
                      label: 'Connections',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.help),
                      label: 'Help',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              );
            },
          ),
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth, ProfileProvider profileProv, String displayName, String displayEmail) {
    return Drawer(
      backgroundColor: AppConstants.surfaceCard,
      child: Column(
        children: [
          // ── Drawer Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
            decoration: const BoxDecoration(
              gradient: AppConstants.backgroundGradient,
            ),
            child: Column(
              children: [
                // App Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset('assets/Final_profile_logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                // App Name
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.textPrimary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Trusted guardian connections',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                // Gold divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.secondaryColor.withValues(alpha: 0.0),
                        AppConstants.secondaryColor,
                        AppConstants.secondaryColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppConstants.primaryColor,
                      backgroundImage: profileProv.localPhotoPath != null
                          ? FileImage(File(profileProv.localPhotoPath!)) as ImageProvider
                          : null,
                      child: profileProv.localPhotoPath == null
                          ? Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppConstants.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            displayEmail,
                            style: const TextStyle(fontSize: 12, color: AppConstants.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Drawer Items ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerItem(Icons.home_rounded, 'Home', () {
                  Navigator.pop(context);
                  _onItemTapped(0);
                }),
                _drawerItem(Icons.people_rounded, 'Connections', () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                }),
                _drawerItem(Icons.help_outline_rounded, 'Help & Support', () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                }),
                _drawerItem(Icons.person_rounded, 'Profile', () {
                  Navigator.pop(context);
                  _onItemTapped(3);
                }),
                const Divider(color: AppConstants.surfaceDark, indent: 16, endIndent: 16),
                _drawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/privacy');
                }),
                _drawerItem(
                  Icons.logout_rounded,
                  'Sign Out',
                  () {
                    Navigator.pop(context);
                    auth.signOut().then((_) {
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    });
                  },
                  color: AppConstants.errorColor,
                ),
              ],
            ),
          ),

          // ── Footer ──
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              '${AppConstants.appName} v1.0.0',
              style: TextStyle(fontSize: 12, color: AppConstants.textMuted.withValues(alpha: 0.6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppConstants.accentColor, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? AppConstants.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 8,
    );
  }
}
