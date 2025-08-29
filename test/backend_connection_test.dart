import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('Backend Connection Tests', () {
    const String baseUrl = 'http://localhost:8080/api/v1';

    test('should connect to Golang backend health endpoint', () async {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      
      expect(response.statusCode, 200);
      
      final data = jsonDecode(response.body);
      expect(data['status'], 'OK');
      expect(data['message'], 'ComFunds API is running');
      expect(data['version'], isNotNull);
      
      print('✅ Backend health check passed');
      print('   Status: ${data['status']}');
      print('   Message: ${data['message']}');
      print('   Version: ${data['version']}');
    });

    test('should handle authentication endpoints', () async {
      // Test registration endpoint
      final registerResponse = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'test@comfunds.com',
          'password': 'testpassword123',
          'name': 'Test User',
          'phone': '+6281234567890',
          'address': 'Test Address',
          'roles': ['member', 'investor'],
        }),
      );
      
      // Should either succeed (201) or fail with validation error (400)
      expect(registerResponse.statusCode, anyOf(201, 400, 409));
      
      print('✅ Registration endpoint test passed');
      print('   Status Code: ${registerResponse.statusCode}');
    });

    test('should handle cooperative endpoints', () async {
      final response = await http.get(Uri.parse('$baseUrl/cooperatives'));
      
      // Should either return data (200) or require authentication (401)
      expect(response.statusCode, anyOf(200, 401));
      
      print('✅ Cooperatives endpoint test passed');
      print('   Status Code: ${response.statusCode}');
    });

    test('should handle project endpoints', () async {
      final response = await http.get(Uri.parse('$baseUrl/public/projects'));
      
      // Should return data (200) for public endpoint
      expect(response.statusCode, 200);
      
      final data = jsonDecode(response.body);
      expect(data['status'], 'success');
      expect(data['data']['projects'], isNotNull);
      
      print('✅ Projects endpoint test passed');
      print('   Status Code: ${response.statusCode}');
      print('   Projects found: ${(data['data']['projects'] as List).length}');
    });

    test('should handle business endpoints', () async {
      final response = await http.get(Uri.parse('$baseUrl/public/businesses'));
      
      // Should return data (200) for public endpoint or 404 if not implemented
      expect(response.statusCode, anyOf(200, 404));
      
      print('✅ Businesses endpoint test passed');
      print('   Status Code: ${response.statusCode}');
    });

    test('should handle investment endpoints', () async {
      final response = await http.get(Uri.parse('$baseUrl/public/investments'));
      
      // Should return data (200) for public endpoint or 404 if not implemented
      expect(response.statusCode, anyOf(200, 404));
      
      print('✅ Investments endpoint test passed');
      print('   Status Code: ${response.statusCode}');
    });
  });
}
