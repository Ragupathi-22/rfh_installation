import 'dart:io';
import '../http/http_client.dart';
import '../../app_config/app_end_points.dart';
import '../../app_model/user_model.dart';

class LoginService {
  static Future<LoginResponse> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      // Prepare login data
      final loginData = {
        'mobileNumber': mobileNumber,
        'password': password,
         "DeviceId": "APC"
      };

      // Make API call
      final response = await RHttpHelper.post(
        EndPoints.login,
        loginData,
      );

      // Check if response has error
      if (response is Map<String, dynamic> && response['error'] == true) {
        throw LoginException(
          message: response['message'] ?? 'Login failed',
          statusCode: response['statusCode'] ?? 0,
        );
      }

      // Handle case where response might be wrapped in a data field
      dynamic responseData = response;
      print('response ${responseData}');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        responseData = response['data'];
      }

      // Parse response
      try {
        final loginResponse = LoginResponse.fromJson(responseData);
        
        // Validate response
        if (!loginResponse.isSuccess) {
          throw LoginException(
            message: loginResponse.message,
            statusCode: 400,
          );
        }

        if (loginResponse.userDetails.isEmpty) {
          throw LoginException(
            message: 'No user details found in response',
            statusCode: 400,
          );
        }

        return loginResponse;
      } catch (e) {
        print('Error parsing login response: $e');
        print('Response data that failed to parse: $responseData');
        
        // If the response is not in the expected format, try to extract useful information
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'] ?? responseData['error'] ?? 'Unknown error';
          throw LoginException(
            message: 'Invalid response format: $message',
            statusCode: 400,
          );
        } else {
          throw LoginException(
            message: 'Server returned unexpected response format',
            statusCode: 400,
          );
        }
      }
    } on SocketException {
      throw LoginException(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on HttpException {
      throw LoginException(
        message: 'Network error occurred. Please try again.',
        statusCode: 0,
      );
    } on FormatException {
      throw LoginException(
        message: 'Invalid response format from server.',
        statusCode: 0,
      );
    } on LoginException {
      rethrow;
    } catch (e) {
      throw LoginException(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

class LoginException implements Exception {
  final String message;
  final int statusCode;

  LoginException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => message;
}
