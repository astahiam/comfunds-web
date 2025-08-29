class Investment {
  final String id;
  final String projectId;
  final String investorId;
  final double amount;
  final DateTime? investmentDate;
  final double profitSharingPercentage;
  final String status;
  final String? transactionRef;
  final DateTime createdAt;
  final DateTime updatedAt;

  Investment({
    required this.id,
    required this.projectId,
    required this.investorId,
    required this.amount,
    this.investmentDate,
    required this.profitSharingPercentage,
    required this.status,
    this.transactionRef,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      projectId: json['project_id'],
      investorId: json['investor_id'],
      amount: (json['amount'] as num).toDouble(),
      investmentDate: json['investment_date'] != null 
          ? DateTime.parse(json['investment_date']) 
          : null,
      profitSharingPercentage: (json['profit_sharing_percentage'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      transactionRef: json['transaction_ref'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'investor_id': investorId,
      'amount': amount,
      'investment_date': investmentDate?.toIso8601String(),
      'profit_sharing_percentage': profitSharingPercentage,
      'status': status,
      'transaction_ref': transactionRef,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Investment copyWith({
    String? id,
    String? projectId,
    String? investorId,
    double? amount,
    DateTime? investmentDate,
    double? profitSharingPercentage,
    String? status,
    String? transactionRef,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Investment(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      investorId: investorId ?? this.investorId,
      amount: amount ?? this.amount,
      investmentDate: investmentDate ?? this.investmentDate,
      profitSharingPercentage: profitSharingPercentage ?? this.profitSharingPercentage,
      status: status ?? this.status,
      transactionRef: transactionRef ?? this.transactionRef,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status getters
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isRefunded => status == 'refunded';

  // Helper methods
  bool get isActive => isConfirmed && !isRefunded;
}
