import 'package:flutter/material.dart';

class Customer {
  final String id;
  final String name;
  final String nic;
  final String phone;
  final String address;
  final String email;
  final List<String> purchasedVehicles; // Vehicle IDs or Names
  final String joinDate;
  final String branch;

  Customer({
    required this.id,
    required this.name,
    required this.nic,
    required this.phone,
    required this.address,
    required this.email,
    required this.purchasedVehicles,
    required this.joinDate,
    this.branch = 'Jaffna',
  });
}

class CustomerService {
  static final CustomerService _instance = CustomerService._internal();
  factory CustomerService() => _instance;
  CustomerService._internal();

  final ValueNotifier<List<Customer>> customersNotifier = ValueNotifier<List<Customer>>([
    Customer(
      id: 'CUS-001',
      name: 'Nimal Silva',
      nic: '123456789V',
      phone: '077 123 4567',
      address: '123 Galle Road, Colombo 03',
      email: 'nimal@example.com',
      purchasedVehicles: ['2024 BMW M5'],
      joinDate: '2026-02-18',
    ),
    Customer(
      id: 'CUS-002',
      name: 'Priya Fernando',
      nic: '987654321V',
      phone: '071 987 6543',
      address: '45 Kandy Road, Kiribathgoda',
      email: 'priya@example.com',
      purchasedVehicles: ['2024 Mercedes S-Class'],
      joinDate: '2026-02-17',
    ),
  ]);

  void addCustomer(Customer customer) {
    customersNotifier.value = [...customersNotifier.value, customer];
  }

  void addOrUpdateCustomer(Customer customer) {
    final existingIndex = customersNotifier.value.indexWhere((c) => c.nic == customer.nic);
    if (existingIndex != -1) {
      final existingCustomer = customersNotifier.value[existingIndex];
      // Merge purchased vehicles avoid duplicates
      List<String> updatedVehicles = [...existingCustomer.purchasedVehicles];
      for (var vehicle in customer.purchasedVehicles) {
        if (!updatedVehicles.contains(vehicle)) {
          updatedVehicles.add(vehicle);
        }
      }
      
      final updatedCustomer = Customer(
        id: existingCustomer.id,
        name: customer.name,
        nic: customer.nic,
        phone: customer.phone,
        address: customer.address,
        email: customer.email.isEmpty ? existingCustomer.email : customer.email,
        purchasedVehicles: updatedVehicles,
        joinDate: existingCustomer.joinDate,
        branch: existingCustomer.branch,
      );
      
      List<Customer> newList = [...customersNotifier.value];
      newList[existingIndex] = updatedCustomer;
      customersNotifier.value = newList;
    } else {
      customersNotifier.value = [...customersNotifier.value, customer];
    }
  }

  void removeCustomer(String id) {
    customersNotifier.value = customersNotifier.value.where((c) => c.id != id).toList();
  }
}

