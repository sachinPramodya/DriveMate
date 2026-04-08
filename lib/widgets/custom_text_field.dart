import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black87),
          suffixIcon: suffixIcon ?? (isPassword 
            ? const Icon(Icons.visibility, color: Colors.black87)
            : null),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          hintStyle: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
