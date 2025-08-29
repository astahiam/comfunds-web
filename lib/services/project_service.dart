import '../models/project.dart';
import 'api_service.dart';

class ProjectService {
  // Get all projects
  static Future<List<Project>> getProjects({
    int page = 1,
    int limit = 10,
    String? status,
    String? cooperativeId,
  }) async {
    try {
      String endpoint = '/projects?page=$page&limit=$limit';
      if (status != null) {
        endpoint += '&status=$status';
      }
      if (cooperativeId != null) {
        endpoint += '&cooperative_id=$cooperativeId';
      }
      
      final response = await ApiService.getPublic('/public/projects');
      final data = ApiService.parseResponse(response);
      
      return (data['data']['projects'] as List)
          .map((json) => Project.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get project by ID
  static Future<Project> getProject(String id) async {
    try {
      final response = await ApiService.get('/projects/$id');
      final data = ApiService.parseResponse(response);
      return Project.fromJson(data['project']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Create new project
  static Future<Project> createProject({
    required String title,
    required String description,
    required String businessId,
    required double fundingGoal,
    double? minimumFunding,
    DateTime? fundingDeadline,
    Map<String, dynamic>? profitSharingRatio,
    required String projectType,
    List<Map<String, dynamic>>? milestones,
    Map<String, dynamic>? documents,
  }) async {
    try {
      final response = await ApiService.post('/projects', {
        'title': title,
        'description': description,
        'business_id': businessId,
        'funding_goal': fundingGoal,
        'minimum_funding': minimumFunding,
        'funding_deadline': fundingDeadline?.toIso8601String(),
        'profit_sharing_ratio': profitSharingRatio,
        'project_type': projectType,
        'milestones': milestones,
        'documents': documents,
      });

      final data = ApiService.parseResponse(response);
      return Project.fromJson(data['project']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Update project
  static Future<Project> updateProject({
    required String id,
    String? title,
    String? description,
    double? fundingGoal,
    double? minimumFunding,
    DateTime? fundingDeadline,
    Map<String, dynamic>? profitSharingRatio,
    String? projectType,
    List<Map<String, dynamic>>? milestones,
    Map<String, dynamic>? documents,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (fundingGoal != null) updateData['funding_goal'] = fundingGoal;
      if (minimumFunding != null) updateData['minimum_funding'] = minimumFunding;
      if (fundingDeadline != null) updateData['funding_deadline'] = fundingDeadline.toIso8601String();
      if (profitSharingRatio != null) updateData['profit_sharing_ratio'] = profitSharingRatio;
      if (projectType != null) updateData['project_type'] = projectType;
      if (milestones != null) updateData['milestones'] = milestones;
      if (documents != null) updateData['documents'] = documents;

      final response = await ApiService.put('/projects/$id', updateData);
      final data = ApiService.parseResponse(response);
      return Project.fromJson(data['project']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Delete project
  static Future<void> deleteProject(String id) async {
    try {
      await ApiService.delete('/projects/$id');
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get projects by business
  static Future<List<Project>> getProjectsByBusiness(String businessId) async {
    try {
      final response = await ApiService.get('/projects/business/$businessId');
      final data = ApiService.parseResponse(response);
      
      return (data['projects'] as List)
          .map((json) => Project.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Submit project for approval
  static Future<Project> submitProject(String id) async {
    try {
      final response = await ApiService.post('/projects/$id/submit', {});
      final data = ApiService.parseResponse(response);
      return Project.fromJson(data['project']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get project investors
  static Future<List<dynamic>> getProjectInvestors(String id) async {
    try {
      final response = await ApiService.get('/projects/$id/investors');
      final data = ApiService.parseResponse(response);
      return data['investors'] as List;
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }
}
