import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/DocumentModel/document_model.dart';

class DocumentService {
  Future<UploadedDocuments> getDocuments(String userId) async {
    final uri = Uri.parse(ApiConstants.getDocuments(userId));

    try {
      final response = await http.get(uri);
      print("📥 [GET] Documents => ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UploadedDocuments.fromJson(data['documents']);
      } else {
        throw Exception('Failed to fetch documents. Code: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error fetching documents: $e");
      throw Exception('Error getting documents: $e');
    }
  }

  Future<UploadedDocuments> uploadDocuments({
    required String userId,
    File? aadharFile,
    File? licenseFile,
    required bool isEdit
  }) async {
    final uri = Uri.parse(ApiConstants.uploadDocuments(userId, isEdit));
    final Method = isEdit ? 'PUT': 'POST';
    final request = http.MultipartRequest(Method, uri);

    MediaType? _getMediaType(String path) {
      final ext = path.split('.').last.toLowerCase();
      switch (ext) {
        case 'jpg':
        case 'jpeg':
          return MediaType('image', 'jpeg');
        case 'png':
          return MediaType('image', 'png');
        case 'pdf':
          return MediaType('application', 'pdf');
        default:
          throw Exception('Unsupported file type: $ext');
      }
    }

    try {
      if (aadharFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'aadharCard',
          aadharFile.path,
          contentType: _getMediaType(aadharFile.path),
        ));
      }

      if (licenseFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'drivingLicense',
          licenseFile.path,
          contentType: _getMediaType(licenseFile.path),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return UploadedDocuments.fromJson(data['documents']);
      } else {
        throw Exception('Failed to upload documents: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading documents: $e');
    }
  }
}
