class Branch {
  final String id;
  final String name;
  final String code; // Unique
  final String address;
  final String phone;
  final String email;
  final String managerName;
  final String managerContact;
  final bool isActive;
  final DateTime createdAt;

  Branch({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.phone,
    required this.email,
    required this.managerName,
    required this.managerContact,
    this.isActive = true,
    required this.createdAt,
  });

  Branch copyWith({
    String? id,
    String? name,
    String? code,
    String? address,
    String? phone,
    String? email,
    String? managerName,
    String? managerContact,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      managerName: managerName ?? this.managerName,
      managerContact: managerContact ?? this.managerContact,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
