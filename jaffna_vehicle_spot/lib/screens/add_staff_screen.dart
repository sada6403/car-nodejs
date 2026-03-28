import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/staff.dart';
import '../models/email_service.dart';
import 'dart:math';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _fullNameController = TextEditingController();
  final _applicationPostController = TextEditingController();
  final _branchController = TextEditingController();
  final _postalAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _homeNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  bool _isSendingEmail = false;
  final _nicNoController = TextEditingController();
  final _spouseNameController = TextEditingController();
  final _spouseContactController = TextEditingController();
  final _spouseNicController = TextEditingController();
  final _spouseAddressController = TextEditingController();
  final _spouseRelationshipController = TextEditingController();
  final _olResultsController = TextEditingController();
  final _alResultsController = TextEditingController();
  final _otherQualificationsController = TextEditingController();
  final _offenseNatureController = TextEditingController();
  final _salaryAmountController = TextEditingController();
  final _salaryAllowanceController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _epfNoController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedCivilStatus = 'Single';
  StaffRole _selectedRole = StaffRole.salesPerson;
  bool _hasOffense = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _applicationPostController.dispose();
    _branchController.dispose();
    _postalAddressController.dispose();
    _permanentAddressController.dispose();
    _mobileNoController.dispose();
    _homeNoController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _nicNoController.dispose();
    _spouseNameController.dispose();
    _spouseContactController.dispose();
    _spouseNicController.dispose();
    _spouseAddressController.dispose();
    _spouseRelationshipController.dispose();
    _olResultsController.dispose();
    _alResultsController.dispose();
    _otherQualificationsController.dispose();
    _offenseNatureController.dispose();
    _salaryAmountController.dispose();
    _salaryAllowanceController.dispose();
    _bankNameController.dispose();
    _bankBranchController.dispose();
    _accountNoController.dispose();
    _epfNoController.dispose();
    super.dispose();
  }

  String _generatePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSendingEmail = true);
      
      final now = DateTime.now();
      final String generatedPassword = _generatePassword();
      final String staffId = 'STF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      
      final newStaff = Staff(
        id: staffId,
        name: _fullNameController.text.split(' ').first, // Simple name for list view
        fullName: _fullNameController.text,
        role: _selectedRole,
        phone: _mobileNoController.text,
        mobileNo: _mobileNoController.text,
        homeNo: _homeNoController.text,
        email: _emailController.text,
        joinDate: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        applicationPost: _applicationPostController.text,
        branch: _branchController.text,
        postalAddress: _postalAddressController.text,
        permanentAddress: _permanentAddressController.text,
        gender: _selectedGender,
        civilStatus: _selectedCivilStatus,
        dob: _dobController.text,
        nicNo: _nicNoController.text,
        spouseName: _spouseNameController.text,
        spouseContact: _spouseContactController.text,
        spouseNic: _spouseNicController.text,
        spouseAddress: _spouseAddressController.text,
        spouseRelationship: _spouseRelationshipController.text,
        olResults: _olResultsController.text,
        alResults: _alResultsController.text,
        otherQualifications: _otherQualificationsController.text,
        hasOffense: _hasOffense,
        offenseNature: _offenseNatureController.text,
        salaryAmount: _salaryAmountController.text,
        salaryAllowance: _salaryAllowanceController.text,
        bankName: _bankNameController.text,
        bankBranch: _bankBranchController.text,
        accountNo: _accountNoController.text,
        epfNo: _epfNoController.text,
        username: _fullNameController.text.toLowerCase().replaceAll(' ', '_'),
        password: generatedPassword,
      );

      StaffService().addStaff(newStaff);

      // Send Email
      final bool emailSent = await EmailService.sendCredentialsEmail(
        recipientEmail: _emailController.text,
        staffName: _fullNameController.text,
        staffId: staffId,
        password: generatedPassword,
      );

      if (mounted) {
        setState(() => _isSendingEmail = false);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(emailSent 
              ? 'Staff member registered and email sent!' 
              : 'Staff registered, but email failed to send.'),
            backgroundColor: emailSent ? const Color(0xFF10B981) : Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Staff Registration',
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Application Summary'),
              const SizedBox(height: 16),
              _buildTextField('Application for the post of', _applicationPostController, 'e.g. Sales Executive'),
              const SizedBox(height: 16),
              _buildTextField('Branch', _branchController, 'e.g. Jaffna Main'),
              const SizedBox(height: 16),
              _buildDropdownField('System Role', _selectedRole.name, StaffRole.values.map((e) => e.name).toList(), (val) {
                setState(() => _selectedRole = StaffRole.values.firstWhere((e) => e.name == val));
              }),

              const SizedBox(height: 32),
              _buildSectionTitle('Personal Details'),
              const SizedBox(height: 16),
              _buildTextField('Name in Full', _fullNameController, 'Enter full name'),
              const SizedBox(height: 16),
              _buildTextField('NIC No.', _nicNoController, 'Enter NIC number'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Date of Birth', _dobController, 'YYYY-MM-DD')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField('Gender', _selectedGender, ['Male', 'Female', 'Other'], (val) {
                      setState(() => _selectedGender = val!);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdownField('Civil Status', _selectedCivilStatus, ['Single', 'Married', 'Other'], (val) {
                setState(() => _selectedCivilStatus = val!);
              }),

              const SizedBox(height: 32),
              _buildSectionTitle('Contact Information'),
              const SizedBox(height: 16),
              _buildTextField('Postal Address', _postalAddressController, 'Enter postal address', maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('Permanent Address', _permanentAddressController, 'Enter permanent address', maxLines: 2),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Mobile No.', _mobileNoController, 'e.g. 077 123 4567', keyboardType: TextInputType.phone)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Home No.', _homeNoController, 'e.g. 021 123 4567', keyboardType: TextInputType.phone)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('E-Mail Address', _emailController, 'e.g. name@example.com', keyboardType: TextInputType.emailAddress),

              const SizedBox(height: 32),
              _buildSectionTitle('Family / Emergency Contact'),
              const SizedBox(height: 16),
              _buildTextField('Spouse Name (if applicable)', _spouseNameController, 'Enter name'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('NIC No.', _spouseNicController, 'Enter NIC')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Contact No.', _spouseContactController, 'Enter phone', keyboardType: TextInputType.phone)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Address', _spouseAddressController, 'Enter address'),
              const SizedBox(height: 16),
              _buildTextField('Relationship to Employee', _spouseRelationshipController, 'e.g. Wife, Husband, Mother'),

              const SizedBox(height: 32),
              _buildSectionTitle('Educational Qualifications'),
              const SizedBox(height: 16),
              _buildTextField('G.C.E. Ordinary Level', _olResultsController, 'Summary of results', maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('G.C.E. Advanced Level', _alResultsController, 'Summary of results', maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('Other qualifications', _otherQualificationsController, 'Diplomas, Degrees etc.', maxLines: 3),

              const SizedBox(height: 32),
              _buildSectionTitle('Legal Declarations'),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Whether you are conflicted for any offence', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                value: _hasOffense,
                onChanged: (val) => setState(() => _hasOffense = val),
                activeThumbColor: const Color(0xFF2C3545),
              ),
              if (_hasOffense) 
                _buildTextField('Nature of the offense', _offenseNatureController, 'Please describe...', maxLines: 2),

              const SizedBox(height: 32),
              _buildSectionTitle('Financial & Banking'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Salary Amount', _salaryAmountController, 'Base salary', prefix: 'Rs. ')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Salary Allowance', _salaryAllowanceController, 'Total allowance', prefix: 'Rs. ')),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Bank Name', _bankNameController, 'e.g. Bank of Ceylon'),
              const SizedBox(height: 16),
              _buildTextField('Bank Branch', _bankBranchController, 'Enter branch name'),
              const SizedBox(height: 16),
              _buildTextField('Account No', _accountNoController, 'Enter account number'),
              const SizedBox(height: 16),
              _buildTextField('EPF No', _epfNoController, 'Enter EPF number'),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSendingEmail ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3545),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSendingEmail
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Register Staff Member',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text, String? prefix, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2C3545), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              if (label.contains('if applicable')) return null;
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(LucideIcons.chevronDown, size: 20),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF111827)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

