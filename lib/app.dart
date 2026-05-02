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
import 'package:peerconnect/utils/constants.dart';

/// Root widget of the PeerConnect application.
///
/// Sets up Provider at the top of the widget tree and
/// defines named routes for navigation.
class PeerConnectApp extends StatefulWidget {
  const PeerConnectApp({super.key});

  @override
  State<PeerConnectApp> createState() => _PeerConnectAppState();
}

class _PeerConnectAppState extends State<PeerConnectApp> {
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
            onPrimary: AppConstants.textPrimary,
            onSecondary: AppConstants.textPrimary,
            error: AppConstants.errorColor,
          ),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: AppConstants.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMd,
                ),
              ),
            ),
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
          '/main': (_) => Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
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
              selectedItemColor: AppConstants.primaryColor,
              unselectedItemColor: AppConstants.textSecondary,
              backgroundColor: AppConstants.surfaceCard,
              onTap: _onItemTapped,
            ),
          ),
        },
      ),
    );
  }
}
