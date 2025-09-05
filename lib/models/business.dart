class Business {
  final String id;
  final String name;
  final String businessType;
  final String? description;
  final String ownerId;
  final String cooperativeId;
  final String? industry;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;
  final String? registrationNumber;
  final String? taxId;
  final String? bankAccount;
  final String? bankName;
  final double? annualRevenue;
  final int? employeeCount;
  final Map<String, dynamic>? registrationDocuments;
  final String approvalStatus;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Business({
    required this.id,
    required this.name,
    required this.businessType,
    this.description,
    required this.ownerId,
    required this.cooperativeId,
    this.industry,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.registrationNumber,
    this.taxId,
    this.bankAccount,
    this.bankName,
    this.annualRevenue,
    this.employeeCount,
    this.registrationDocuments,
    required this.approvalStatus,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      businessType: json['business_type'],
      description: json['description'],
      ownerId: json['owner_id'],
      cooperativeId: json['cooperative_id'],
      industry: json['industry'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      registrationNumber: json['registration_number'],
      taxId: json['tax_id'],
      bankAccount: json['bank_account'],
      bankName: json['bank_name'],
      annualRevenue: json['annual_revenue']?.toDouble(),
      employeeCount: json['employee_count']?.toInt(),
      registrationDocuments: json['registration_documents'],
      approvalStatus: json['approval_status'] ?? 'pending',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_type': businessType,
      'description': description,
      'owner_id': ownerId,
      'cooperative_id': cooperativeId,
      'industry': industry,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'registration_number': registrationNumber,
      'tax_id': taxId,
      'bank_account': bankAccount,
      'bank_name': bankName,
      'annual_revenue': annualRevenue,
      'employee_count': employeeCount,
      'registration_documents': registrationDocuments,
      'approval_status': approvalStatus,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Business copyWith({
    String? id,
    String? name,
    String? businessType,
    String? description,
    String? ownerId,
    String? cooperativeId,
    String? industry,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? registrationNumber,
    String? taxId,
    String? bankAccount,
    String? bankName,
    double? annualRevenue,
    int? employeeCount,
    Map<String, dynamic>? registrationDocuments,
    String? approvalStatus,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      businessType: businessType ?? this.businessType,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      industry: industry ?? this.industry,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      taxId: taxId ?? this.taxId,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      annualRevenue: annualRevenue ?? this.annualRevenue,
      employeeCount: employeeCount ?? this.employeeCount,
      registrationDocuments: registrationDocuments ?? this.registrationDocuments,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isApproved => approvalStatus == 'approved';
  bool get isPending => approvalStatus == 'pending';
  bool get isRejected => approvalStatus == 'rejected';
}
