import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notification',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Overdue Section
            Text(
              'Overdue',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            const NotificationCard(
              type: NotificationType.overdue,
              title: 'Tire Rotation Overdue',
              message: 'Your Honda Civic tire rotation is 15 days overdue. Schedule a service',
              date: '2024-03-12',
            ),
            
            const SizedBox(height: 32),
            
            // Upcoming Section
            Text(
              'Upcoming',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const NotificationCard(
              type: NotificationType.upcoming,
              title: 'Oil Change Due Soon',
              message: 'Your Toyota Camry is due for an Oil change in 7 Days',
              date: '2024-03-12',
            ),
            const NotificationCard(
              type: NotificationType.upcoming,
              title: 'Oil Change Due Soon',
              message: 'Your Toyota Camry is due for an Oil change in 7 Days',
              date: '2024-03-12',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
