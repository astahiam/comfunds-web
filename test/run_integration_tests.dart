import 'package:flutter_test/flutter_test.dart';
import 'integration/enhanced_api_integration_test.dart' as api_tests;
import 'integration/frontend_integration_test.dart' as frontend_tests;

void main() {
  group('Complete Integration Test Suite', () {
    print('🚀 Starting Complete Integration Test Suite...');
    
    group('API Integration Tests', () {
      api_tests.main();
    });
    
    group('Frontend Integration Tests', () {
      frontend_tests.main();
    });
  });
}
