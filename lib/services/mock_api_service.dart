import 'dart:convert';
import 'dart:math';
import '../models/user.dart';

class MockApiService {
  // Simulated database
  static final List<Map<String, dynamic>> _users = [];
  static final List<String> _tokens = [];
  
  // Generate mock ID
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }
  
  // Generate mock JWT token
  static String _generateToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(64, (index) => chars[random.nextInt(chars.length)]).join();
  }
  
  // Mock user registration
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
    String? cooperativeId,
    required List<String> roles,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if user already exists
    final existingUser = _users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );
    
    if (existingUser.isNotEmpty) {
      throw Exception('User with this email already exists');
    }
    
    // Validate input
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('Email, password, and name are required');
    }
    
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }
    
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }
    
    // Create new user
    final userId = _generateId();
    final accessToken = _generateToken();
    final refreshToken = _generateToken();
    
    final userData = {
      'id': userId,
      'email': email,
      'name': name,
      'phone': phone ?? '',
      'address': address ?? '',
      'cooperative_id': cooperativeId,
      'roles': roles,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    _users.add(userData);
    _tokens.add(accessToken);
    
    return {
      'status': 'success',
      'message': 'User registered successfully',
      'data': {
        'user': userData,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      }
    };
  }
  
  // Mock user login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Find user
    final user = _users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );
    
    if (user.isEmpty) {
      throw Exception('User not found');
    }
    
    // For mock purposes, accept any password for existing users
    // In real implementation, you'd verify the hashed password
    
    final accessToken = _generateToken();
    final refreshToken = _generateToken();
    
    _tokens.add(accessToken);
    
    return {
      'status': 'success',
      'message': 'Login successful',
      'data': {
        'user': user,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      }
    };
  }
  
  // Mock token validation
  static Future<bool> validateToken(String token) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _tokens.contains(token);
  }
  
  // Mock user profile fetch
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final user = _users.firstWhere(
      (user) => user['id'] == userId,
      orElse: () => {},
    );
    
    if (user.isEmpty) {
      throw Exception('User not found');
    }
    
    return {
      'status': 'success',
      'data': user,
    };
  }
  
  // Mock logout
  static Future<Map<String, dynamic>> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    _tokens.remove(token);
    
    return {
      'status': 'success',
      'message': 'Logout successful',
    };
  }
  
  // Get all registered users (for testing)
  static List<Map<String, dynamic>> getAllUsers() {
    return List.from(_users);
  }
  
  // Clear all data (for testing)
  static void clearAllData() {
    _users.clear();
    _tokens.clear();
  }
  
  // Add some sample users for testing
  static Future<void> seedSampleData() async {
    clearAllData();
    
    // Add sample admin user
    await register(
      email: 'admin@hajifund.com',
      password: 'admin123',
      name: 'Admin User',
      phone: '+62812345678',
      address: 'Jakarta, Indonesia',
      roles: ['adminComfunds', 'admin'],
    );
    
    // Add sample cooperative admin
    await register(
      email: 'coop-admin@hajifund.com',
      password: 'coop123',
      name: 'Cooperative Admin',
      phone: '+62812345679',
      address: 'Bandung, Indonesia',
      roles: ['cooperativeAdmin', 'member'],
    );
    
    // Add sample member
    await register(
      email: 'member@hajifund.com',
      password: 'member123',
      name: 'Regular Member',
      phone: '+62812345680',
      address: 'Surabaya, Indonesia',
      roles: ['member', 'investor'],
    );
    
    // Add sample business owner
    await register(
      email: 'business@hajifund.com',
      password: 'business123',
      name: 'Business Owner',
      phone: '+62812345681',
      address: 'Yogyakarta, Indonesia',
      roles: ['businessOwner', 'member'],
    );
  }
}
