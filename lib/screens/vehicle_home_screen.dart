import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/summary_card.dart';
import '../widgets/vehicle_card.dart';
import 'add_vehicle_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class VehicleHomeScreen extends StatelessWidget {
  const VehicleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                            'My Vehicle',
                            style: GoogleFonts.inter(
                              fontSize: 28,
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
                  const Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Vehicle',
                          count: '5',
                          icon: Icons.directions_car_outlined,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Services',
                          count: '8',
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  VehicleCard(
                    title: '2020 Toyota CAM-2020-001',
                    subId: 'CAM-2020-001',
                    vehicleType: 'Sedan',
                    lastServiceDate: '12-12-2024',
                    nextServiceStatus: 'Overdue',
                    isOverdue: true,
                  ),
                  SizedBox(height: 100), // Reserve space for FAB/scrolling
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
        );
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
        );
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
