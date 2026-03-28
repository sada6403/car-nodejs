import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/vehicle.dart';
import 'package:intl/intl.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _chassisController = TextEditingController();
  final _engineController = TextEditingController();
  final _regController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedCategory = 'Car';
  final List<String> _categories = ['Car', 'Van', 'Load Vehicle', 'Electric'];

  @override
  void dispose() {
    _nameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _chassisController.dispose();
    _engineController.dispose();
    _regController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      
      final newVehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        make: _makeController.text,
        model: _modelController.text,
        category: _selectedCategory,
        price: _amountController.text,
        status: 'Available',
        imagePath: 'assets/toyota_chr.png', // Default placeholder
        chassisNo: _chassisController.text,
        engineNo: _engineController.text,
        registrationNo: _regController.text,
        color: _colorController.text,
        yearOfManufacture: _yearController.text,
        stockUpdateDate: formattedDate,
      );

      VehicleService().addVehicle(newVehicle);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle added successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Add New Vehicle',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
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
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              _buildDropdownField('Vehicle Type', _selectedCategory, _categories, (val) {
                setState(() => _selectedCategory = val!);
              }),
              const SizedBox(height: 16),
              _buildTextField('Vehicle Name', _nameController, 'e.g. TOYOTA C-HR'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Make', _makeController, 'e.g. Toyota')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Model', _modelController, 'e.g. C-HR')),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Technical Details'),
              const SizedBox(height: 16),
              _buildTextField('Chassis Number', _chassisController, 'e.g. MH95S-285447'),
              const SizedBox(height: 16),
              _buildTextField('Engine Number', _engineController, 'e.g. R06D-WA04C'),
              const SizedBox(height: 16),
              _buildTextField('Registration Number', _regController, 'e.g. NP CBR-3153'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Colour', _colorController, 'e.g. PEARL WHITE')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Year', _yearController, 'e.g. 2025', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Pricing'),
              const SizedBox(height: 16),
              _buildTextField('Amount (e.g. 12.5M or 778,970)', _amountController, 'Enter price', prefix: 'Rs. '),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3545),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add Vehicle to Stocks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget _buildTextField(String label, TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text, String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
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

