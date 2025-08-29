import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Register new user
  static Future<User> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
    String? cooperativeId,
    required List<String> roles,
  }) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'address': address,
        'cooperative_id': cooperativeId,
        'roles': roles,
      });

      final data = ApiService.parseResponse(response);
      return User.fromJson(data['user']);
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = ApiService.parseResponse(response);
      
      // Store tokens
      await _storage.write(key: 'auth_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
      
      return {
        'user': User.fromJson(data['user']),
        'access_token': data['access_token'],
        'refresh_token': data['refresh_token'],
      };
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Refresh token
  static Future<String> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      final data = ApiService.parseResponse(response);
      await _storage.write(key: 'auth_token', value: data['access_token']);
      
      return data['access_token'];
    } catch (e) {
      throw Exception(ApiService.handleError(e));
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'refresh_token');
      await _storage.delete(key: 'user_data');
    } catch (e) {
      // Ignore errors during logout
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: 'user_data');
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Store user data
  static Future<void> storeUserData(User user) async {
    await _storage.write(key: 'user_data', value: jsonEncode(user.toJson()));
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  // Get stored token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
