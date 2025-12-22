

import 'dart:io';
import 'package:nupura_cars/models/DocumentModel/document_model.dart';
import 'package:nupura_cars/services/DocumentService/document_service.dart';
import 'package:flutter/material.dart';


class DocumentProvider with ChangeNotifier {
  final DocumentService _service = DocumentService();

  UploadedDocuments? uploadedDocuments;
  bool isLoading = false;
  String? errorMessage;

  // Fetch user documents
  Future<void> fetchDocuments(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      uploadedDocuments = await _service.getDocuments(userId);
    } catch (e) {
      errorMessage = e.toString();
      print("Error fetching documents: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Future<void> uploadDocuments(String userId, File aadharFile, File licenseFile) async {
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();

  //   try {
  //     uploadedDocuments = await _service.uploadDocuments(
  //       userId: userId,
  //       aadharFile: aadharFile,
  //       licenseFile: licenseFile,
  //     );
  //   } catch (e) {
  //     errorMessage = e.toString();
  //     print("Error in provider: $e");
  //   }

  //   isLoading = false;
  //   notifyListeners();
  // }
  


  // Updated provider function to handle nullable files
Future<void> uploadDocuments(String userId, File? aadharFile, File? licenseFile, bool isEdit) async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();

  try {
    uploadedDocuments = await _service.uploadDocuments(
      userId: userId,
      aadharFile: aadharFile,
      licenseFile: licenseFile,
      isEdit: isEdit
    );
      notifyListeners();

  } catch (e) {
    errorMessage = e.toString();
    print("Error in provider: $e");
      notifyListeners();

  }

  isLoading = false;
  notifyListeners();
}


  // Get document status string with proper formatting
  String getFormattedStatus(String status) {
    if (status == 'pending') {
      return 'Pending Verification';
    } else if (status == 'approved') {
      return 'Verified';
    } else if (status == 'rejected') {
      return 'Rejected';
    } else {
      return 'Unknown Status';
    }
  }
  
  // Get color based on document status
  Color getStatusColor(String status) {
    if (status == 'pending') {
      return Colors.orange;
    } else if (status == 'approved') {
      return Colors.green;
    } else if (status == 'rejected') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}