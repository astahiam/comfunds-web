import '../models/role_request.dart';
import '../models/user.dart';
import 'api_service.dart';

class RoleService {
  // Get all role requests
  static Future<List<RoleRequest>> getRoleRequests({String? status}) async {
    try {
      String endpoint = '/admin/role-requests';
      if (status != null) {
        endpoint += '?status=$status';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      
      return (data['data']['role_requests'] as List)
          .map((json) => RoleRequest.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get role requests for a specific user
  static Future<List<RoleRequest>> getUserRoleRequests(String userId) async {
    try {
      final response = await ApiService.get('/admin/role-requests/user/$userId');
      final data = ApiService.parseResponse(response);
      
      return (data['data']['role_requests'] as List)
          .map((json) => RoleRequest.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Create a role request
  static Future<RoleRequest> createRoleRequest({
    required String requestedRole,
    required String reason,
  }) async {
    try {
      final response = await ApiService.post('/role-requests', {
        'requested_role': requestedRole,
        'reason': reason,
      });

      final data = ApiService.parseResponse(response);
      return RoleRequest.fromJson(data['data']['role_request']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Approve a role request
  static Future<RoleRequest> approveRoleRequest(String requestId) async {
    try {
      final response = await ApiService.put('/admin/role-requests/$requestId/approve', {});
      final data = ApiService.parseResponse(response);
      return RoleRequest.fromJson(data['data']['role_request']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Reject a role request
  static Future<RoleRequest> rejectRoleRequest({
    required String requestId,
    required String rejectionReason,
  }) async {
    try {
      final response = await ApiService.put('/admin/role-requests/$requestId/reject', {
        'rejection_reason': rejectionReason,
      });
      final data = ApiService.parseResponse(response);
      return RoleRequest.fromJson(data['data']['role_request']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get all users (for admin)
  static Future<List<User>> getAllUsers({String? role}) async {
    try {
      String endpoint = '/admin/users';
      if (role != null) {
        endpoint += '?role=$role';
      }
      
      final response = await ApiService.get(endpoint);
      final data = ApiService.parseResponse(response);
      
      return (data['data']['users'] as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Add role to user (admin only)
  static Future<User> addRoleToUser({
    required String userId,
    required String role,
  }) async {
    try {
      final response = await ApiService.post('/admin/users/$userId/roles', {
        'role': role,
      });
      final data = ApiService.parseResponse(response);
      return User.fromJson(data['data']['user']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Remove role from user (admin only)
  static Future<User> removeRoleFromUser({
    required String userId,
    required String role,
  }) async {
    try {
      final response = await ApiService.delete('/admin/users/$userId/roles/$role');
      final data = ApiService.parseResponse(response);
      return User.fromJson(data['data']['user']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get user by ID (admin only)
  static Future<User> getUserById(String userId) async {
    try {
      final response = await ApiService.get('/admin/users/$userId');
      final data = ApiService.parseResponse(response);
      return User.fromJson(data['data']['user']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Update user roles (admin only)
  static Future<User> updateUserRoles({
    required String userId,
    required List<String> roles,
  }) async {
    try {
      final response = await ApiService.put('/admin/users/$userId/roles', {
        'roles': roles,
      });
      final data = ApiService.parseResponse(response);
      return User.fromJson(data['data']['user']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get role statistics (admin only)
  static Future<Map<String, dynamic>> getRoleStatistics() async {
    try {
      final response = await ApiService.get('/admin/role-statistics');
      final data = ApiService.parseResponse(response);
      return data['data']['statistics'];
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Get pending role requests count
  static Future<int> getPendingRoleRequestsCount() async {
    try {
      final response = await ApiService.get('/admin/role-requests/count?status=pending');
      final data = ApiService.parseResponse(response);
      return data['data']['count'];
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }
}
