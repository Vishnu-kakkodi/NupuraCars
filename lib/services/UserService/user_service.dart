import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/AuthModel/auth_model.dart';


class UserService {
  /// Fetch user details by ID
  Future<List<AuthModel>> fetchUser(String id) async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.getUser}/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => AuthModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  /// Update user profile image using multipart request
  Future<Map<String, dynamic>> updateProfileImage(File imageFile, String userId) async {
    final apiUrl = '${ApiConstants.baseUrl}${ApiConstants.editProfile}/$userId';
    final dio = Dio();

    try {
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');
      final contentType = MediaType(parts[0], parts[1]);

      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.${parts[1]}';

      final formData = FormData.fromMap({
        "profileImage": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: contentType,
        ),
      });

      final response = await dio.put(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            "accept": "*/*",
            "Content-Type": "multipart/form-data",
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update profile image: ${response.data}');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorData = e.response?.data;

      switch (statusCode) {
        case 400:
          throw Exception('Bad request. Please check the submitted data.');
        case 401:
          throw Exception('Unauthorized. Please log in again.');
        case 403:
          throw Exception('Forbidden. You don\'t have permission.');
        case 404:
          throw Exception('API endpoint not found: $apiUrl');
        case 500:
          throw Exception('Server error. Try again later.');
        default:
          throw Exception('Error uploading image: ${e.message} | $errorData');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
