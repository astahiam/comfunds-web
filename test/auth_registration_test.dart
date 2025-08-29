import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('Auth Registration Tests', () {
    const String baseUrl = 'http://localhost:8080/api/v1';

    test('should register a new user successfully', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': 'testuser${DateTime.now().millisecondsSinceEpoch}@example.com',
          'password': 'Password123!',
          'name': 'Test User',
          'phone': '+1234567890',
          'address': 'Test Address',
          'roles': ['member'],
        }),
      );

      expect(response.statusCode, 201);
      
      final data = jsonDecode(response.body);
      expect(data['status'], 'success');
      expect(data['message'], 'User registered successfully');
      expect(data['data'], isNotNull);
      expect(data['data']['user'], isNotNull);
      expect(data['data']['access_token'], isNotNull);
      expect(data['data']['refresh_token'], isNotNull);
      
      final user = data['data']['user'];
      expect(user['email'], contains('@example.com'));
      expect(user['name'], 'Test User');
      expect(user['roles'], contains('member'));
    });

    test('should fail registration with weak password', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': 'testuser${DateTime.now().millisecondsSinceEpoch}@example.com',
          'password': 'weak',
          'name': 'Test User',
          'phone': '+1234567890',
          'address': 'Test Address',
          'roles': ['member'],
        }),
      );

      expect(response.statusCode, 400);
      
      final data = jsonDecode(response.body);
      expect(data['status'], 'error');
      expect(data['message'], 'Validation failed');
      expect(data['error'], contains('Password is min'));
    });

    test('should fail registration with invalid cooperative_id', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': 'testuser${DateTime.now().millisecondsSinceEpoch}@example.com',
          'password': 'Password123!',
          'name': 'Test User',
          'phone': '+1234567890',
          'address': 'Test Address',
          'cooperative_id': 'invalid-uuid',
          'roles': ['member'],
        }),
      );

      expect(response.statusCode, 400);
      
      final data = jsonDecode(response.body);
      expect(data['status'], 'error');
      expect(data['message'], 'Invalid request payload');
      expect(data['error'], contains('invalid UUID length'));
    });

    test('should login successfully with registered user', () async {
      final email = 'testuser${DateTime.now().millisecondsSinceEpoch}@example.com';
      
      // First register a user
      final registerResponse = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': 'Password123!',
          'name': 'Test User',
          'phone': '+1234567890',
          'address': 'Test Address',
          'roles': ['member'],
        }),
      );

      expect(registerResponse.statusCode, 201);

      // Then login with the same credentials
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': 'Password123!',
        }),
      );

      expect(loginResponse.statusCode, 200);
      
      final data = jsonDecode(loginResponse.body);
      expect(data['status'], 'success');
      expect(data['message'], 'Login successful');
      expect(data['data']['access_token'], isNotNull);
      expect(data['data']['user']['email'], email);
    });
  });
}
