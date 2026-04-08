import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/history_card.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/service_record_model.dart';

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
      floatingActionButton: widget.vehicleId.isNotEmpty ? _buildFAB() : null,
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
                    CustomTextField(
                      hintText: 'Date (YYYY-MM-DD)',
                      icon: Icons.calendar_today_outlined,
                      controller: dateController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Mileage',
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
