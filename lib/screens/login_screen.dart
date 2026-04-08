import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import 'signup_screen.dart';
import 'vehicle_home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              // Car Logo
              Image.asset(
                'assets/images/car.png',
                width: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Colors.black54,
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Welcome Back',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Sign in to continue',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              
              // Email Field
              const CustomTextField(
                hintText: 'Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              
              // Password Field
              const CustomTextField(
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              
              // Sign In Button
              _buildSignInButton(context),
              const SizedBox(height: 24),
              
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E3A8A), // Dark blue
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const VehicleHomeScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: Text(
            'Sign in',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ),
      ),
    );
  }
}
