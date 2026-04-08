import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/vehicle_home_screen.dart';
import 'screens/add_vehicle_screen.dart';
import 'screens/maintenance_history_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/service_provider_screen.dart';
import 'screens/add_customer_vehicle_screen.dart';

void main() {
  runApp(const DriveMateApp());
}

class DriveMateApp extends StatelessWidget {
  const DriveMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5E7E9B)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const VehicleHomeScreen(),
        '/add-vehicle': (context) => const AddVehicleScreen(),
        '/maintenance-history': (context) => const MaintenanceHistoryScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/service-provider': (context) => const ServiceProviderScreen(),
        '/add-customer-vehicle': (context) => const AddCustomerVehicleScreen(),
      },
    );
  }
}
