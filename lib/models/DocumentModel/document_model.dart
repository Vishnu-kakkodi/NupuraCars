
class DocumentInfo {
  final String url;
  final DateTime uploadedAt;
  final String status;

  DocumentInfo({
    required this.url,
    required this.uploadedAt,
    required this.status,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) {
    return DocumentInfo(
      url: json['url'] ?? '',
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt']) 
          : DateTime.now(),
      status: json['status'] ?? 'unknown',
    );
  }
}

class UploadedDocuments {
  final DocumentInfo? aadharCard;  // Made nullable
  final DocumentInfo? drivingLicense;  // Made nullable

  UploadedDocuments({
    this.aadharCard,  // No longer required
    this.drivingLicense,  // No longer required
  });

  // Add empty constructor
  UploadedDocuments.empty()
      : aadharCard = null,
        drivingLicense = null;

  factory UploadedDocuments.fromJson(Map<String, dynamic>? json) {
    // Handle null or empty json
    if (json == null || json.isEmpty) {
      return UploadedDocuments.empty();
    }

    return UploadedDocuments(
      aadharCard: json['aadharCard'] != null 
          ? DocumentInfo.fromJson(json['aadharCard']) 
          : null,
      drivingLicense: json['drivingLicense'] != null 
          ? DocumentInfo.fromJson(json['drivingLicense']) 
          : null,
    );
  }

  // Helper method to check if any documents exist
  bool get hasAnyDocuments => aadharCard != null || drivingLicense != null;
  
  // Helper method to check if all documents exist
  bool get hasAllDocuments => aadharCard != null && drivingLicense != null;
}

// Updated API service method
