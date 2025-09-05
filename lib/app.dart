import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/admin_register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/cooperative_admin_dashboard_screen.dart';
import 'screens/business/create_business_screen.dart';
import 'screens/projects/create_project_screen.dart';
import 'screens/projects/projects_screen.dart';
import 'screens/investment/investment_screen.dart';
import 'screens/pages/beranda_screen.dart';
import 'screens/pages/investasi_screen.dart';
import 'screens/pages/pembiayaan_screen.dart';
import 'screens/pages/kontak_screen.dart';
import 'utils/role_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        Widget initialScreen;
        
        if (user == null) {
          initialScreen = const LandingScreen();
        } else if (user.roles.contains(UserRoles.adminComfunds)) {
          initialScreen = const AdminDashboardScreen();
        } else if (user.roles.contains(UserRoles.adminCooperative)) {
          initialScreen = const CooperativeAdminDashboardScreen();
        } else if (user.roles.contains(UserRoles.admin) || user.roles.contains(UserRoles.cooperativeAdmin)) {
          initialScreen = const AdminDashboardScreen();
        } else {
          initialScreen = const DashboardScreen();
        }
        
        return MaterialApp(
          title: 'ComFunds',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          home: initialScreen,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/admin-register': (context) => const AdminRegisterScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/admin-dashboard': (context) => const AdminDashboardScreen(),
            '/cooperative-admin-dashboard': (context) => const CooperativeAdminDashboardScreen(),
            '/create-business': (context) => const CreateBusinessScreen(),
            '/create-project': (context) => const CreateProjectScreen(),
            '/projects': (context) => const ProjectsScreen(),
            '/investment': (context) => const InvestmentScreen(),
            '/beranda': (context) => const BerandaScreen(),
            '/investasi': (context) => const InvestasiScreen(),
            '/pembiayaan': (context) => const PembiayaanScreen(),
            '/kontak': (context) => const KontakScreen(),
          },
        );
      },
    );
  }

}
