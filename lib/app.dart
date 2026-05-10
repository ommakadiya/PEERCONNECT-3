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
import 'package:peerconnect/screens/edit_profile_screen.dart';
import 'package:peerconnect/screens/about_screen.dart';
import 'package:peerconnect/utils/constants.dart';

/// Root widget of the GuardianNet application.
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
            secondary: AppConstants.goldColor,
            surface: AppConstants.surfaceCard,
            onSurface: AppConstants.textPrimary,
            onPrimary: AppConstants.textPrimary,
            onSecondary: AppConstants.backgroundColor,
            error: AppConstants.errorColor,
          ),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            ThemeData.dark().textTheme.apply(
              bodyColor: AppConstants.textPrimary,
              displayColor: AppConstants.textPrimary,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.backgroundColor,
            foregroundColor: AppConstants.textPrimary,
            centerTitle: false,
            elevation: 0,
            iconTheme: IconThemeData(color: AppConstants.goldColor),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppConstants.goldColor,
            selectionColor: Color(0x4DD4A017),
            selectionHandleColor: AppConstants.goldColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppConstants.surfaceCard,
            hintStyle: const TextStyle(color: AppConstants.textMuted),
            labelStyle: const TextStyle(color: AppConstants.textSecondary),
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
              borderSide: const BorderSide(color: AppConstants.goldColor, width: 1),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: AppConstants.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppConstants.goldColor,
            unselectedItemColor: AppConstants.textMuted,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: AppConstants.surfaceCard,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
              side: BorderSide(color: AppConstants.textPrimary.withValues(alpha: 0.05)),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/privacy': (_) => const PrivacyPolicyScreen(),
          '/about': (_) => const AboutScreen(),
          '/edit-profile': (_) => const EditProfileScreen(),
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
                extendBodyBehindAppBar: true,
                extendBody: true,
                appBar: AppBar(
                  backgroundColor: AppConstants.backgroundColor.withValues(alpha: 0.8),
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ColorFilter.mode(Colors.black.withValues(alpha: 0.1), BlendMode.darken),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  elevation: 0,
                  iconTheme: const IconThemeData(color: AppConstants.goldColor),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppConstants.surfaceCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.3)),
                          boxShadow: AppConstants.goldShadow,
                        ),
                        child: Image.asset(
                          'assets/Final_profile_logo.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'GUARDIAN NET',
                        style: TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
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
                bottomNavigationBar: _buildPremiumNavBar(),
              );
            },
          ),
        },
      ),
    );
  }

  Widget _buildPremiumNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      decoration: BoxDecoration(
        color: AppConstants.surfaceCard.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hub_rounded),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rounded),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Identity',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth, ProfileProvider profileProv, String displayName, String displayEmail) {
    return Drawer(
      backgroundColor: AppConstants.backgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(28, 80, 28, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConstants.primaryDark, AppConstants.navyAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppConstants.goldColor.withValues(alpha: 0.3)),
                    boxShadow: AppConstants.goldShadow,
                  ),
                  child: Image.asset('assets/Final_profile_logo.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 24),
                const Text(
                  'GUARDIAN NET',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppConstants.textPrimary, letterSpacing: 2),
                ),
                Text(
                  'THE ELITE PROFESSIONAL NETWORK',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppConstants.goldColor.withValues(alpha: 0.8), letterSpacing: 1),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppConstants.goldColor,
                      backgroundImage: profileProv.localPhotoPath != null
                          ? FileImage(File(profileProv.localPhotoPath!)) as ImageProvider
                          : null,
                      child: profileProv.localPhotoPath == null
                          ? Text(displayName[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.backgroundColor))
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
                          Text(displayEmail, style: const TextStyle(fontSize: 12, color: AppConstants.textSecondary), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              children: [
                _drawerItem(Icons.grid_view_rounded, 'DASHBOARD', () {
                  Navigator.pop(context);
                  _onItemTapped(0);
                }),
                _drawerItem(Icons.hub_rounded, 'GLOBAL NETWORK', () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                }),
                _drawerItem(Icons.star_rounded, 'OPPORTUNITIES', () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                }),
                _drawerItem(Icons.person_rounded, 'SECURE IDENTITY', () {
                  Navigator.pop(context);
                  _onItemTapped(3);
                }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Divider(color: AppConstants.primaryDark, height: 1),
                ),
                _drawerItem(Icons.shield_rounded, 'PRIVACY PROTOCOL', () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/privacy');
                }),
                _drawerItem(Icons.info_rounded, 'ABOUT GUARDIAN', () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                }),
                const SizedBox(height: 40),
                _drawerItem(Icons.logout_rounded, 'LOG OUT SESSION', () {
                  Navigator.pop(context);
                  auth.signOut().then((_) {
                    if (context.mounted) Navigator.of(context).pushReplacementNamed('/login');
                  });
                }, color: Colors.redAccent),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              'GUARDIAN NET ELITE v1.0.0',
              style: TextStyle(fontSize: 10, color: AppConstants.textMuted, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppConstants.goldColor, size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: color ?? AppConstants.textPrimary,
          letterSpacing: 1,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
