import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/branch.dart';
import '../models/branch_service.dart';

class BranchManagementScreen extends StatefulWidget {
  const BranchManagementScreen({super.key});

  @override
  State<BranchManagementScreen> createState() => _BranchManagementScreenState();
}

class _BranchManagementScreenState extends State<BranchManagementScreen> {
  final BranchService _branchService = BranchService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Branch Management', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<List<Branch>>(
        valueListenable: _branchService.branchesNotifier,
        builder: (context, branches, _) {
          if (branches.isEmpty) {
            return const Center(child: Text('No branches found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];
              return _buildBranchCard(branch);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditBranchDialog(),
        backgroundColor: const Color(0xFF2C3545),
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text('Add Branch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBranchCard(Branch branch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3545).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.building, color: Color(0xFF2C3545)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        branch.code,
                        style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: branch.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  branch.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: branch.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.user, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text('Manager: ${branch.managerName}', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(branch.managerContact, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  final updatedBranch = branch.copyWith(isActive: !branch.isActive);
                  _branchService.updateBranch(updatedBranch);
                },
                icon: Icon(
                  branch.isActive ? LucideIcons.ban : LucideIcons.checkCircle,
                  size: 16,
                  color: branch.isActive ? Colors.orange : Colors.green,
                ),
                label: Text(
                  branch.isActive ? 'Deactivate' : 'Activate',
                  style: TextStyle(color: branch.isActive ? Colors.orange : Colors.green),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddEditBranchDialog(branch: branch),
                icon: const Icon(LucideIcons.edit2, size: 16, color: Colors.blue),
                label: const Text('Edit', style: TextStyle(color: Colors.blue)),
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Branch'),
                      content: Text('Are you sure you want to delete ${branch.name}?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            _branchService.deleteBranch(branch.id);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                label: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddEditBranchDialog({Branch? branch}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: branch?.name);
    final codeController = TextEditingController(text: branch?.code);
    final addressController = TextEditingController(text: branch?.address);
    final phoneController = TextEditingController(text: branch?.phone);
    final emailController = TextEditingController(text: branch?.email);
    final managerNameController = TextEditingController(text: branch?.managerName);
    final managerContactController = TextEditingController(text: branch?.managerContact);
    bool isActive = branch?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(branch == null ? 'Add New Branch' : 'Edit Branch'),
            content: SizedBox(
              width: 500, // Make it wide enough for desktop
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField('Branch Name', nameController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField('Branch Code (Unique)', codeController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField('Address', addressController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField('Phone Number', phoneController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField('Email Address', emailController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField('Manager Name', managerNameController, required: true),
                      const SizedBox(height: 12),
                      _buildTextField('Manager Contact', managerContactController, required: true),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Branch Status (Active)'),
                        value: isActive,
                        onChanged: (val) {
                          setDialogState(() => isActive = val);
                        },
                        activeThumbColor: const Color(0xFF2C3545),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (!_branchService.isCodeUnique(codeController.text, excludeBranchId: branch?.id)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Branch Code must be unique')),
                      );
                      return;
                    }

                    final newBranch = Branch(
                      id: branch?.id ?? 'BR-${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text,
                      code: codeController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      managerName: managerNameController.text,
                      managerContact: managerContactController.text,
                      isActive: isActive,
                      createdAt: branch?.createdAt ?? DateTime.now(),
                    );

                    if (branch == null) {
                      _branchService.addBranch(newBranch);
                    } else {
                      _branchService.updateBranch(newBranch);
                    }

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C3545)),
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
