import 'package:cloud_firestore/cloud_firestore.dart';

/// Links a service provider to a customer's vehicle
class ServiceProviderVehicleModel {
  final String id;
  final String serviceProviderId;
  final String vehicleId;
  final String customerEmail;
  final DateTime? addedAt;

  ServiceProviderVehicleModel({
    this.id = '',
    required this.serviceProviderId,
    required this.vehicleId,
    required this.customerEmail,
    this.addedAt,
  });

  factory ServiceProviderVehicleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceProviderVehicleModel(
      id: doc.id,
      serviceProviderId: data['serviceProviderId'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      addedAt: (data['addedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceProviderId': serviceProviderId,
      'vehicleId': vehicleId,
      'customerEmail': customerEmail,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}
