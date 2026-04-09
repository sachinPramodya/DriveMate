import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceMetaDataModel {
  final String id;
  final String vehicleType; // e.g. 'Sedan', 'SUV', 'Truck', etc.
  final int regularServiceKm; // e.g. 5000
  final int tyreChangeKm; // e.g. 40000
  final int oilChangeKm; // e.g. 5000

  ServiceMetaDataModel({
    this.id = '',
    required this.vehicleType,
    required this.regularServiceKm,
    required this.tyreChangeKm,
    required this.oilChangeKm,
  });

  factory ServiceMetaDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceMetaDataModel(
      id: doc.id,
      vehicleType: data['vehicleType'] ?? '',
      regularServiceKm: (data['regularServiceKm'] ?? 5000) as int,
      tyreChangeKm: (data['tyreChangeKm'] ?? 40000) as int,
      oilChangeKm: (data['oilChangeKm'] ?? 5000) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicleType,
      'regularServiceKm': regularServiceKm,
      'tyreChangeKm': tyreChangeKm,
      'oilChangeKm': oilChangeKm,
    };
  }

  /// Get interval in km for a given service type
  int getIntervalForServiceType(String serviceTitle) {
    final lower = serviceTitle.toLowerCase();
    if (lower.contains('tyre') || lower.contains('tire')) {
      return tyreChangeKm;
    } else if (lower.contains('oil')) {
      return oilChangeKm;
    }
    return regularServiceKm;
  }

  /// Default metadata keyed by vehicle type
  static final Map<String, ServiceMetaDataModel> defaults = {
    'Sedan': ServiceMetaDataModel(vehicleType: 'Sedan', regularServiceKm: 5000, tyreChangeKm: 40000, oilChangeKm: 5000),
    'SUV': ServiceMetaDataModel(vehicleType: 'SUV', regularServiceKm: 5000, tyreChangeKm: 40000, oilChangeKm: 5000),
    'Truck': ServiceMetaDataModel(vehicleType: 'Truck', regularServiceKm: 8000, tyreChangeKm: 50000, oilChangeKm: 8000),
    'Van': ServiceMetaDataModel(vehicleType: 'Van', regularServiceKm: 7000, tyreChangeKm: 45000, oilChangeKm: 7000),
    'Motorcycle': ServiceMetaDataModel(vehicleType: 'Motorcycle', regularServiceKm: 3000, tyreChangeKm: 20000, oilChangeKm: 3000),
    'Hatchback': ServiceMetaDataModel(vehicleType: 'Hatchback', regularServiceKm: 5000, tyreChangeKm: 40000, oilChangeKm: 5000),
    'Coupe': ServiceMetaDataModel(vehicleType: 'Coupe', regularServiceKm: 5000, tyreChangeKm: 40000, oilChangeKm: 5000),
  };
}
