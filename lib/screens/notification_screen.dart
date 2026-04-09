import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/notification_card.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _dismissNotification(String notificationId) async {
    try {
      await _firestoreService.dismissNotification(notificationId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _authService.currentUser?.uid;

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
      body: uid == null
          ? Center(
              child: Text(
                'Please sign in to view notifications',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
              ),
            )
          : StreamBuilder<List<NotificationModel>>(
              stream: _firestoreService.getNotificationsForUser(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notifications = snapshot.data ?? [];

                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off_outlined, size: 64, color: Colors.black26),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
                        ),
                      ],
                    ),
                  );
                }

                final overdue = notifications.where((n) => n.type == 'overdue').toList();
                final upcoming = notifications.where((n) => n.type == 'upcoming').toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      if (overdue.isNotEmpty) ...[
                        Text(
                          'Overdue',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...overdue.map((n) => NotificationCard(
                          type: NotificationType.overdue,
                          title: n.title,
                          message: n.message,
                          date: n.nextServiceDate.length == 8
                              ? '${n.nextServiceDate.substring(0, 4)}-${n.nextServiceDate.substring(4, 6)}-${n.nextServiceDate.substring(6, 8)}'
                              : '',
                          onDismiss: () => _dismissNotification(n.id),
                        )),
                        const SizedBox(height: 32),
                      ],

                      if (upcoming.isNotEmpty) ...[
                        Text(
                          'Upcoming',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...upcoming.map((n) => NotificationCard(
                          type: NotificationType.upcoming,
                          title: n.title,
                          message: n.message,
                          date: n.nextServiceDate.length == 8
                              ? '${n.nextServiceDate.substring(0, 4)}-${n.nextServiceDate.substring(4, 6)}-${n.nextServiceDate.substring(6, 8)}'
                              : '',
                          onDismiss: () => _dismissNotification(n.id),
                        )),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
