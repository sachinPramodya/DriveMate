import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRecordModel {
  final String id;
  final String vehicleId;
  final String serviceProviderId;
  final String title;
  final String date;
  final String mileage;
  final String cost;
  final String notes;
  final DateTime? createdAt;

  ServiceRecordModel({
    this.id = '',
    required this.vehicleId,
    required this.serviceProviderId,
    required this.title,
    required this.date,
    this.mileage = '',
    this.cost = '',
    this.notes = '',
    this.createdAt,
  });

  factory ServiceRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceRecordModel(
      id: doc.id,
      vehicleId: data['vehicleId'] ?? '',
      serviceProviderId: data['serviceProviderId'] ?? '',
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      mileage: data['mileage'] ?? '',
      cost: data['cost'] ?? '',
      notes: data['notes'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'serviceProviderId': serviceProviderId,
      'title': title,
      'date': date,
      'mileage': mileage,
      'cost': cost,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
