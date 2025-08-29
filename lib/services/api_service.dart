import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // HTTP Headers
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic HTTP methods
  static Future<http.Response> get(String endpoint) async {
    final headers = await _authHeaders;
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }

  // Public GET method (no authentication required)
  static Future<http.Response> getPublic(String endpoint) async {
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _authHeaders;
    return await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }

  // Response handling
  static Map<String, dynamic> parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body.isNotEmpty 
            ? jsonDecode(response.body)['message'] ?? 'Unknown error'
            : 'HTTP ${response.statusCode}',
      );
    }
  }

  // Error handling
  static String handleError(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is FormatException) {
      return 'Invalid response format';
    } else {
      return 'Network error: ${error.toString()}';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
