import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/customer.dart';
import '../models/invoice.dart';
import '../utils/pdf_helper.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Customer Details',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download, color: Color(0xFF2C3545)),
            onPressed: () => PdfHelper.viewCustomerPdf(customer),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoSection(
                    title: 'Personal Information',
                    icon: LucideIcons.user,
                    items: [
                      _buildInfoRow('Full Name', customer.name),
                      _buildInfoRow('NIC No', customer.nic),
                      _buildInfoRow('Register Date', customer.joinDate),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    title: 'Contact Details',
                    icon: LucideIcons.phone,
                    items: [
                      _buildInfoRow('Phone No', customer.phone),
                      _buildInfoRow('Email', customer.email),
                      _buildInfoRow('Address', customer.address),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    title: 'Purchase History',
                    icon: LucideIcons.car,
                    items: [
                      ValueListenableBuilder<List<Invoice>>(
                        valueListenable: InvoiceService().invoicesNotifier,
                        builder: (context, invoices, _) {
                          final customerInvoices = invoices.where((inv) => inv.customerNic == customer.nic).toList();
                          
                          if (customerInvoices.isEmpty) {
                            return const Text('No vehicles purchased yet.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
                          }
                          
                          return Column(
                            children: customerInvoices.map((inv) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inv.vehicleName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C3545)),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildDetailRow('Reg No', inv.registrationNo),
                                    _buildDetailRow('Chassis No', inv.chassisNo),
                                    _buildDetailRow('Engine No', inv.engineNo),
                                    _buildDetailRow('Date', inv.date),
                                    _buildDetailRow('Amount', 'Rs. ${inv.amount}'),
                                  ],
                                ),
                              ),
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => PdfHelper.downloadCustomerPdf(customer),
                      icon: const Icon(LucideIcons.fileText),
                      label: const Text('Share Customer PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3545),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2C3545).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Center(
              child: Icon(LucideIcons.user, color: Color(0xFF2C3545), size: 50),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            customer.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            customer.id,
            style: const TextStyle(
              color: Color(0xFF2C3545),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2C3545)),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(':', style: TextStyle(color: Color(0xFFD1D5DB))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}

