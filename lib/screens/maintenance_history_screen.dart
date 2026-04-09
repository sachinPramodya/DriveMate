import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/history_card.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/service_record_model.dart';
import '../models/service_metadata_model.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  final String vehicleId;
  final String? serviceProviderId;

  const MaintenanceHistoryScreen({
    super.key,
    this.vehicleId = '',
    this.serviceProviderId,
  });

  @override
  State<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  String? _userType;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    try {
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        final user = await _authService.getUserData(uid);
        if (mounted) {
          setState(() => _userType = user.userType);
        }
      }
    } catch (_) {
      // Silently fail if user data cannot be loaded
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
          'Maintenance History',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: widget.vehicleId.isEmpty
          ? Center(
              child: Text(
                'No vehicle selected',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
              ),
            )
          : StreamBuilder<List<ServiceRecordModel>>(
              stream: _firestoreService.getServiceRecordsForVehicle(widget.vehicleId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final records = snapshot.data ?? [];
                if (records.isEmpty) {
                  return Center(
                    child: Text(
                      'No service records yet',
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ...records.map((record) => HistoryCard(
                        title: record.title,
                        date: record.date,
                        mileage: record.mileage,
                        cost: record.cost,
                      )),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: widget.vehicleId.isNotEmpty && _userType == 'service_provider' ? _buildFAB() : null,
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => _showAddRecordDialog(),
      child: Container(
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
      ),
    );
  }

  void _showAddRecordDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final mileageController = TextEditingController();
    final costController = TextEditingController();
    final notesController = TextEditingController();
    DateTime? selectedDate;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF345880),
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setDialogState(() {
                  selectedDate = picked;
                  dateController.text =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Add Service Record',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      hintText: 'Service Title (e.g. Oil Change)',
                      icon: Icons.build_outlined,
                      controller: titleController,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: 'Service Date',
                          icon: Icons.calendar_today_outlined,
                          controller: dateController,
                          suffixIcon: const Icon(Icons.date_range, color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Current Mileage (Km)',
                      icon: Icons.speed_outlined,
                      controller: mileageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Cost (e.g. LKR 300.00)',
                      icon: Icons.attach_money,
                      controller: costController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Notes (optional)',
                      icon: Icons.notes_outlined,
                      controller: notesController,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: isSaving
                          ? null
                          : () async {
                              if (titleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service title is required'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }
                              if (selectedDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a service date'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }
                              setDialogState(() => isSaving = true);
                              try {
                                final record = ServiceRecordModel(
                                  vehicleId: widget.vehicleId,
                                  serviceProviderId: widget.serviceProviderId ?? _authService.currentUser!.uid,
                                  title: titleController.text.trim(),
                                  date: dateController.text.trim(),
                                  mileage: mileageController.text.trim(),
                                  cost: costController.text.trim(),
                                  notes: notesController.text.trim(),
                                );
                                await _firestoreService.addServiceRecord(record);

                                // Calculate lastServiceDate in YYYYMMDD
                                final lastServiceDate =
                                    '${selectedDate!.year}${selectedDate!.month.toString().padLeft(2, '0')}${selectedDate!.day.toString().padLeft(2, '0')}';

                                // Calculate nextServiceDate
                                String nextServiceDate = '';
                                final vehicle = await _firestoreService.getVehicleById(widget.vehicleId);
                                if (vehicle != null) {
                                  final avgDaily = double.tryParse(vehicle.averageDailyMileage) ?? 0;
                                  if (avgDaily > 0) {
                                    // Get service metadata for this vehicle type
                                    ServiceMetaDataModel? meta;
                                    if (vehicle.vehicleType.isNotEmpty) {
                                      meta = await _firestoreService.getServiceMetaData(vehicle.vehicleType);
                                    }
                                    meta ??= ServiceMetaDataModel.defaults[vehicle.vehicleType] ??
                                        ServiceMetaDataModel(vehicleType: '', regularServiceKm: 5000, tyreChangeKm: 40000, oilChangeKm: 5000);

                                    final serviceIntervalKm = meta.getIntervalForServiceType(titleController.text.trim());
                                    final daysUntilNext = (serviceIntervalKm / avgDaily).ceil();
                                    final nextDate = selectedDate!.add(Duration(days: daysUntilNext));
                                    nextServiceDate =
                                        '${nextDate.year}${nextDate.month.toString().padLeft(2, '0')}${nextDate.day.toString().padLeft(2, '0')}';
                                  }

                                  // Update vehicle with new dates and mileage
                                  await _firestoreService.updateVehicleServiceDates(
                                    vehicleId: widget.vehicleId,
                                    lastServiceDate: lastServiceDate,
                                    nextServiceDate: nextServiceDate.isNotEmpty ? nextServiceDate : vehicle.nextServiceDate,
                                    mileage: mileageController.text.trim().isNotEmpty
                                        ? mileageController.text.trim()
                                        : vehicle.mileage,
                                  );

                                  // Regenerate notifications
                                  if (nextServiceDate.isNotEmpty) {
                                    await _firestoreService.regenerateNotificationsForVehicle(
                                      vehicleId: widget.vehicleId,
                                      ownerId: vehicle.ownerId,
                                      vehicleName: vehicle.displayName,
                                      nextServiceDate: nextServiceDate,
                                      force: true,
                                    );
                                  }
                                }

                                if (context.mounted) Navigator.of(context).pop();
                              } catch (e) {
                                setDialogState(() => isSaving = false);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
                                  );
                                }
                              }
                            },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF345880),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  'Save Record',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
