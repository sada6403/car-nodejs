import 'package:flutter/foundation.dart';

enum InvoiceStatus { paid, pending, overdue }

class Invoice {
  final String id;
  final String customerName;
  final String customerAddress;
  final String customerContact;
  final String customerNic;
  final String vehicleName;
  final String chassisNo;
  final String engineNo;
  final String registrationNo;
  final String vehicleType;
  final String fuelType;
  final String color;
  final String year;
  final String amount;
  final String leaseAmount;
  final String date;
  final InvoiceStatus status;
  final String salesPersonId;
  final String? commissionId;

  Invoice({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerContact,
    required this.customerNic,
    required this.vehicleName,
    required this.chassisNo,
    required this.engineNo,
    required this.registrationNo,
    required this.vehicleType,
    required this.fuelType,
    required this.color,
    required this.year,
    required this.amount,
    required this.leaseAmount,
    required this.date,
    required this.status,
    this.salesPersonId = '',
    this.commissionId,
  });
}

class InvoiceService {
  static final InvoiceService _instance = InvoiceService._internal();
  factory InvoiceService() => _instance;
  InvoiceService._internal();

  final ValueNotifier<List<Invoice>> invoicesNotifier = ValueNotifier<List<Invoice>>([
    Invoice(
      id: 'INV-001',
      customerName: 'Nimal Silva',
      customerAddress: 'Colombo',
      customerContact: '0771234567',
      customerNic: '123456789V',
      vehicleName: '2024 BMW M5',
      vehicleType: 'Car',
      fuelType: 'Petrol',
      chassisNo: 'CH-BMW-001',
      engineNo: 'EN-BMW-001',
      registrationNo: 'WP AB 1234',
      color: 'Black',
      year: '2024',
      amount: '24,500,000',
      leaseAmount: '15,000,000',
      date: '2026-02-18',
      status: InvoiceStatus.paid,
      salesPersonId: 'staff_jaffna',
    ),
    // ... other mock invoices can be added similarly if needed
  ]);

  void addInvoice(Invoice invoice) {
    invoicesNotifier.value = [...invoicesNotifier.value, invoice];
  }
}

