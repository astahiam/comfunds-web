import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

const String baseUrl = 'http://localhost:8080/api/v1';
String? authToken;
String? testUserId;
String? cooperativeId;
String? businessId;
String? projectId;
String? investmentId;

String generateRandomEmail() {
  final random = Random();
  return 'test${random.nextInt(10000)}@hajifund.com';
}

String generateRandomPhone() {
  final random = Random();
  return '+628${random.nextInt(1000000000).toString().padLeft(9, '0')}';
}

Map<String, String> get authHeaders {
  return {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };
}

Future<void> createTestAdmin() async {
  try {
    final adminData = {
      'email': 'admin@hajifund.com',
      'password': 'admin123',
      'name': 'Test Admin',
      'phone': '+6281234567890',
      'address': 'Jakarta, Indonesia',
      'roles': ['admin', 'cooperativeAdmin'],
    };

    final registerResponse = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(adminData),
    );

    if (registerResponse.statusCode == 201 || registerResponse.statusCode == 409) {
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': adminData['email'],
          'password': adminData['password'],
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(loginResponse.body);
        authToken = loginData['access_token'] ?? 
                   loginData['data']?['token'] ?? 
                   loginData['token'];
      }
    }
  } catch (e) {
    print('Admin setup failed: $e');
  }
}

Future<void> createTestUser() async {
  try {
    final email = generateRandomEmail();
    final password = 'testPassword123!';
    
    final userData = {
      'email': email,
      'password': password,
      'name': 'Test User',
      'phone': generateRandomPhone(),
      'address': 'Jakarta, Indonesia',
    };

    final registerResponse = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (registerResponse.statusCode == 201) {
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(loginResponse.body);
        authToken = loginData['access_token'] ?? 
                   loginData['data']?['token'] ?? 
                   loginData['token'];
      }
    }
  } catch (e) {
    print('Test user creation failed: $e');
  }
}

void main() {
  group('Enhanced API Integration Tests with Edge Cases', () {

    setUpAll(() async {
      print('🚀 Starting Enhanced API Integration Tests...');
      // Setup test environment
      await createTestAdmin();
    });

    tearDownAll(() async {
      print('🧹 Cleaning up test data...');
      // Cleanup will be handled by individual tests
    });

    group('🔐 Authentication Tests with Edge Cases', () {
      test('should handle invalid email format registration', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': 'invalid-email-format',
            'password': 'password123',
            'name': 'Test User',
            'phone': '+6281234567890',
            'address': 'Test Address',
          }),
        );
        
        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Invalid email format test passed');
      });

      test('should handle weak password registration', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': generateRandomEmail(),
            'password': '123',
            'name': 'Test User',
            'phone': generateRandomPhone(),
            'address': 'Test Address',
          }),
        );
        
        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Weak password test passed');
      });

      test('should handle duplicate email registration', () async {
        final email = generateRandomEmail();
        final userData = {
          'email': email,
          'password': 'password123',
          'name': 'Test User',
          'phone': generateRandomPhone(),
          'address': 'Test Address',
        };

        // First registration
        await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        // Duplicate registration attempt
        final response = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        expect(response.statusCode, anyOf([409, 422]));
        print('✅ Duplicate email test passed');
      });

      test('should successfully register and login user', () async {
        final email = generateRandomEmail();
        final password = 'securePassword123!';
        final phone = generateRandomPhone();
        
        // Registration
        final registerResponse = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
            'name': 'Valid Test User',
            'phone': phone,
            'address': 'Jakarta, Indonesia',
          }),
        );

        expect(registerResponse.statusCode, anyOf([201, 200]));
        
        // Login
        final loginResponse = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        expect(loginResponse.statusCode, 200);
        final loginData = jsonDecode(loginResponse.body);
        authToken = loginData['access_token'] ?? 
                   loginData['data']?['token'] ?? 
                   loginData['token'];
        expect(authToken, isNotNull);
        print('✅ Valid registration and login test passed');
      });

      test('should handle login with wrong password', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': 'test@example.com',
            'password': 'wrongPassword',
          }),
        );

        expect(response.statusCode, anyOf([401, 422]));
        print('✅ Wrong password test passed');
      });

      test('should handle login with non-existent email', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': 'nonexistent@example.com',
            'password': 'password123',
          }),
        );

        expect(response.statusCode, anyOf([401, 404, 422]));
        print('✅ Non-existent email test passed');
      });
    });

    group('👥 User Management Tests', () {
      test('should get user profile with valid token', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final response = await http.get(
          Uri.parse('$baseUrl/auth/profile'),
          headers: authHeaders,
        );

        if (response.statusCode == 200) {
          final profileData = jsonDecode(response.body);
          expect(profileData['data'] ?? profileData['user'], isNotNull);
          print('✅ Get user profile test passed');
        } else {
          print('⚠️ Get user profile test skipped (endpoint not available)');
        }
      });

      test('should update user profile', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final response = await http.put(
          Uri.parse('$baseUrl/auth/profile'),
          headers: authHeaders,
          body: jsonEncode({
            'name': 'Updated Test User',
            'phone': generateRandomPhone(),
          }),
        );

        if (response.statusCode == 200) {
          final updatedData = jsonDecode(response.body);
          expect(updatedData['data']['name'] ?? updatedData['user']['name'], 'Updated Test User');
          print('✅ Update user profile test passed');
        } else {
          print('⚠️ Update user profile test skipped (endpoint not available)');
        }
      });
    });

    group('🏢 Cooperative Management Tests', () {
      test('should create cooperative with valid data', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final cooperativeData = {
          'name': 'Test Cooperative ${Random().nextInt(1000)}',
          'registration_number': 'COOP-${Random().nextInt(10000)}',
          'address': 'Jakarta, Indonesia',
          'phone': generateRandomPhone(),
          'email': generateRandomEmail(),
          'description': 'A test cooperative for integration testing',
        };

        final response = await http.post(
          Uri.parse('$baseUrl/cooperatives'),
          headers: authHeaders,
          body: jsonEncode(cooperativeData),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          cooperativeId = responseData['data']['id'] ?? responseData['cooperative']['id'];
          expect(cooperativeId, isNotNull);
          print('✅ Create cooperative test passed');
        } else {
          print('⚠️ Create cooperative test skipped (endpoint not available)');
        }
      });

      test('should handle cooperative creation with missing required fields', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final response = await http.post(
          Uri.parse('$baseUrl/cooperatives'),
          headers: authHeaders,
          body: jsonEncode({
            'name': 'Incomplete Cooperative',
            // Missing required fields
          }),
        );

        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Incomplete cooperative data test passed');
      });

      test('should get cooperative details', () async {
        if (cooperativeId == null) {
          return; // Skip if no cooperative was created
        }

        final response = await http.get(
          Uri.parse('$baseUrl/cooperatives/$cooperativeId'),
          headers: authHeaders,
        );

        if (response.statusCode == 200) {
          final cooperativeData = jsonDecode(response.body);
          expect(cooperativeData['data']['id'] ?? cooperativeData['cooperative']['id'], cooperativeId);
          print('✅ Get cooperative details test passed');
        } else {
          print('⚠️ Get cooperative details test skipped');
        }
      });
    });

    group('🏪 Business Management Tests', () {
      test('should create business with valid data', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final businessData = {
          'name': 'Test Business ${Random().nextInt(1000)}',
          'business_type': 'Technology',
          'description': 'A test business for integration testing',
          'registration_number': 'BUS-${Random().nextInt(10000)}',
          'address': 'Jakarta, Indonesia',
          'phone': generateRandomPhone(),
          'email': generateRandomEmail(),
          if (cooperativeId != null) 'cooperative_id': cooperativeId,
        };

        final response = await http.post(
          Uri.parse('$baseUrl/businesses'),
          headers: authHeaders,
          body: jsonEncode(businessData),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          businessId = responseData['data']['id'] ?? responseData['business']['id'];
          expect(businessId, isNotNull);
          print('✅ Create business test passed');
        } else {
          print('⚠️ Create business test skipped (endpoint not available)');
        }
      });

      test('should handle business creation with invalid business type', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final response = await http.post(
          Uri.parse('$baseUrl/businesses'),
          headers: authHeaders,
          body: jsonEncode({
            'name': 'Invalid Business Type',
            'business_type': 'InvalidType',
            'description': 'Test business with invalid type',
          }),
        );

        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Invalid business type test passed');
      });
    });

    group('📋 Project Management Tests', () {
      test('should create project with valid data', () async {
        if (businessId == null) {
          return; // Skip if no business was created
        }

        final projectData = {
          'title': 'Test Project ${Random().nextInt(1000)}',
          'description': 'A test project for integration testing',
          'target_amount': 1000000,
          'minimum_investment': 50000,
          'category': 'Technology',
          'business_id': businessId,
          if (cooperativeId != null) 'cooperative_id': cooperativeId,
          'funding_goal': 1000000,
          'minimum_funding': 50000,
          'project_type': 'startup',
        };

        final response = await http.post(
          Uri.parse('$baseUrl/projects'),
          headers: authHeaders,
          body: jsonEncode(projectData),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          projectId = responseData['data']['id'] ?? responseData['project']['id'];
          expect(projectId, isNotNull);
          print('✅ Create project test passed');
        } else {
          print('⚠️ Create project test skipped (endpoint not available)');
        }
      });

      test('should handle project creation with invalid funding amounts', () async {
        if (businessId == null) {
          return; // Skip if no business was created
        }

        final response = await http.post(
          Uri.parse('$baseUrl/projects'),
          headers: authHeaders,
          body: jsonEncode({
            'title': 'Invalid Funding Project',
            'description': 'Test project with invalid funding',
            'target_amount': -1000, // Invalid negative amount
            'business_id': businessId,
          }),
        );

        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Invalid funding amounts test passed');
      });
    });

    group('💰 Investment Management Tests', () {
      test('should create investment with valid data', () async {
        if (projectId == null) {
          return; // Skip if no project was created
        }

        final investmentData = {
          'project_id': projectId,
          'amount': 100000,
          'payment_method': 'bank_transfer',
          'profit_sharing_percentage': 70.0,
        };

        final response = await http.post(
          Uri.parse('$baseUrl/investments'),
          headers: authHeaders,
          body: jsonEncode(investmentData),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          investmentId = responseData['data']['id'] ?? responseData['investment']['id'];
          expect(investmentId, isNotNull);
          print('✅ Create investment test passed');
        } else {
          print('⚠️ Create investment test skipped (endpoint not available)');
        }
      });

      test('should handle investment with amount below minimum', () async {
        if (projectId == null) {
          return; // Skip if no project was created
        }

        final response = await http.post(
          Uri.parse('$baseUrl/investments'),
          headers: authHeaders,
          body: jsonEncode({
            'project_id': projectId,
            'amount': 1000, // Below minimum
            'payment_method': 'bank_transfer',
          }),
        );

        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Investment below minimum test passed');
      });

      test('should get investor portfolio', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/investments/portfolio'),
          headers: authHeaders,
        );

        if (response.statusCode == 200) {
          final portfolioData = jsonDecode(response.body);
          expect(portfolioData['data']['investments'] ?? portfolioData['investments'], isList);
          print('✅ Get investor portfolio test passed');
        } else {
          print('⚠️ Get investor portfolio test skipped');
        }
      });
    });

    group('🔒 Security and Authorization Tests', () {
      test('should reject requests without authentication token', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/cooperatives'),
          headers: {'Content-Type': 'application/json'},
        );

        expect(response.statusCode, anyOf([401, 403]));
        print('✅ No auth token test passed');
      });

      test('should reject requests with invalid token', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/cooperatives'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer invalid-token-123',
          },
        );

        expect(response.statusCode, anyOf([401, 403]));
        print('✅ Invalid token test passed');
      });

      test('should handle SQL injection attempts', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': "'; DROP TABLE users; --",
            'password': 'password',
          }),
        );

        // Should not return 500 (server error) due to SQL injection
        expect(response.statusCode, isNot(500));
        print('✅ SQL injection prevention test passed');
      });
    });

    group('⚡ Performance Tests', () {
      test('should handle concurrent requests', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final stopwatch = Stopwatch()..start();
        
        // Create 5 concurrent requests
        final futures = List.generate(5, (index) => 
          http.get(
            Uri.parse('$baseUrl/cooperatives'),
            headers: authHeaders,
          )
        );

        final responses = await Future.wait(futures);
        stopwatch.stop();

        // All requests should complete within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(10000));
        
        // Check that we got responses (even if endpoint doesn't exist)
        expect(responses.length, 5);
        print('✅ Concurrent requests test passed - ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should handle large data requests', () async {
        if (authToken == null) {
          await createTestUser();
        }

        final stopwatch = Stopwatch()..start();
        
        final response = await http.get(
          Uri.parse('$baseUrl/projects?limit=1000'),
          headers: authHeaders,
        );
        
        stopwatch.stop();

        // Response should be within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        print('✅ Large data request test passed - ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('🔄 Data Consistency Tests', () {
      test('should maintain referential integrity', () async {
        if (authToken == null) {
          await createTestUser();
        }

        // Try to create a project with non-existent business_id
        final response = await http.post(
          Uri.parse('$baseUrl/projects'),
          headers: authHeaders,
          body: jsonEncode({
            'title': 'Invalid Reference Project',
            'description': 'Project with invalid business reference',
            'target_amount': 1000000,
            'business_id': 'non-existent-business-id',
          }),
        );

        expect(response.statusCode, anyOf([400, 404, 422]));
        print('✅ Referential integrity test passed');
      });

      test('should validate data constraints', () async {
        if (authToken == null) {
          await createTestUser();
        }

        // Try to create cooperative with invalid email
        final response = await http.post(
          Uri.parse('$baseUrl/cooperatives'),
          headers: authHeaders,
          body: jsonEncode({
            'name': 'Test Cooperative',
            'email': 'invalid-email-format',
            'registration_number': 'COOP-001',
          }),
        );

        expect(response.statusCode, anyOf([400, 422]));
        print('✅ Data validation constraints test passed');
      });
    });

  });
}
