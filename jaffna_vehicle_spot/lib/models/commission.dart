import 'package:flutter/foundation.dart';

enum CommissionType { fixed, percentage }

class Commission {
  final String id;
  final String invoiceId;
  final String agentName;
  final String agentContact;
  final String reference;
  final CommissionType type;
  final double amount;
  final String reason;
  final String date;

  Commission({
    required this.id,
    required this.invoiceId,
    required this.agentName,
    required this.agentContact,
    this.reference = '',
    required this.type,
    required this.amount,
    required this.reason,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'agentName': agentName,
      'agentContact': agentContact,
      'reference': reference,
      'type': type.index,
      'amount': amount,
      'reason': reason,
      'date': date,
    };
  }
}

class CommissionService {
  static final CommissionService _instance = CommissionService._internal();
  factory CommissionService() => _instance;
  CommissionService._internal();

  final ValueNotifier<List<Commission>> commissionsNotifier = ValueNotifier<List<Commission>>([]);

  void addCommission(Commission commission) {
    commissionsNotifier.value = [...commissionsNotifier.value, commission];
  }

  List<Commission> getCommissionsByAgent(String agentName) {
    return commissionsNotifier.value.where((c) => c.agentName == agentName).toList();
  }

  List<Commission> getCommissionsByDateRange(DateTime start, DateTime end) {
    return commissionsNotifier.value.where((c) {
      DateTime date = DateTime.parse(c.date);
      return date.isAfter(start.subtract(const Duration(days: 1))) && 
             date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}
