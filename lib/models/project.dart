class Project {
  final String id;
  final String title;
  final String description;
  final String businessId;
  final double fundingGoal;
  final double? minimumFunding;
  final double currentFunding;
  final DateTime? fundingDeadline;
  final Map<String, dynamic>? profitSharingRatio;
  final String projectType;
  final String status;
  final List<Map<String, dynamic>>? milestones;
  final Map<String, dynamic>? documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.businessId,
    required this.fundingGoal,
    this.minimumFunding,
    required this.currentFunding,
    this.fundingDeadline,
    this.profitSharingRatio,
    required this.projectType,
    required this.status,
    this.milestones,
    this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      businessId: json['business_id'],
      fundingGoal: (json['funding_goal'] as num).toDouble(),
      minimumFunding: json['minimum_funding'] != null 
          ? (json['minimum_funding'] as num).toDouble() 
          : null,
      currentFunding: (json['current_funding'] as num?)?.toDouble() ?? 0.0,
      fundingDeadline: json['funding_deadline'] != null 
          ? DateTime.parse(json['funding_deadline']) 
          : null,
      profitSharingRatio: json['profit_sharing_ratio'],
      projectType: json['project_type'] ?? 'startup',
      status: json['status'] ?? 'draft',
      milestones: json['milestones'] != null 
          ? List<Map<String, dynamic>>.from(json['milestones']) 
          : null,
      documents: json['documents'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'business_id': businessId,
      'funding_goal': fundingGoal,
      'minimum_funding': minimumFunding,
      'current_funding': currentFunding,
      'funding_deadline': fundingDeadline?.toIso8601String(),
      'profit_sharing_ratio': profitSharingRatio,
      'project_type': projectType,
      'status': status,
      'milestones': milestones,
      'documents': documents,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? businessId,
    double? fundingGoal,
    double? minimumFunding,
    double? currentFunding,
    DateTime? fundingDeadline,
    Map<String, dynamic>? profitSharingRatio,
    String? projectType,
    String? status,
    List<Map<String, dynamic>>? milestones,
    Map<String, dynamic>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      businessId: businessId ?? this.businessId,
      fundingGoal: fundingGoal ?? this.fundingGoal,
      minimumFunding: minimumFunding ?? this.minimumFunding,
      currentFunding: currentFunding ?? this.currentFunding,
      fundingDeadline: fundingDeadline ?? this.fundingDeadline,
      profitSharingRatio: profitSharingRatio ?? this.profitSharingRatio,
      projectType: projectType ?? this.projectType,
      status: status ?? this.status,
      milestones: milestones ?? this.milestones,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status getters
  bool get isDraft => status == 'draft';
  bool get isSubmitted => status == 'submitted';
  bool get isApproved => status == 'approved';
  bool get isActive => status == 'active';
  bool get isFunded => status == 'funded';
  bool get isClosed => status == 'closed';

  // Funding progress
  double get fundingProgress => fundingGoal > 0 ? (currentFunding / fundingGoal) * 100 : 0;
  bool get isFullyFunded => currentFunding >= fundingGoal;
  bool get hasMinimumFunding => minimumFunding == null || currentFunding >= minimumFunding!;
  bool get isFundingExpired => fundingDeadline != null && DateTime.now().isAfter(fundingDeadline!);

  // Profit sharing helpers
  double get investorSharePercentage => (profitSharingRatio?['investor'] as num?)?.toDouble() ?? 70.0;
  double get businessSharePercentage => (profitSharingRatio?['business'] as num?)?.toDouble() ?? 30.0;
}
