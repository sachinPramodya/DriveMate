import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';
import '../models/service_record_model.dart';
import '../models/service_provider_vehicle_model.dart';
import '../models/service_metadata_model.dart';
import '../models/notification_model.dart';
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

  // ── Vehicle update helpers ──

  Future<void> updateVehicleServiceDates({
    required String vehicleId,
    required String lastServiceDate,
    required String nextServiceDate,
    required String mileage,
  }) async {
    await _firestore.collection('vehicles').doc(vehicleId).update({
      'lastServiceDate': lastServiceDate,
      'nextServiceDate': nextServiceDate,
      'mileage': mileage,
    });
  }

  // ── Service MetaData ──

  Future<ServiceMetaDataModel?> getServiceMetaData(String vehicleType) async {
    final snap = await _firestore
        .collection('service_metadata')
        .where('vehicleType', isEqualTo: vehicleType)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return ServiceMetaDataModel.fromFirestore(snap.docs.first);
  }

  Future<void> seedServiceMetaData() async {
    for (final entry in ServiceMetaDataModel.defaults.entries) {
      final existing = await _firestore
          .collection('service_metadata')
          .where('vehicleType', isEqualTo: entry.key)
          .limit(1)
          .get();
      if (existing.docs.isEmpty) {
        await _firestore.collection('service_metadata').add(entry.value.toMap());
      }
    }
  }

  // ── Notifications ──

  Future<DocumentReference> addNotification(NotificationModel notification) {
    return _firestore.collection('notifications').add(notification.toMap());
  }

  Stream<List<NotificationModel>> getNotificationsForUser(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
          list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          return list;
        });
  }

  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  /// Remove existing notifications for a vehicle and regenerate based on nextServiceDate
  Future<void> regenerateNotificationsForVehicle({
    required String vehicleId,
    required String ownerId,
    required String vehicleName,
    required String nextServiceDate,
  }) async {
    // Delete old notifications for this vehicle
    final existing = await _firestore
        .collection('notifications')
        .where('vehicleId', isEqualTo: vehicleId)
        .get();
    for (final doc in existing.docs) {
      await doc.reference.delete();
    }

    if (nextServiceDate.isEmpty || nextServiceDate.length != 8) return;

    final nextDate = DateTime.tryParse(
      '${nextServiceDate.substring(0, 4)}-${nextServiceDate.substring(4, 6)}-${nextServiceDate.substring(6, 8)}',
    );
    if (nextDate == null) return;

    final now = DateTime.now();
    final daysUntilService = nextDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    final formattedDate = VehicleModel.formatDateForDisplay(nextServiceDate);

    if (daysUntilService <= 7 && daysUntilService > 0) {
      // Upcoming notification - within a week
      await addNotification(NotificationModel(
        userId: ownerId,
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        type: 'upcoming',
        title: 'Service Due Soon',
        message: 'Your $vehicleName is due for service in $daysUntilService day${daysUntilService == 1 ? '' : 's'} (on $formattedDate). Schedule a service now.',
        nextServiceDate: nextServiceDate,
      ));
    } else if (daysUntilService <= 0) {
      // Overdue notification
      final overdueDays = daysUntilService.abs();
      await addNotification(NotificationModel(
        userId: ownerId,
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        type: 'overdue',
        title: 'Service Overdue',
        message: 'Your $vehicleName service is ${overdueDays > 0 ? '$overdueDays day${overdueDays == 1 ? '' : 's'} overdue' : 'due today'} (was due on $formattedDate). Schedule a service immediately.',
        nextServiceDate: nextServiceDate,
      ));
    }
  }

  /// Check all vehicles for a user and generate notifications
  Future<void> checkAndGenerateNotifications(String userId) async {
    final vehicles = await getVehiclesForOwnerOnce(userId);
    for (final vehicle in vehicles) {
      if (vehicle.nextServiceDate.isNotEmpty) {
        await regenerateNotificationsForVehicle(
          vehicleId: vehicle.id,
          ownerId: userId,
          vehicleName: vehicle.displayName,
          nextServiceDate: vehicle.nextServiceDate,
        );
      }
    }
  }
}
