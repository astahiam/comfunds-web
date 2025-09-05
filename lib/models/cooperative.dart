class Cooperative {
  final String id;
  final String name;
  final String registrationNumber;
  final String address;
  final String phone;
  final String email;
  final String bankAccount;
  final Map<String, dynamic>? profitSharingPolicy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cooperative({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.address,
    required this.phone,
    required this.email,
    required this.bankAccount,
    this.profitSharingPolicy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cooperative.fromJson(Map<String, dynamic> json) {
    return Cooperative(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registration_number'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      bankAccount: json['bank_account'],
      profitSharingPolicy: json['profit_sharing_policy'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'registration_number': registrationNumber,
      'address': address,
      'phone': phone,
      'email': email,
      'bank_account': bankAccount,
      'profit_sharing_policy': profitSharingPolicy,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Cooperative copyWith({
    String? id,
    String? name,
    String? registrationNumber,
    String? address,
    String? phone,
    String? email,
    String? bankAccount,
    Map<String, dynamic>? profitSharingPolicy,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cooperative(
      id: id ?? this.id,
      name: name ?? this.name,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bankAccount: bankAccount ?? this.bankAccount,
      profitSharingPolicy: profitSharingPolicy ?? this.profitSharingPolicy,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Cooperative empty() {
    return Cooperative(
      id: '',
      name: '',
      registrationNumber: '',
      address: '',
      phone: '',
      email: '',
      bankAccount: '',
      isActive: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
