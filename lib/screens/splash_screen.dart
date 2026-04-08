import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Transition to LoginScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5E7E9B),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Image.asset(
                'assets/images/car.png',
                width: 140,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Colors.black54,
                  );
                },
              ),
              const SizedBox(height: 8),
              
              // "Vehicle Maintenance" Text
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Vehicle Maintenance',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              
              // "Tracker" Text
              Text(
                'Tracker',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFFEFEFE),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // Fading Circle Loader
              const SpinKitFadingCircle(
                color: Colors.white70,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
