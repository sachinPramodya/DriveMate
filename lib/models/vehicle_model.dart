import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  final String id;
  final String ownerId;
  final String modelNumber;
  final String vehicleType;
  final String brand;
  final String year;
  final String mileage;
  final DateTime? createdAt;

  VehicleModel({
    this.id = '',
    required this.ownerId,
    required this.modelNumber,
    this.vehicleType = '',
    this.brand = '',
    this.year = '',
    this.mileage = '',
    this.createdAt,
  });

  factory VehicleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VehicleModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      modelNumber: data['modelNumber'] ?? '',
      vehicleType: data['vehicleType'] ?? '',
      brand: data['brand'] ?? '',
      year: data['year'] ?? '',
      mileage: data['mileage'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'modelNumber': modelNumber,
      'vehicleType': vehicleType,
      'brand': brand,
      'year': year,
      'mileage': mileage,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  String get displayName => '$year $brand $modelNumber'.trim();
}
