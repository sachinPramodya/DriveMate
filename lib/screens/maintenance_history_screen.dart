import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/history_card.dart';

class MaintenanceHistoryScreen extends StatelessWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Maintenance History',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHistoryItem('FilterReplacement', '2024-03-12', '45235 Miles', 'LKR 300.00'),
            _buildHistoryItem('TireRotation', '2024-03-12', '45235 Miles', 'LKR 300.00'),
            _buildHistoryItem('OilChange', '2024-03-12', '45235 Miles', 'LKR 300.00'),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHistoryItem(String title, String date, String mileage, String cost) {
    return HistoryCard(
      title: title,
      date: date,
      mileage: mileage,
      cost: cost,
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF5E7E9B),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 32),
    );
  }
}
