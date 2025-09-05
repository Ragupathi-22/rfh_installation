import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../app_config/app_end_points.dart';

class RHttpHelper {
  static const String _baseUrl = EndPoints.baseApi;

  // Helper method to make a GET request
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Helper method to make a POST request
  static Future<dynamic> post(String endpoint, dynamic data,
      {Map<String, String>? customHeaders}) async {
    // Default headers
    final headers = {
      'Content-Type': 'application/json',
    };

    // Add custom headers if provided
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    // Construct the full URL
    final url = '$_baseUrl$endpoint';

    /// API CALLS
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
    );    
    return _handleResponse(response);
  }

  // Helper method to make a PUT request
  static Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a DELETE request
  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Handle the HTTP response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Try to parse as JSON for successful responses
      try {
        return json.decode(response.body);
      } catch (e) {
        // If JSON parsing fails for successful response, return the raw body
        return {
          'error': false,
          'statusCode': response.statusCode,
          'message': 'Success',
          'data': response.body,
        };
      }
    } else {
      // For error responses, try to parse as JSON first
      try {
        final responseData = json.decode(response.body);
        return {
          'error': true,
          'statusCode': response.statusCode,
          'message': responseData['message'] ?? 'Request failed with status ${response.statusCode}',
          'data': responseData,
        };
      } catch (e) {
        // If JSON parsing fails, return the raw response body
        return {
          'error': true,
          'statusCode': response.statusCode,
          'message': response.body.isNotEmpty 
              ? response.body 
              : 'Request failed with status ${response.statusCode}',
          'data': response.body,
        };
      }
    }
  }
}
