import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';
import '../models/service_record_model.dart';
import '../models/service_provider_vehicle_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Vehicles ──

  Future<DocumentReference> addVehicle(VehicleModel vehicle) {
    return _firestore.collection('vehicles').add(vehicle.toMap());
  }

  Stream<List<VehicleModel>> getVehiclesForOwner(String ownerId) {
    return _firestore
        .collection('vehicles')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) => VehicleModel.fromFirestore(doc)).toList();
          list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          return list;
        });
  }

  Future<List<VehicleModel>> getVehiclesForOwnerOnce(String ownerId) async {
    final snap = await _firestore
        .collection('vehicles')
        .where('ownerId', isEqualTo: ownerId)
        .get();
    final list = snap.docs.map((doc) => VehicleModel.fromFirestore(doc)).toList();
    list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    return list;
  }

  // ── Service Provider Vehicles (linking table) ──

  Future<DocumentReference> addServiceProviderVehicle(
      ServiceProviderVehicleModel link) {
    return _firestore.collection('service_provider_vehicles').add(link.toMap());
  }

  Stream<List<ServiceProviderVehicleModel>> getServiceProviderVehicles(
      String serviceProviderId) {
    return _firestore
        .collection('service_provider_vehicles')
        .where('serviceProviderId', isEqualTo: serviceProviderId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ServiceProviderVehicleModel.fromFirestore(doc))
            .toList());
  }

  Future<VehicleModel?> getVehicleById(String vehicleId) async {
    final doc = await _firestore.collection('vehicles').doc(vehicleId).get();
    if (!doc.exists) return null;
    return VehicleModel.fromFirestore(doc);
  }

  // ── Look up customer by email ──

  Future<UserModel?> getUserByEmail(String email) async {
    final snap = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return UserModel.fromFirestore(snap.docs.first);
  }

  // ── Service Records (maintenance history) ──

  Future<DocumentReference> addServiceRecord(ServiceRecordModel record) {
    return _firestore.collection('service_records').add(record.toMap());
  }

  Stream<List<ServiceRecordModel>> getServiceRecordsForVehicle(
      String vehicleId) {
    return _firestore
        .collection('service_records')
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) => ServiceRecordModel.fromFirestore(doc)).toList();
          list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          return list;
        });
  }

  Stream<List<ServiceRecordModel>> getServiceRecordsForProvider(
      String serviceProviderId) {
    return _firestore
        .collection('service_records')
        .where('serviceProviderId', isEqualTo: serviceProviderId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) => ServiceRecordModel.fromFirestore(doc)).toList();
          list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          return list;
        });
  }

  // ── Stats ──

  Future<int> getVehicleCountForOwner(String ownerId) async {
    final snap = await _firestore
        .collection('vehicles')
        .where('ownerId', isEqualTo: ownerId)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<int> getServiceRecordCountForVehicles(
      List<String> vehicleIds) async {
    if (vehicleIds.isEmpty) return 0;
    final snap = await _firestore
        .collection('service_records')
        .where('vehicleId', whereIn: vehicleIds)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<int> getLinkedVehicleCount(String serviceProviderId) async {
    final snap = await _firestore
        .collection('service_provider_vehicles')
        .where('serviceProviderId', isEqualTo: serviceProviderId)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<int> getServiceRecordCountForProvider(
      String serviceProviderId) async {
    final snap = await _firestore
        .collection('service_records')
        .where('serviceProviderId', isEqualTo: serviceProviderId)
        .count()
        .get();
    return snap.count ?? 0;
  }
}
