import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../models/service_provider_vehicle_model.dart';

class AddCustomerVehicleScreen extends StatefulWidget {
  const AddCustomerVehicleScreen({super.key});

  @override
  State<AddCustomerVehicleScreen> createState() => _AddCustomerVehicleScreenState();
}

class _AddCustomerVehicleScreenState extends State<AddCustomerVehicleScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  UserModel? _foundCustomer;
  List<VehicleModel> _customerVehicles = [];
  VehicleModel? _selectedVehicle;
  bool _isSearching = false;
  bool _isSaving = false;
  String? _searchMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _searchCustomer() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Please enter a customer email');
      return;
    }

    setState(() {
      _isSearching = true;
      _searchMessage = null;
      _foundCustomer = null;
      _customerVehicles = [];
      _selectedVehicle = null;
    });

    try {
      final customer = await _firestoreService.getUserByEmail(email);
      if (customer == null) {
        setState(() {
          _searchMessage = 'No customer found with this email';
          _isSearching = false;
        });
        return;
      }

      final vehicles = await _firestoreService.getVehiclesForOwnerOnce(customer.uid);
      setState(() {
        _foundCustomer = customer;
        _customerVehicles = vehicles;
        _phoneController.text = customer.phone;
        _isSearching = false;
        if (vehicles.isEmpty) {
          _searchMessage = 'Customer found but has no vehicles registered';
        }
      });
    } catch (e) {
      setState(() {
        _searchMessage = 'Error searching: $e';
        _isSearching = false;
      });
    }
  }

  Future<void> _saveAndAddService() async {
    if (_selectedVehicle == null) {
      _showError('Please select a vehicle');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final link = ServiceProviderVehicleModel(
        serviceProviderId: _authService.currentUser!.uid,
        vehicleId: _selectedVehicle!.id,
        customerEmail: _emailController.text.trim(),
      );
      await _firestoreService.addServiceProviderVehicle(link);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      _showError('Error saving: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Customer Email',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _isSearching ? null : _searchCustomer,
                        child: Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFF345880),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _isSearching
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  if (_searchMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _searchMessage!,
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                  if (_foundCustomer != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Found: ${_foundCustomer!.fullName} (${_foundCustomer!.email})',
                              style: GoogleFonts.inter(fontSize: 14, color: Colors.green.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Phone',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    enabled: false,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Vehicle Selection Card
              if (_customerVehicles.isNotEmpty)
                _buildSectionCard(
                  title: 'Select Vehicle',
                  icon: Icons.directions_car_outlined,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                      ),
                      child: DropdownButtonFormField<VehicleModel>(
                        initialValue: _selectedVehicle,
                        decoration: InputDecoration(
                          hintText: 'Select a vehicle',
                          prefixIcon: const Icon(Icons.directions_car_outlined, color: Colors.black87),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                          hintStyle: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
                        ),
                        items: _customerVehicles.map((vehicle) => DropdownMenuItem(
                          value: vehicle,
                          child: Text('${vehicle.modelNumber} - ${vehicle.brand}'),
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedVehicle = value),
                      ),
                    ),
                    if (_selectedVehicle != null) ...[
                      const SizedBox(height: 20),
                      _buildVehicleDetail('Model Number', _selectedVehicle!.modelNumber),
                      _buildVehicleDetail('Vehicle Type', _selectedVehicle!.vehicleType),
                      _buildVehicleDetail('Brand', _selectedVehicle!.brand),
                      _buildVehicleDetail('Year', _selectedVehicle!.year),
                      _buildVehicleDetail('Mileage', '${_selectedVehicle!.mileage} Km'),
                    ],
                  ],
                ),
              
              const SizedBox(height: 32),
              
              // Action Button
              if (_selectedVehicle != null) _buildSaveButton(context),
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
    return GestureDetector(
      onTap: _isSaving ? null : _saveAndAddService,
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
          if (_isSaving)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          else ...[
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
        ],
      ),
      ),
    );
  }

  Widget _buildVehicleDetail(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black45),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
