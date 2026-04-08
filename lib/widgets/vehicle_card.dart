import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/maintenance_history_screen.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleId;
  final String title;
  final String subId;
  final String vehicleType;
  final String lastServiceDate;
  final String nextServiceStatus;
  final bool isOverdue;

  const VehicleCard({
    super.key,
    this.vehicleId = '',
    required this.title,
    required this.subId,
    required this.vehicleType,
    required this.lastServiceDate,
    required this.nextServiceStatus,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Header section
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF5E7E9B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subId,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF90C2E7).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  vehicleType,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Service section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(child: _buildServiceInfo('Last Service', lastServiceDate, icon: Icons.handyman_outlined)),
                Container(width: 1, height: 40, color: Colors.black12),
                Expanded(child: _buildServiceInfo('Next Service', nextServiceStatus, icon: Icons.calendar_today_outlined, isHighlight: isOverdue)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Buttons section
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'History',
                  Icons.hourglass_empty,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaintenanceHistoryScreen(vehicleId: vehicleId),
                      ),
                    );
                  },
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Details',
                  Icons.info_outline,
                  onTap: () {},
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfo(String label, String value, {required IconData icon, bool isHighlight = false}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isHighlight ? Colors.redAccent : const Color(0xFF5E7E9B),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, {required VoidCallback onTap, bool isPrimary = false}) {
    final bgColor = isPrimary ? const Color(0xFF345880) : Colors.white;
    final textColor = isPrimary ? Colors.white : Colors.black;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
