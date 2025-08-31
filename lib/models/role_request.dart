import '../utils/role_constants.dart';

class RoleRequest {
  final String id;
  final String userId;
  final String requestedRole;
  final String reason;
  final String status; // pending, approved, rejected
  final String? approvedBy;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RoleRequest({
    required this.id,
    required this.userId,
    required this.requestedRole,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.rejectionReason,
    required this.createdAt,
    this.updatedAt,
  });

  factory RoleRequest.fromJson(Map<String, dynamic> json) {
    return RoleRequest(
      id: json['id'],
      userId: json['user_id'],
      requestedRole: json['requested_role'],
      reason: json['reason'],
      status: json['status'],
      approvedBy: json['approved_by'],
      rejectionReason: json['rejection_reason'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'requested_role': requestedRole,
      'reason': reason,
      'status': status,
      'approved_by': approvedBy,
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  RoleRequest copyWith({
    String? id,
    String? userId,
    String? requestedRole,
    String? reason,
    String? status,
    String? approvedBy,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoleRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      requestedRole: requestedRole ?? this.requestedRole,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  String get displayStatus {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  String get requestedRoleDisplayName => UserRoles.getDisplayName(requestedRole);
}
