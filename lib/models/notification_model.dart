import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId; // vehicle owner uid
  final String vehicleId;
  final String vehicleName; // display name for notification text
  final String type; // 'upcoming' or 'overdue'
  final String title;
  final String message;
  final String nextServiceDate; // YYYYMMDD
  final bool isDismissed;
  final DateTime? createdAt;

  NotificationModel({
    this.id = '',
    required this.userId,
    required this.vehicleId,
    this.vehicleName = '',
    required this.type,
    required this.title,
    required this.message,
    this.nextServiceDate = '',
    this.isDismissed = false,
    this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      vehicleName: data['vehicleName'] ?? '',
      type: data['type'] ?? 'upcoming',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      nextServiceDate: data['nextServiceDate'] ?? '',
      isDismissed: data['isDismissed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'type': type,
      'title': title,
      'message': message,
      'nextServiceDate': nextServiceDate,
      'isDismissed': isDismissed,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
