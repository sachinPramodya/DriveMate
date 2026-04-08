import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

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
          'Add Vehicle',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Vehicle Details',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              
              const CustomTextField(
                hintText: 'Model Number*',
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: 4),
              Text(
                'Model Number is the primary Identifier',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                hintText: 'Vehicle Type',
                icon: Icons.directions_car_outlined,
                suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                hintText: 'Brand',
                icon: Icons.directions_car_outlined,
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                hintText: 'Year',
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                hintText: 'Mileage (Km)',
                icon: Icons.speed_outlined,
              ),
              const SizedBox(height: 48),
              
              _buildSaveButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
            'Save Vehicle',
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
