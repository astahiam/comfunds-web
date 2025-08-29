import '../models/cooperative.dart';
import 'api_service.dart';

class CooperativeService {
  // Get all cooperatives
  static Future<List<Cooperative>> getCooperatives({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await ApiService.get('/cooperatives?page=$page&limit=$limit');
      final data = ApiService.parseResponse(response);
      
      return (data['cooperatives'] as List)
          .map((json) => Cooperative.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get cooperative by ID
  static Future<Cooperative> getCooperative(String id) async {
    try {
      final response = await ApiService.get('/cooperatives/$id');
      final data = ApiService.parseResponse(response);
      return Cooperative.fromJson(data['cooperative']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Create new cooperative
  static Future<Cooperative> createCooperative({
    required String name,
    required String registrationNumber,
    required String address,
    required String phone,
    required String email,
    required String bankAccount,
    Map<String, dynamic>? profitSharingPolicy,
  }) async {
    try {
      final response = await ApiService.post('/cooperatives', {
        'name': name,
        'registration_number': registrationNumber,
        'address': address,
        'phone': phone,
        'email': email,
        'bank_account': bankAccount,
        'profit_sharing_policy': profitSharingPolicy,
      });

      final data = ApiService.parseResponse(response);
      return Cooperative.fromJson(data['cooperative']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Update cooperative
  static Future<Cooperative> updateCooperative({
    required String id,
    String? name,
    String? registrationNumber,
    String? address,
    String? phone,
    String? email,
    String? bankAccount,
    Map<String, dynamic>? profitSharingPolicy,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (registrationNumber != null) updateData['registration_number'] = registrationNumber;
      if (address != null) updateData['address'] = address;
      if (phone != null) updateData['phone'] = phone;
      if (email != null) updateData['email'] = email;
      if (bankAccount != null) updateData['bank_account'] = bankAccount;
      if (profitSharingPolicy != null) updateData['profit_sharing_policy'] = profitSharingPolicy;

      final response = await ApiService.put('/cooperatives/$id', updateData);
      final data = ApiService.parseResponse(response);
      return Cooperative.fromJson(data['cooperative']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Delete cooperative
  static Future<void> deleteCooperative(String id) async {
    try {
      await ApiService.delete('/cooperatives/$id');
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get cooperative members
  static Future<List<dynamic>> getCooperativeMembers(String id) async {
    try {
      final response = await ApiService.get('/cooperatives/$id/members');
      final data = ApiService.parseResponse(response);
      return data['members'] as List;
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Approve project
  static Future<void> approveProject({
    required String cooperativeId,
    required String projectId,
  }) async {
    try {
      await ApiService.post('/cooperatives/$cooperativeId/approve-project/$projectId', {});
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }
}
