import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../lib/services/api_service.dart';
import '../../lib/services/auth_service.dart';
import '../../lib/services/cooperative_service.dart';
import '../../lib/services/business_service.dart';
import '../../lib/services/project_service.dart';
import '../../lib/services/investment_service.dart';
import '../../lib/models/user.dart';
import '../../lib/models/cooperative.dart';
import '../../lib/models/business.dart';
import '../../lib/models/project.dart';
import '../../lib/models/investment.dart';

class ApiIntegrationTest {
  static const String baseUrl = 'http://localhost:8080/api/v1';
  static String? authToken;

  // Test data
  static const testUser = {
    'email': 'test@comfunds.com',
    'password': 'testpassword123',
    'name': 'Test User',
    'phone': '+6281234567890',
    'address': 'Test Address, Jakarta',
    'roles': ['member', 'investor'],
  };

  static const testCooperative = {
    'name': 'Test Cooperative',
    'registration_number': 'COOP-001-2024',
    'address': 'Test Cooperative Address',
    'phone': '+6281234567891',
    'email': 'coop@test.com',
    'bank_account': '1234567890',
  };

  static const testBusiness = {
    'name': 'Test Business',
    'business_type': 'retail',
    'description': 'A test business for integration testing',
    'owner_id': 'test-owner-id',
    'cooperative_id': 'test-coop-id',
  };

  static const testProject = {
    'title': 'Test Project',
    'description': 'A test project for integration testing',
    'business_id': 'test-business-id',
    'funding_goal': 10000.0,
    'minimum_funding': 1000.0,
    'project_type': 'startup',
  };

  static const testInvestment = {
    'project_id': 'test-project-id',
    'investor_id': 'test-investor-id',
    'amount': 1000.0,
    'profit_sharing_percentage': 70.0,
  };

  // Setup and teardown
  static Future<void> setUp() async {
    // Clear any existing test data
    await cleanUpTestData();
  }

  static Future<void> tearDown() async {
    // Clean up test data
    await cleanUpTestData();
  }

  static Future<void> cleanUpTestData() async {
    // This would typically call cleanup endpoints on the backend
    // For now, we'll just clear the auth token
    authToken = null;
  }

  // Authentication Tests
  static Future<void> testAuthenticationFlow() async {
    print('Testing Authentication Flow...');

    try {
      // Test user registration
      final registerResponse = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testUser),
      );

      expect(registerResponse.statusCode, 201);
      final registerData = jsonDecode(registerResponse.body);
      expect(registerData['user']['email'], testUser['email']);

      // Test user login
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': testUser['email'],
          'password': testUser['password'],
        }),
      );

      expect(loginResponse.statusCode, 200);
      final loginData = jsonDecode(loginResponse.body);
      expect(loginData['access_token']).isNotNull;
      authToken = loginData['access_token'];

      print('✅ Authentication flow test passed');
    } catch (e) {
      print('❌ Authentication flow test failed: $e');
      rethrow;
    }
  }

  // Cooperative Tests
  static Future<void> testCooperativeCRUD() async {
    print('Testing Cooperative CRUD Operations...');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      // Test create cooperative
      final createResponse = await http.post(
        Uri.parse('$baseUrl/cooperatives'),
        headers: headers,
        body: jsonEncode(testCooperative),
      );

      expect(createResponse.statusCode, 201);
      final createData = jsonDecode(createResponse.body);
      final cooperativeId = createData['cooperative']['id'];
      expect(createData['cooperative']['name'], testCooperative['name']);

      // Test get cooperative
      final getResponse = await http.get(
        Uri.parse('$baseUrl/cooperatives/$cooperativeId'),
        headers: headers,
      );

      expect(getResponse.statusCode, 200);
      final getData = jsonDecode(getResponse.body);
      expect(getData['cooperative']['id'], cooperativeId);

      // Test update cooperative
      final updateData = {'name': 'Updated Test Cooperative'};
      final updateResponse = await http.put(
        Uri.parse('$baseUrl/cooperatives/$cooperativeId'),
        headers: headers,
        body: jsonEncode(updateData),
      );

      expect(updateResponse.statusCode, 200);
      final updatedData = jsonDecode(updateResponse.body);
      expect(updatedData['cooperative']['name'], 'Updated Test Cooperative');

      // Test list cooperatives
      final listResponse = await http.get(
        Uri.parse('$baseUrl/cooperatives'),
        headers: headers,
      );

      expect(listResponse.statusCode, 200);
      final listData = jsonDecode(listResponse.body);
      expect(listData['cooperatives']).isList;

      print('✅ Cooperative CRUD test passed');
    } catch (e) {
      print('❌ Cooperative CRUD test failed: $e');
      rethrow;
    }
  }

  // Business Tests
  static Future<void> testBusinessCRUD() async {
    print('Testing Business CRUD Operations...');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      // Test create business
      final createResponse = await http.post(
        Uri.parse('$baseUrl/businesses'),
        headers: headers,
        body: jsonEncode(testBusiness),
      );

      expect(createResponse.statusCode, 201);
      final createData = jsonDecode(createResponse.body);
      final businessId = createData['business']['id'];
      expect(createData['business']['name'], testBusiness['name']);

      // Test get business
      final getResponse = await http.get(
        Uri.parse('$baseUrl/businesses/$businessId'),
        headers: headers,
      );

      expect(getResponse.statusCode, 200);
      final getData = jsonDecode(getResponse.body);
      expect(getData['business']['id'], businessId);

      // Test update business
      final updateData = {'description': 'Updated business description'};
      final updateResponse = await http.put(
        Uri.parse('$baseUrl/businesses/$businessId'),
        headers: headers,
        body: jsonEncode(updateData),
      );

      expect(updateResponse.statusCode, 200);
      final updatedData = jsonDecode(updateResponse.body);
      expect(updatedData['business']['description'], 'Updated business description');

      // Test list businesses
      final listResponse = await http.get(
        Uri.parse('$baseUrl/businesses'),
        headers: headers,
      );

      expect(listResponse.statusCode, 200);
      final listData = jsonDecode(listResponse.body);
      expect(listData['businesses']).isList;

      print('✅ Business CRUD test passed');
    } catch (e) {
      print('❌ Business CRUD test failed: $e');
      rethrow;
    }
  }

  // Project Tests
  static Future<void> testProjectCRUD() async {
    print('Testing Project CRUD Operations...');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      // Test create project
      final createResponse = await http.post(
          Uri.parse('$baseUrl/projects'),
        headers: headers,
        body: jsonEncode(testProject),
      );

      expect(createResponse.statusCode, 201);
      final createData = jsonDecode(createResponse.body);
      final projectId = createData['project']['id'];
      expect(createData['project']['title'], testProject['title']);

      // Test get project
      final getResponse = await http.get(
        Uri.parse('$baseUrl/projects/$projectId'),
        headers: headers,
      );

      expect(getResponse.statusCode, 200);
      final getData = jsonDecode(getResponse.body);
      expect(getData['project']['id'], projectId);

      // Test update project
      final updateData = {'description': 'Updated project description'};
      final updateResponse = await http.put(
        Uri.parse('$baseUrl/projects/$projectId'),
        headers: headers,
        body: jsonEncode(updateData),
      );

      expect(updateResponse.statusCode, 200);
      final updatedData = jsonDecode(updateResponse.body);
      expect(updatedData['project']['description'], 'Updated project description');

      // Test submit project
      final submitResponse = await http.post(
        Uri.parse('$baseUrl/projects/$projectId/submit'),
        headers: headers,
      );

      expect(submitResponse.statusCode, 200);
      final submitData = jsonDecode(submitResponse.body);
      expect(submitData['project']['status'], 'submitted');

      // Test list projects
      final listResponse = await http.get(
        Uri.parse('$baseUrl/projects'),
        headers: headers,
      );

      expect(listResponse.statusCode, 200);
      final listData = jsonDecode(listResponse.body);
      expect(listData['projects']).isList;

      print('✅ Project CRUD test passed');
    } catch (e) {
      print('❌ Project CRUD test failed: $e');
      rethrow;
    }
  }

  // Investment Tests
  static Future<void> testInvestmentCRUD() async {
    print('Testing Investment CRUD Operations...');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      // Test create investment
      final createResponse = await http.post(
          Uri.parse('$baseUrl/investments'),
        headers: headers,
        body: jsonEncode(testInvestment),
      );

      expect(createResponse.statusCode, 201);
      final createData = jsonDecode(createResponse.body);
      final investmentId = createData['investment']['id'];
      expect(createData['investment']['amount'], testInvestment['amount']);

      // Test get investment
      final getResponse = await http.get(
        Uri.parse('$baseUrl/investments/$investmentId'),
        headers: headers,
      );

      expect(getResponse.statusCode, 200);
      final getData = jsonDecode(getResponse.body);
      expect(getData['investment']['id'], investmentId);

      // Test confirm investment
      final confirmResponse = await http.post(
        Uri.parse('$baseUrl/investments/$investmentId/confirm'),
        headers: headers,
      );

      expect(confirmResponse.statusCode, 200);
      final confirmData = jsonDecode(confirmResponse.body);
      expect(confirmData['investment']['status'], 'confirmed');

      // Test list investments
      final listResponse = await http.get(
        Uri.parse('$baseUrl/investments'),
        headers: headers,
      );

      expect(listResponse.statusCode, 200);
      final listData = jsonDecode(listResponse.body);
      expect(listData['investments']).isList;

      print('✅ Investment CRUD test passed');
    } catch (e) {
      print('❌ Investment CRUD test failed: $e');
      rethrow;
    }
  }

  // Error Handling Tests
  static Future<void> testErrorHandling() async {
    print('Testing Error Handling...');

    try {
      // Test invalid authentication
      final invalidAuthResponse = await http.get(
        Uri.parse('$baseUrl/cooperatives'),
        headers: {'Authorization': 'Bearer invalid-token'},
      );

      expect(invalidAuthResponse.statusCode, 401);

      // Test invalid endpoint
      final invalidEndpointResponse = await http.get(
        Uri.parse('$baseUrl/invalid-endpoint'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      expect(invalidEndpointResponse.statusCode, 404);

      // Test invalid data
      final invalidDataResponse = await http.post(
        Uri.parse('$baseUrl/cooperatives'),
          headers: {
            'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'invalid': 'data'}),
      );

      expect(invalidDataResponse.statusCode, 400);

      print('✅ Error handling test passed');
    } catch (e) {
      print('❌ Error handling test failed: $e');
      rethrow;
    }
  }

  // Performance Tests
  static Future<void> testPerformance() async {
    print('Testing API Performance...');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final stopwatch = Stopwatch()..start();

      // Test multiple concurrent requests
      final futures = List.generate(10, (index) async {
        return await http.get(
          Uri.parse('$baseUrl/cooperatives'),
          headers: headers,
        );
      });

      final responses = await Future.wait(futures);
        stopwatch.stop();

      // All requests should succeed
      for (final response in responses) {
        expect(response.statusCode, 200);
      }

      // Response time should be reasonable (less than 5 seconds for 10 requests)
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      print('✅ Performance test passed - ${stopwatch.elapsedMilliseconds}ms for 10 concurrent requests');
    } catch (e) {
      print('❌ Performance test failed: $e');
      rethrow;
    }
  }

  // Run all integration tests
  static Future<void> runAllTests() async {
    print('🚀 Starting API Integration Tests...\n');

    try {
      await setUp();

      await testAuthenticationFlow();
      await testCooperativeCRUD();
      await testBusinessCRUD();
      await testProjectCRUD();
      await testInvestmentCRUD();
      await testErrorHandling();
      await testPerformance();

      await tearDown();

      print('\n🎉 All integration tests passed!');
    } catch (e) {
      print('\n💥 Integration tests failed: $e');
      await tearDown();
      rethrow;
    }
  }
}

// Test runner
void main() {
  group('API Integration Tests', () {
    test('Run all integration tests', () async {
      await ApiIntegrationTest.runAllTests();
    });
  });
}
