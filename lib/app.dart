import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/project_provider.dart';
import 'providers/investment_provider.dart';
import 'providers/cooperative_provider.dart';
import 'providers/business_provider.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/admin_register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/cooperative_admin_dashboard_screen.dart';
import 'models/user.dart';
import 'utils/role_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => InvestmentProvider()),
        ChangeNotifierProvider(create: (_) => CooperativeProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ComFunds',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return _getInitialRoute(authProvider.user);
              },
            ),
            routes: {
              '/': (context) => const LandingScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/admin-register': (context) => const AdminRegisterScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/admin-dashboard': (context) => const AdminDashboardScreen(),
              '/cooperative-admin-dashboard': (context) => const CooperativeAdminDashboardScreen(),
            },
          );
        },
      ),
    );
  }

  String _getInitialRoute(User? user) {
    if (user == null) {
      return '/';
    }

    // Check if user has admin roles
    if (user.roles.contains(UserRoles.adminComfunds)) {
      return '/admin-dashboard';
    }
    
    if (user.roles.contains(UserRoles.adminCooperative)) {
      return '/cooperative-admin-dashboard';
    }
    
    if (user.roles.contains(UserRoles.admin) || user.roles.contains(UserRoles.cooperativeAdmin)) {
      return '/admin-dashboard';
    }

    // Regular users go to dashboard
    return '/dashboard';
  }
}
