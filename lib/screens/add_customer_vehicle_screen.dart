import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';

class AddCustomerVehicleScreen extends StatelessWidget {
  const AddCustomerVehicleScreen({super.key});

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
          'Add Customer & Vehicle',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Customer Details Card
              _buildSectionCard(
                title: 'Customer Details',
                children: [
                  const CustomTextField(
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  const CustomTextField(
                    hintText: 'Phone',
                    icon: Icons.phone_outlined,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Vehicle Details Card
              _buildSectionCard(
                title: 'Vehicle Details',
                icon: Icons.directions_car_outlined,
                children: [
                  const CustomTextField(
                    hintText: 'Model Number*',
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Model Number is the primary Identifier',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.black38),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CustomTextField(
                    hintText: 'Vehicle Type',
                    icon: Icons.directions_car_outlined,
                    suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  const CustomTextField(
                    hintText: 'Brand',
                    icon: Icons.directions_car_outlined,
                  ),
                  const SizedBox(height: 16),
                  const CustomTextField(
                    hintText: 'Year',
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 16),
                  const CustomTextField(
                    hintText: 'Mileage (Km)',
                    icon: Icons.speed_outlined,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Action Button
              _buildSaveButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, IconData? icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 28, color: Colors.black),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF345880),
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
          const Icon(Icons.check, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            'Save & Add Service',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
