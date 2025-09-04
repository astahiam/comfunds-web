import '../models/investment.dart';
import 'api_service.dart';

class InvestmentService {
  // Get all investments
  static Future<List<Investment>> getInvestments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      String endpoint = '/investments?page=$page&limit=$limit';
      if (status != null) {
        endpoint += '&status=$status';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      
      return (data['investments'] as List)
          .map((json) => Investment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get investment by ID
  static Future<Investment> getInvestment(String id) async {
    try {
      final response = await ApiService.get('/investments/$id');
      final data = ApiService.parseResponse(response);
      return Investment.fromJson(data['investment']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Create new investment
  static Future<Investment> createInvestment({
    required String projectId,
    required String investorId,
    required double amount,
    double? profitSharingPercentage,
  }) async {
    try {
      final response = await ApiService.post('/investments', {
        'project_id': projectId,
        'investor_id': investorId,
        'amount': amount,
        'profit_sharing_percentage': profitSharingPercentage,
      });

      final data = ApiService.parseResponse(response);
      return Investment.fromJson(data['investment']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Update investment
  static Future<Investment> updateInvestment({
    required String id,
    double? amount,
    double? profitSharingPercentage,
    String? status,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (amount != null) updateData['amount'] = amount;
      if (profitSharingPercentage != null) updateData['profit_sharing_percentage'] = profitSharingPercentage;
      if (status != null) updateData['status'] = status;

      final response = await ApiService.put('/investments/$id', updateData);
      final data = ApiService.parseResponse(response);
      return Investment.fromJson(data['investment']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Delete investment
  static Future<void> deleteInvestment(String id) async {
    try {
      await ApiService.delete('/investments/$id');
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get investor portfolio
  static Future<List<Investment>> getInvestorPortfolio(String investorId) async {
    try {
      final response = await ApiService.get('/investments/investor/$investorId');
      final data = ApiService.parseResponse(response);
      
      return (data['investments'] as List)
          .map((json) => Investment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get project investments
  static Future<List<Investment>> getProjectInvestments(String projectId) async {
    try {
      final response = await ApiService.get('/investments/project/$projectId');
      final data = ApiService.parseResponse(response);
      
      return (data['investments'] as List)
          .map((json) => Investment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Confirm investment payment
  static Future<Investment> confirmInvestment(String id) async {
    try {
      final response = await ApiService.post('/investments/$id/confirm', {});
      final data = ApiService.parseResponse(response);
      return Investment.fromJson(data['investment']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Calculate investment returns
  static double calculateInvestmentReturn(Investment investment, double projectProfit) {
    if (investment.amount <= 0) return 0.0;
    return (investment.profitSharingPercentage / 100) * projectProfit;
  }

  // Get total investment amount for a project
  static double getTotalProjectInvestment(List<Investment> investments) {
    return investments
        .where((inv) => inv.isActive)
        .fold(0.0, (sum, inv) => sum + inv.amount);
  }

  // Get investments by cooperative member
  static Future<List<Investment>> getInvestmentsByMember(String memberId, {String? cooperativeId}) async {
    try {
      String endpoint = '/investments/member/$memberId';
      if (cooperativeId != null) {
        endpoint += '?cooperative_id=$cooperativeId';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      
      return (data['investments'] as List)
          .map((json) => Investment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get available projects for investment
  static Future<List<dynamic>> getAvailableProjectsForInvestment({String? cooperativeId}) async {
    try {
      String endpoint = '/projects/available-for-investment';
      if (cooperativeId != null) {
        endpoint += '?cooperative_id=$cooperativeId';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      return data['projects'] as List;
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Check if user can invest in project
  static Future<bool> canInvestInProject(String userId, String projectId) async {
    try {
      final response = await ApiService.get('/investments/can-invest?user_id=$userId&project_id=$projectId');
      final data = ApiService.parseResponse(response);
      return data['can_invest'] as bool? ?? false;
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get investment limits for user
  static Future<Map<String, dynamic>> getInvestmentLimits(String userId) async {
    try {
      final response = await ApiService.get('/investments/limits/$userId');
      final data = ApiService.parseResponse(response);
      return data['limits'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Withdraw investment (if allowed)
  static Future<Investment> withdrawInvestment(String id, {String? reason}) async {
    try {
      final response = await ApiService.post('/investments/$id/withdraw', {
        'reason': reason,
      });
      final data = ApiService.parseResponse(response);
      return Investment.fromJson(data['investment']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get investment history
  static Future<List<Investment>> getInvestmentHistory(String userId, {String? status}) async {
    try {
      String endpoint = '/investments/history/$userId';
      if (status != null) {
        endpoint += '?status=$status';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      
      return (data['investments'] as List)
          .map((json) => Investment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }
}
