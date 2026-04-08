import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String userType; // 'vehicle_owner' or 'service_provider'
  final String phone;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.userType,
    this.phone = '',
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      userType: data['userType'] ?? 'vehicle_owner',
      phone: data['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'userType': userType,
      'phone': phone,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? userType,
    String? phone,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
    );
  }
}
