import 'package:flutter/foundation.dart';
import 'branch.dart';

class BranchService {
  // Singleton pattern
  static final BranchService _instance = BranchService._internal();
  factory BranchService() => _instance;
  BranchService._internal();

  final ValueNotifier<List<Branch>> branchesNotifier = ValueNotifier<List<Branch>>([
    // Mock data for initial testing
    Branch(
      id: 'BR-1',
      name: 'Poonakari Branch',
      code: 'PNK01',
      address: '123 Main Junction, Poonakari',
      phone: '+94771234567',
      email: 'poonakari@jaffnavehiclespot.com',
      managerName: 'Kumar Silva',
      managerContact: '+94771234568',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Branch(
      id: 'BR-2',
      name: 'Kilinochchi Branch',
      code: 'KLN01',
      address: '45 A9 Road, Kilinochchi',
      phone: '+94772345678',
      email: 'kilinochchi@jaffnavehiclespot.com',
      managerName: 'Ravi Fernando',
      managerContact: '+94772345679',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
  ]);

  List<Branch> get allBranches => branchesNotifier.value;

  void addBranch(Branch branch) {
    branchesNotifier.value = [...branchesNotifier.value, branch];
  }

  void updateBranch(Branch branch) {
    final index = branchesNotifier.value.indexWhere((b) => b.id == branch.id);
    if (index != -1) {
      final newList = List<Branch>.from(branchesNotifier.value);
      newList[index] = branch;
      branchesNotifier.value = newList;
    }
  }

  void deleteBranch(String branchId) {
    branchesNotifier.value = branchesNotifier.value.where((b) => b.id != branchId).toList();
  }

  bool isCodeUnique(String code, {String? excludeBranchId}) {
    return !branchesNotifier.value.any((b) => b.code.toLowerCase() == code.toLowerCase() && b.id != excludeBranchId);
  }
}
