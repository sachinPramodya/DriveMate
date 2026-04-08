import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/service_provider_card.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import 'add_customer_vehicle_screen.dart';
import 'maintenance_history_screen.dart';
import 'profile_screen.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _user;
  List<VehicleModel> _linkedVehicles = [];
  List<VehicleModel> _filteredVehicles = [];
  int _serviceCount = 0;
  int _activeCount = 0;
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final uid = _authService.currentUser!.uid;
      final user = await _authService.getUserData(uid);

      // Get linked vehicles
      final linksSnap = await _firestoreService.getServiceProviderVehicles(uid).first;
      final vehicles = <VehicleModel>[];
      for (final link in linksSnap) {
        final vehicle = await _firestoreService.getVehicleById(link.vehicleId);
        if (vehicle != null) vehicles.add(vehicle);
      }

      final serviceCount = await _firestoreService.getServiceRecordCountForProvider(uid);

      if (!mounted) return;
      setState(() {
        _user = user;
        _linkedVehicles = vehicles;
        _filteredVehicles = vehicles;
        _serviceCount = serviceCount;
        _activeCount = vehicles.length;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterVehicles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVehicles = _linkedVehicles;
      } else {
        _filteredVehicles = _linkedVehicles
            .where((v) => v.modelNumber.toLowerCase().contains(query.toLowerCase()) ||
                v.brand.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5E1FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.handyman_outlined, size: 40, color: Colors.blueGrey),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user?.fullName ?? 'Service Provider',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Auto Service Center',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: const Icon(Icons.settings_outlined, color: Colors.black45, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Stats Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(child: _buildStatItem('Vehicle', '${_linkedVehicles.length}', const Color(0xFF1E3A8A))),
                  Container(width: 1, height: 40, color: Colors.black12),
                  Expanded(child: _buildStatItem('Service', '$_serviceCount', Colors.redAccent)),
                  Container(width: 1, height: 40, color: Colors.black12),
                  Expanded(child: _buildStatItem('Actives', '$_activeCount', Colors.green)),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildSearchBar(),
            ),
            
            const SizedBox(height: 24),
            
            // Customer/Vehicle List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  if (_filteredVehicles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'No vehicles yet. Add a customer vehicle!',
                        style: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
                      ),
                    )
                  else
                    ..._filteredVehicles.map((vehicle) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaintenanceHistoryScreen(
                              vehicleId: vehicle.id,
                              serviceProviderId: _authService.currentUser!.uid,
                            ),
                          ),
                        );
                      },
                      child: ServiceProviderCard(
                        modelName: vehicle.displayName,
                        modelId: vehicle.modelNumber,
                        serviceCount: '0',
                        vehicleType: vehicle.vehicleType.isNotEmpty ? vehicle.vehicleType.toLowerCase() : 'vehicle',
                      ),
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerVehicleScreen()),
          );
          if (result == true) _loadData();
        },
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Icon(
          label == 'Vehicle' ? Icons.directions_car : (label == 'Service' ? Icons.handyman_outlined : Icons.trending_up),
          size: 24,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: color.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterVehicles,
        decoration: InputDecoration(
          hintText: 'Search by Model Number.....',
          hintStyle: GoogleFonts.inter(color: Colors.black38),
          icon: const Icon(Icons.search, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}
