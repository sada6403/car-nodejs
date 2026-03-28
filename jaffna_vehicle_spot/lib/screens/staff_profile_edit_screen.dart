import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/staff.dart';

class StaffProfileEditScreen extends StatefulWidget {
  final Staff staff;

  const StaffProfileEditScreen({super.key, required this.staff});

  @override
  State<StaffProfileEditScreen> createState() => _StaffProfileEditScreenState();
}

class _StaffProfileEditScreenState extends State<StaffProfileEditScreen> {
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _postalAddressController;
  late TextEditingController _permanentAddressController;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.staff.mobileNo);
    _emailController = TextEditingController(text: widget.staff.email);
    _postalAddressController = TextEditingController(text: widget.staff.postalAddress);
    _permanentAddressController = TextEditingController(text: widget.staff.permanentAddress);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    _postalAddressController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedStaff = widget.staff.copyWith(
      mobileNo: _mobileController.text,
      email: _emailController.text,
      postalAddress: _postalAddressController.text,
      permanentAddress: _permanentAddressController.text,
    );
    StaffService().updateStaff(updatedStaff);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details updated successfully'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Edit Account', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Contact Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 24),
            _buildInputField('Mobile Number', _mobileController, LucideIcons.phone),
            const SizedBox(height: 16),
            _buildInputField('Email Address', _emailController, LucideIcons.mail),
            const SizedBox(height: 32),
            const Text(
              'Addresses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 24),
            _buildInputField('Postal Address', _postalAddressController, LucideIcons.mapPin, maxLines: 3),
            const SizedBox(height: 16),
            _buildInputField('Permanent Address', _permanentAddressController, LucideIcons.home, maxLines: 3),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3545),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, size: 20, color: const Color(0xFF2C3545)) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
