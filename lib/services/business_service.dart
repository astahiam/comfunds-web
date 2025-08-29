import '../models/business.dart';
import 'api_service.dart';

class BusinessService {
  // Get all businesses
  static Future<List<Business>> getBusinesses({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      String endpoint = '/businesses?page=$page&limit=$limit';
      if (status != null) {
        endpoint += '&status=$status';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      
      return (data['businesses'] as List)
          .map((json) => Business.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get business by ID
  static Future<Business> getBusiness(String id) async {
    try {
      final response = await ApiService.get('/businesses/$id');
      final data = ApiService.parseResponse(response);
      return Business.fromJson(data['business']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Create new business
  static Future<Business> createBusiness({
    required String name,
    required String businessType,
    String? description,
    required String ownerId,
    required String cooperativeId,
    Map<String, dynamic>? registrationDocuments,
  }) async {
    try {
      final response = await ApiService.post('/businesses', {
        'name': name,
        'business_type': businessType,
        'description': description,
        'owner_id': ownerId,
        'cooperative_id': cooperativeId,
        'registration_documents': registrationDocuments,
      });

      final data = ApiService.parseResponse(response);
      return Business.fromJson(data['business']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Update business
  static Future<Business> updateBusiness({
    required String id,
    String? name,
    String? businessType,
    String? description,
    Map<String, dynamic>? registrationDocuments,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (businessType != null) updateData['business_type'] = businessType;
      if (description != null) updateData['description'] = description;
      if (registrationDocuments != null) updateData['registration_documents'] = registrationDocuments;

      final response = await ApiService.put('/businesses/$id', updateData);
      final data = ApiService.parseResponse(response);
      return Business.fromJson(data['business']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Delete business
  static Future<void> deleteBusiness(String id) async {
    try {
      await ApiService.delete('/businesses/$id');
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get businesses by owner
  static Future<List<Business>> getBusinessesByOwner(String ownerId) async {
    try {
      final response = await ApiService.get('/businesses/owner/$ownerId');
      final data = ApiService.parseResponse(response);
      
      return (data['businesses'] as List)
          .map((json) => Business.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Approve business (cooperative admin)
  static Future<Business> approveBusiness(String id) async {
    try {
      final response = await ApiService.post('/businesses/$id/approve', {});
      final data = ApiService.parseResponse(response);
      return Business.fromJson(data['business']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }
}
