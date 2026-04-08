import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/summary_card.dart';
import '../widgets/vehicle_card.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import 'add_vehicle_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class VehicleHomeScreen extends StatefulWidget {
  const VehicleHomeScreen({super.key});

  @override
  State<VehicleHomeScreen> createState() => _VehicleHomeScreenState();
}

class _VehicleHomeScreenState extends State<VehicleHomeScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _user;
  List<VehicleModel> _vehicles = [];
  int _serviceCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    // Load user and vehicles independently
    final userFuture = _authService.getUserData(uid).catchError((_) => null);
    final vehiclesFuture = _firestoreService.getVehiclesForOwnerOnce(uid).catchError((_) => <VehicleModel>[]);

    final results = await Future.wait([userFuture, vehiclesFuture]);

    final user = results[0] as UserModel?;
    final vehicles = results[1] as List<VehicleModel>;
    final vehicleIds = vehicles.map((v) => v.id).toList();

    int serviceCount = 0;
    if (vehicleIds.isNotEmpty) {
      try {
        serviceCount = await _firestoreService.getServiceRecordCountForVehicles(vehicleIds);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _user = user;
      _vehicles = vehicles;
      _serviceCount = serviceCount;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Profile and Header
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF5E7E9B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                                    Text(
                        _user?.fullName ?? 'My Vehicle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationScreen()),
                          );
                        },
                        child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Vehicle',
                          count: '${_vehicles.length}',
                          icon: Icons.directions_car_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Services',
                          count: '$_serviceCount',
                          icon: Icons.build_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // "Add New Vehicle" Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildAddNewVehicleButton(context),
            ),
            
            const SizedBox(height: 32),
            
            // List Title (Optional section header)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  if (_vehicles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'No vehicles yet. Add your first vehicle!',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.black38,
                        ),
                      ),
                    )
                  else
                    ..._vehicles.map((vehicle) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: VehicleCard(
                        vehicleId: vehicle.id,
                        title: vehicle.displayName,
                        subId: vehicle.modelNumber,
                        vehicleType: vehicle.vehicleType,
                        lastServiceDate: '-',
                        nextServiceStatus: '-',
                      ),
                    )),
                  const SizedBox(height: 100), // Reserve space for FAB/scrolling
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildAddNewVehicleButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
        );
        if (result == true) _loadData();
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF345880), // Deep blue-grey
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              'Add New Vehicle',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
        );
        if (result == true) _loadData();
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF345880),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Add Vehicle',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
