import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  final String id;
  final String ownerId;
  final String modelNumber;
  final String vehicleType;
  final String brand;
  final String year;
  final String mileage;
  final String averageDailyMileage;
  final String lastServiceDate; // YYYYMMDD
  final String nextServiceDate; // YYYYMMDD
  final DateTime? createdAt;

  VehicleModel({
    this.id = '',
    required this.ownerId,
    required this.modelNumber,
    this.vehicleType = '',
    this.brand = '',
    this.year = '',
    this.mileage = '',
    this.averageDailyMileage = '',
    this.lastServiceDate = '',
    this.nextServiceDate = '',
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
      averageDailyMileage: data['averageDailyMileage'] ?? '',
      lastServiceDate: data['lastServiceDate'] ?? '',
      nextServiceDate: data['nextServiceDate'] ?? '',
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
      'averageDailyMileage': averageDailyMileage,
      'lastServiceDate': lastServiceDate,
      'nextServiceDate': nextServiceDate,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  String get displayName => '$year $brand $modelNumber'.trim();

  /// Format YYYYMMDD string to YYYY-MM-DD for display
  static String formatDateForDisplay(String yyyymmdd) {
    if (yyyymmdd.length != 8) return yyyymmdd;
    return '${yyyymmdd.substring(0, 4)}-${yyyymmdd.substring(4, 6)}-${yyyymmdd.substring(6, 8)}';
  }
}
