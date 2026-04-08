import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/service_provider_card.dart';
import 'add_customer_vehicle_screen.dart';
import 'profile_screen.dart';

class ServiceProviderScreen extends StatelessWidget {
  const ServiceProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
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
                            'Service Provider',
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
                  Expanded(child: _buildStatItem('Vehicle', '5', const Color(0xFF1E3A8A))),
                  Container(width: 1, height: 40, color: Colors.black12),
                  Expanded(child: _buildStatItem('Service', '7', Colors.redAccent)),
                  Container(width: 1, height: 40, color: Colors.black12),
                  Expanded(child: _buildStatItem('Actives', '5', Colors.green)),
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
                  const ServiceProviderCard(
                    modelName: '2020 Toyota CAM-2020-001',
                    modelId: 'CAM-2020-001',
                    serviceCount: '3',
                    vehicleType: 'sedan',
                  ),
                  const ServiceProviderCard(
                    modelName: '2020 Toyota CAM-2020-001',
                    modelId: 'CAM-2020-001',
                    serviceCount: '3',
                    vehicleType: 'sedan',
                  ),
                  const ServiceProviderCard(
                    modelName: '2020 Toyota CAM-2020-001',
                    modelId: 'CAM-2020-001',
                    serviceCount: '3',
                    vehicleType: 'sedan',
                  ),
                  const ServiceProviderCard(
                    modelName: '2020 Toyota CAM-2020-001',
                    modelId: 'CAM-2020-001',
                    serviceCount: '3',
                    vehicleType: 'sedan',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerVehicleScreen()),
          );
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
