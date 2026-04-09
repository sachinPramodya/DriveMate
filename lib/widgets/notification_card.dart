import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum NotificationType { overdue, upcoming }

class NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String message;
  final String date;
  final VoidCallback? onDismiss;

  const NotificationCard({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.date,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Styling based on notification type
    final Color iconBgColor = type == NotificationType.overdue 
        ? const Color(0xFFE57373) // Reddish for overdue
        : const Color(0xFF5E7E9B); // Blueish for upcoming
    
    final IconData icon = type == NotificationType.overdue
        ? Icons.warning_amber_rounded
        : Icons.notifications_none_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon leading
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          
          // Content
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
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),

          // Dismiss button
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, color: Colors.black38, size: 20),
              ),
            ),
        ],
      ),
    );
  }
}
