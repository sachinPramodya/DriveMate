import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final uid = _authService.currentUser!.uid;
      final user = await _authService.getUserData(uid);
      if (!mounted) return;
      setState(() {
        _user = user;
        _nameController.text = user.fullName;
        _phoneController.text = user.phone;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;
    setState(() => _isLoading = true);
    try {
      final updatedUser = _user!.copyWith(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      await _authService.updateUserProfile(updatedUser);
      if (!mounted) return;
      setState(() {
        _user = updatedUser;
        _isEditing = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated'), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

    Future<void> _notifications() async {
    Navigator.of(context).pushNamedAndRemoveUntil('/notifications', (route) => false);
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
          'Profile & Setting',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined, color: Colors.black),
            onPressed: () {
              if (_isEditing) {
                // Cancel editing
                _nameController.text = _user?.fullName ?? '';
                _phoneController.text = _user?.phone ?? '';
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFC5E1FF),
                    child: Text(
                      _user?.fullName.isNotEmpty == true ? _user!.fullName[0].toUpperCase() : '?',
                      style: GoogleFonts.inter(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user?.fullName ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _user?.userType == 'service_provider' ? 'Service Provider' : 'Vehicle Owner',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Profile Details Card
            _isEditing
                ? _buildSectionCard(
                    title: 'Edit Profile',
                    children: [
                      CustomTextField(
                        hintText: 'Full Name',
                        icon: Icons.person,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Phone',
                        icon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _saveProfile,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF345880),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Save Changes',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : _buildSectionCard(
                    title: 'Profile',
                    children: [
                      _buildInfoRow(Icons.person, 'Full Name', _user?.fullName ?? ''),
                      const Divider(height: 32),
                      _buildInfoRow(Icons.email_outlined, 'Email', _user?.email ?? ''),
                      const Divider(height: 32),
                      _buildInfoRow(Icons.phone_outlined, 'Phone', _user?.phone.isNotEmpty == true ? _user!.phone : 'Not set'),
                    ],
                  ),
            
            const SizedBox(height: 24),
            
            // Settings Card
            _buildSectionCard(
              children: [
                GestureDetector(
                 onTap: _notifications,
                  child: _buildSettingRow(
                    Icons.notifications_none_rounded,
                    'Notifications',
                    subtitle: 'Service reminders and alerts',
                  ),
                ),
                const Divider(height: 24),
                GestureDetector(
                  onTap: _logout,
                  child: _buildSettingRow(
                    Icons.logout_rounded,
                    'Logout',
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({String? title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black26,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingRow(IconData icon, String label, {String? subtitle, Color? color}) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.black54,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
