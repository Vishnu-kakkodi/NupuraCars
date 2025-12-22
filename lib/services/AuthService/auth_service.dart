import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/helpers/Toast/toast_message.dart';
import 'package:nupura_cars/models/AuthModel/auth_model.dart';

class AuthService {
  final ToastMessageService _toast = ToastMessageService();

  Future<Map<String, dynamic>?> login(String mobile, String password) async {
    try {
      debugPrint("Mobile Number: $mobile");
            debugPrint("Password: $password");

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: ApiConstants.jsonHeaders,
        body: jsonEncode({'mobile': mobile, 'password': password}),
      );

      debugPrint('Status code: ${response.statusCode}');

                print("Status: ${response.statusCode}");
      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
        debugPrint('✅ Parsed Response Data: $responseData');
      } catch (jsonError) {
        debugPrint('❌ JSON Parse Error: $jsonError');
        throw Exception('Invalid JSON response from server: ${response.body}');
      }
      if (response.statusCode == 200) {
        debugPrint('✅ Success Response Received');

        // Extract user data and token from response
        final userData = responseData['user'];
        final token = responseData['token'];

        debugPrint('👤 User Data: $userData');
        debugPrint('🔑 Token: $token');

        if (userData != null) {
          return {'user': AuthModel.fromJson(userData), 'token': token};
        } else {
          throw Exception('Invalid response: No user data received');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Client error (4xx)
        debugPrint('❌ Client Error: ${response.statusCode}');
        final errorMessage =
            responseData['message'] ??
            responseData['error'] ??
            'Invalid OTP or request';
        throw Exception(errorMessage);
      } else if (response.statusCode >= 500) {
        // Server error (5xx)
        debugPrint('❌ Server Error: ${response.statusCode}');
        throw Exception('Server error. Please try again later.');
      } else {
        // Other status codes
        debugPrint('❌ Unexpected Status Code: ${response.statusCode}');
        final errorMessage =
            responseData['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌  Verification Error: $e');
      rethrow;
    }
  }

  Future<bool?> register(
    String name,
    String email,
    String mobile,
        String password,

    String? referralCode,
  ) async {
    try {
      final Map<String, dynamic> payload = {
        "name": name,
        "email": email,
        "mobile": mobile,
        'password': password
      };

      if (referralCode != "") {
        payload["code"] = referralCode;
      }

      debugPrint("Registration payload: $payload");

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}'),
        headers: ApiConstants.jsonHeaders,
        body: jsonEncode(payload),
      );

      print("Registration: ${response.statusCode}");

      debugPrint('Registration status code: ${response.statusCode}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("Registration response: $data");
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          "Registration Failed: ${errorData['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  /// Verify OTP and return user data with token
  Future<Map<String, dynamic>?> verifyOtp(String otp) async {
    try {
      debugPrint('🔄 Starting OTP verification...');
      debugPrint('📱 OTP Code: $otp');

      final requestBody = jsonEncode({'otp': otp});
      debugPrint('📤 Request Body: $requestBody');

      final uri = Uri.parse('http://31.97.206.144:4072/api/users/verify-otp');
      debugPrint('🌐 Request URL: $uri');

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: requestBody,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout - Server took too long to respond',
              );
            },
          );

      debugPrint('📊 Response Status Code: ${response.statusCode}');
      debugPrint('📋 Response Headers: ${response.headers}');
      debugPrint('📄 Raw Response Body: ${response.body}');

      // Check if response body is empty
      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
        debugPrint('✅ Parsed Response Data: $responseData');
      } catch (jsonError) {
        debugPrint('❌ JSON Parse Error: $jsonError');
        throw Exception('Invalid JSON response from server: ${response.body}');
      }

      if (response.statusCode == 200) {
        debugPrint('✅ Success Response Received');

        // Extract user data and token from response
        final userData = responseData['user'];
        final token = responseData['token'];

        debugPrint('👤 User Data: $userData');
        debugPrint('🔑 Token: $token');

        if (userData != null) {
          return {'user': AuthModel.fromJson(userData), 'token': token};
        } else {
          throw Exception('Invalid response: No user data received');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Client error (4xx)
        debugPrint('❌ Client Error: ${response.statusCode}');
        final errorMessage =
            responseData['message'] ??
            responseData['error'] ??
            'Invalid OTP or request';
        throw Exception(errorMessage);
      } else if (response.statusCode >= 500) {
        // Server error (5xx)
        debugPrint('❌ Server Error: ${response.statusCode}');
        throw Exception('Server error. Please try again later.');
      } else {
        // Other status codes
        debugPrint('❌ Unexpected Status Code: ${response.statusCode}');
        final errorMessage =
            responseData['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ OTP Verification Error: $e');
      rethrow;
    }
  }

  /// Resend OTP to the given mobile number
  Future<bool> resendOtp(String mobile) async {
    try {
      debugPrint('🔄 Resending OTP to: $mobile');

      final response = await http
          .post(
            Uri.parse('http://31.97.206.144:4072/api/users/resend-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'mobile': mobile}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout - Server took too long to respond',
              );
            },
          );

          print("Status: ${response.statusCode}");

      debugPrint('📊 Resend OTP Status Code: ${response.statusCode}');
      debugPrint('📄 Resend OTP Response: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('✅ OTP resent successfully');
        _toast.showSuccess('OTP sent successfully!');
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'] ?? 'Failed to resend OTP';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ Resend OTP Error: $e');
      rethrow;
    }
  }


  Future<Map<String, dynamic>> updateProfileImage(XFile imageFile, String userId) async {
    print("Image file: $imageFile");
    print("User ID: $userId");

    final apiUrl = 'http://31.97.206.144:4072/api/users/edit-profile/$userId';
    print("API URL: $apiUrl"); // Debug: Print the full URL

    final dio = Dio();

    try {

          print("Heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$userId");

      String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      String fileExtension = mimeType.split('/').last;

      FormData formData = FormData.fromMap({
        "profileImage": await MultipartFile.fromFile(
          imageFile.path,
          filename: "profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension",
          contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
        )
      });

      final response = await dio.put(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            "accept": "/",
            "Content-Type": "multipart/form-data",
          },
          // Add timeout
          sendTimeout: Duration(minutes: 2),
          receiveTimeout: Duration(minutes: 2),
        ),
      );



      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update profile image: ${response.data}');
      }
    } on DioException catch (e) {
      print("DioException occurred:");
      print("Type: ${e.type}");
      print("Message: ${e.message}");
      print("Response: ${e.response?.data}");
      print("Status Code: ${e.response?.statusCode}");
      
      // Handle specific error cases
      switch (e.response?.statusCode) {
        case 404:
          throw Exception('Endpoint not found. Please check the API URL: $apiUrl');
        case 400:
          throw Exception('Bad request. Please check the data being sent.');
        case 401:
          throw Exception('Unauthorized. Please check authentication.');
        case 403:
          throw Exception('Forbidden. You don\'t have permission to perform this action.');
        case 500:
          throw Exception('Server error. Please try again later.');
        default:
          throw Exception('Error uploading profile image: ${e.message}');
      }
    } catch (e) {
      print("General exception: $e");
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
