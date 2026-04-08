import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceProviderCard extends StatelessWidget {
  final String modelName;
  final String modelId;
  final String serviceCount;
  final String vehicleType;

  const ServiceProviderCard({
    super.key,
    required this.modelName,
    required this.modelId,
    required this.serviceCount,
    required this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          // Leading Car Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5E7E9B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modelName,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  modelId,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Badges
                Row(
                  children: [
                    _buildBadge(
                      icon: Icons.handyman_outlined,
                      text: serviceCount,
                      color: const Color(0xFF90C2E7).withValues(alpha: 0.5),
                      textColor: const Color(0xFF1E3A8A),
                    ),
                    const SizedBox(width: 8),
                    _buildBadge(
                      text: vehicleType,
                      color: const Color(0xFFF0F0F0),
                      textColor: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Trailing Chevron
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildBadge({
    IconData? icon,
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }
}
