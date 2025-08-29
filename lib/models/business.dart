class Business {
  final String id;
  final String name;
  final String businessType;
  final String? description;
  final String ownerId;
  final String cooperativeId;
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
