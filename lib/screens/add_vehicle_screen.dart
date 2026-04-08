import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/vehicle_model.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _modelNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  String _vehicleType = '';
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final List<String> _vehicleTypes = ['Sedan', 'SUV', 'Truck', 'Van', 'Motorcycle', 'Hatchback', 'Coupe'];

  @override
  void dispose() {
    _modelNumberController.dispose();
    _brandController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    final modelNumber = _modelNumberController.text.trim();
    if (modelNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model Number is required'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final vehicle = VehicleModel(
        ownerId: _authService.currentUser!.uid,
        modelNumber: modelNumber,
        vehicleType: _vehicleType,
        brand: _brandController.text.trim(),
        year: _yearController.text.trim(),
        mileage: _mileageController.text.trim(),
      );
      await _firestoreService.addVehicle(vehicle);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              
              CustomTextField(
                hintText: 'Model Number*',
                icon: Icons.description_outlined,
                controller: _modelNumberController,
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
              
              // Vehicle Type Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: _vehicleType.isEmpty ? null : _vehicleType,
                  decoration: InputDecoration(
                    hintText: 'Vehicle Type',
                    prefixIcon: const Icon(Icons.directions_car_outlined, color: Colors.black87),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    hintStyle: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
                  ),
                  items: _vehicleTypes.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: (value) => setState(() => _vehicleType = value ?? ''),
                ),
              ),
              const SizedBox(height: 24),
              
              CustomTextField(
                hintText: 'Brand',
                icon: Icons.directions_car_outlined,
                controller: _brandController,
              ),
              const SizedBox(height: 24),
              
              CustomTextField(
                hintText: 'Year',
                icon: Icons.calendar_today_outlined,
                controller: _yearController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              
              CustomTextField(
                hintText: 'Mileage (Km)',
                icon: Icons.speed_outlined,
                controller: _mileageController,
                keyboardType: TextInputType.number,
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
    return GestureDetector(
      onTap: _isLoading ? null : _saveVehicle,
      child: Container(
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
          if (_isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          else ...[
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
        ],
      ),
      ),
    );
  }
}
