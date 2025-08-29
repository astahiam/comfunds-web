class ProfitDistribution {
  final String id;
  final String projectId;
  final double? businessProfit;
  final DateTime? distributionDate;
  final double totalDistributed;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfitDistribution({
    required this.id,
    required this.projectId,
    this.businessProfit,
    this.distributionDate,
    required this.totalDistributed,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfitDistribution.fromJson(Map<String, dynamic> json) {
    return ProfitDistribution(
      id: json['id'],
      projectId: json['project_id'],
      businessProfit: json['business_profit'] != null 
          ? (json['business_profit'] as num).toDouble() 
          : null,
      distributionDate: json['distribution_date'] != null 
          ? DateTime.parse(json['distribution_date']) 
          : null,
      totalDistributed: (json['total_distributed'] as num).toDouble(),
      status: json['status'] ?? 'calculated',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'business_profit': businessProfit,
      'distribution_date': distributionDate?.toIso8601String(),
      'total_distributed': totalDistributed,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProfitDistribution copyWith({
    String? id,
    String? projectId,
    double? businessProfit,
    DateTime? distributionDate,
    double? totalDistributed,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfitDistribution(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      businessProfit: businessProfit ?? this.businessProfit,
      distributionDate: distributionDate ?? this.distributionDate,
      totalDistributed: totalDistributed ?? this.totalDistributed,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status getters
  bool get isCalculated => status == 'calculated';
  bool get isApproved => status == 'approved';
  bool get isDistributed => status == 'distributed';
}
