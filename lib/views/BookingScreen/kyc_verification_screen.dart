
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:image/image.dart' as img;
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class KycVerificationScreen extends StatefulWidget {
//   final String userId;
//   bool isEdit;
//   KycVerificationScreen({Key? key, required this.userId, required this.isEdit}) : super(key: key);

//   @override
//   State<KycVerificationScreen> createState() => _KycVerificationScreenState();
// }

// class _KycVerificationScreenState extends State<KycVerificationScreen> with TickerProviderStateMixin {
//   File? _aadharFrontFile;
//   File? _aadharBackFile;
//   File? _licenseFrontFile;
//   File? _licenseBackFile;
  
//   bool _isUploading = false;
//   bool _isValidating = false;
//   final ImagePicker _picker = ImagePicker();
//   final TextRecognizer _textRecognizer = TextRecognizer();

//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//   }

//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );

//     _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
//     );

//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _textRecognizer.close();
//     super.dispose();
//   }

//   // Aadhaar validation patterns
//   bool _isValidAadhaarDocument(String text) {
//     final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
//     // Check for Aadhaar-specific keywords
//     final aadhaarKeywords = [
//       'aadhaar',
//       'aadhar',
//       'government of india',
//       'भारत सरकार',
//       'unique identification authority of india',
//       'uidai',
//     ];
    
//     // Check for Aadhaar number pattern (12 digits with optional spaces/dashes)
//     final aadhaarNumberPattern = RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}\b');
    
//     bool hasKeyword = aadhaarKeywords.any((keyword) => cleanText.contains(keyword));
//     bool hasAadhaarNumber = aadhaarNumberPattern.hasMatch(text);
    
//     return hasKeyword || hasAadhaarNumber;
//   }

//   // Driving License validation patterns
//   bool _isValidLicenseDocument(String text) {
//     final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
//     // Check for Driving License specific keywords
//     final licenseKeywords = [
//       'driving licence',
//       'driving license',
//       'dl',
//       'transport',
//       'motor vehicles',
//       'ड्राइविंग लाइसेंस',
//       'वाहन',
//       'परिवहन',
//     ];
    
//     // Check for DL number patterns (varies by state, but generally alphanumeric)
//     final dlNumberPatterns = [
//       RegExp(r'\b[A-Z]{2}[0-9]{2}[A-Z0-9]{11,13}\b'),
//       RegExp(r'\b[A-Z]{2}-?[0-9]{2}-?[0-9]{4}-?[0-9]{7}\b'),
//     ];
    
//     bool hasKeyword = licenseKeywords.any((keyword) => cleanText.contains(keyword));
//     bool hasValidPattern = dlNumberPatterns.any((pattern) => pattern.hasMatch(text));
    
//     return hasKeyword || hasValidPattern;
//   }

//   // Basic image quality validation
//   bool _isValidImageQuality(File imageFile) {
//     try {
//       final bytes = imageFile.readAsBytesSync();
//       final image = img.decodeImage(bytes);
      
//       if (image == null) return false;
      
//       // Check minimum dimensions
//       if (image.width < 300 || image.height < 200) return false;
      
//       // Check file size (should be reasonable for a document)
//       if (bytes.length < 10000 || bytes.length > 10000000) return false; // 10KB to 10MB
      
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Combine two images vertically into a single image
//   Future<File> _combineImages(File frontImage, File backImage, String documentType) async {
//     try {
//       // Read image bytes
//       final frontBytes = await frontImage.readAsBytes();
//       final backBytes = await backImage.readAsBytes();
      
//       // Decode images
//       final frontImg = img.decodeImage(frontBytes)!;
//       final backImg = img.decodeImage(backBytes)!;
      
//       // Resize images to same width if needed
//       final maxWidth = frontImg.width > backImg.width ? frontImg.width : backImg.width;
//       final resizedFront = img.copyResize(frontImg, width: maxWidth);
//       final resizedBack = img.copyResize(backImg, width: maxWidth);
      
//       // Create combined image
//       final combinedHeight = resizedFront.height + resizedBack.height + 20; // 20px gap
//       final combinedImg = img.Image(width: maxWidth, height: combinedHeight, numChannels: 3);
      
//       // Fill with white background
//       img.fill(combinedImg, color: img.ColorRgb8(255, 255, 255));
      
//       // Add front image
//       img.compositeImage(combinedImg, resizedFront, dstX: 0, dstY: 0);
      
//       // Add back image with gap
//       img.compositeImage(combinedImg, resizedBack, dstX: 0, dstY: resizedFront.height + 20);
      
//       // Encode to JPEG
//       final combinedBytes = img.encodeJpg(combinedImg, quality: 85);
      
//       // Save to temporary file
//       final tempDir = Directory.systemTemp;
//       final combinedFile = File('${tempDir.path}/${documentType}_combined_${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await combinedFile.writeAsBytes(combinedBytes);
      
//       return combinedFile;
//     } catch (e) {
//       throw Exception('Failed to combine images: $e');
//     }
//   }

//   Future<bool> _validateDocument(File imageFile, bool isAadhar) async {
//     try {
//       setState(() => _isValidating = true);
      
//       // First, check basic image quality
//       if (!_isValidImageQuality(imageFile)) {
//         _showValidationError('Image quality is too low. Please upload a clear photo.');
//         return false;
//       }
      
//       // Perform text recognition
//       final inputImage = InputImage.fromFile(imageFile);
//       final recognizedText = await _textRecognizer.processImage(inputImage);
      
//       final extractedText = recognizedText.text;
      
//       if (extractedText.isEmpty) {
//         _showValidationError('No text found in image. Please upload a clear document photo.');
//         return false;
//       }
      
//       bool isValid = false;
//       if (isAadhar) {
//         isValid = _isValidAadhaarDocument(extractedText);
//         if (!isValid) {
//           _showValidationError('This doesn\'t appear to be an Aadhaar card. Please upload a valid Aadhaar document.');
//         }
//       } else {
//         isValid = _isValidLicenseDocument(extractedText);
//         if (!isValid) {
//           _showValidationError('This doesn\'t appear to be a driving license. Please upload a valid driving license.');
//         }
//       }
      
//       return isValid;
//     } catch (e) {
//       _showValidationError('Document validation failed. Please try again.');
//       return false;
//     } finally {
//       setState(() => _isValidating = false);
//     }
//   }

//   void _showValidationError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFFDC2626),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: Duration(seconds: 4),
//       ),
//     );
//   }

//   Future<void> _pickImage(ImageSource source, String documentType, String side) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         imageQuality: 80,
//         maxWidth: 1920,
//         maxHeight: 1080,
//       );
      
//       if (image != null) {
//         final imageFile = File(image.path);
//         bool isValid = false;
        
//         if (documentType == 'license' && side == 'back') {
//           isValid = true;
//         } else {
//           isValid = await _validateDocument(imageFile, documentType == 'aadhar');
//         }
        
//         if (isValid) {
//           setState(() {
//             if (documentType == 'aadhar' && side == 'front') {
//               _aadharFrontFile = imageFile;
//             } else if (documentType == 'aadhar' && side == 'back') {
//               _aadharBackFile = imageFile;
//             } else if (documentType == 'license' && side == 'front') {
//               _licenseFrontFile = imageFile;
//             } else if (documentType == 'license' && side == 'back') {
//               _licenseBackFile = imageFile;
//             }
//           });
          
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   SizedBox(width: 12),
//                   Text('Document ${side} side validated successfully!'),
//                 ],
//               ),
//               backgroundColor: const Color(0xFF16A34A),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Error: ${e.toString()}')),
//             ],
//           ),
//           backgroundColor: const Color(0xFFDC2626),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     }
//   }

//   Future<void> _submitDocuments() async {
//     // Check if at least one complete document (front + back) is uploaded
//     bool hasCompleteAadhar = _aadharFrontFile != null && _aadharBackFile != null;
//     bool hasCompleteLicense = _licenseFrontFile != null && _licenseBackFile != null;
    
//     if (!hasCompleteAadhar && !hasCompleteLicense) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.warning_rounded, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Please upload both front and back sides of at least one document')),
//             ],
//           ),
//           backgroundColor: const Color(0xFFF59E0B),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }

//     setState(() => _isUploading = true);

//     try {
//       File? combinedAadhar;
//       File? combinedLicense;
      
//       // Combine Aadhar images if both are available
//       if (hasCompleteAadhar) {
//         combinedAadhar = await _combineImages(_aadharFrontFile!, _aadharBackFile!, 'aadhar');
//       }
      
//       // Combine License images if both are available
//       if (hasCompleteLicense) {
//         combinedLicense = await _combineImages(_licenseFrontFile!, _licenseBackFile!, 'license');
//       }

//       final provider = Provider.of<DocumentProvider>(context, listen: false);
//       await provider.uploadDocuments(widget.userId, combinedAadhar, combinedLicense, widget.isEdit);

//       if (provider.errorMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error_outline, color: Colors.white),
//                 SizedBox(width: 12),
//                 Expanded(child: Text(provider.errorMessage!)),
//               ],
//             ),
//             backgroundColor: const Color(0xFFDC2626),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//         );
//       } else {
//         _showSuccessDialog();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Upload failed: ${e.toString()}')),
//             ],
//           ),
//           backgroundColor: const Color(0xFFDC2626),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   void _showFullScreenImage(File imageFile) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => FullScreenImageViewer(imageFile: imageFile),
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF16A34A).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_circle_rounded,
//                   color: Color(0xFF16A34A),
//                   size: 50,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Success!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Your documents have been submitted successfully. We\'ll review them and notify you once they\'re approved.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF6B7280),
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close dialog
//                     Navigator.pop(context, true); // Return to previous screen
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1A73E8),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentCard(String title, File? frontFile, File? backFile, String documentType) {
//     bool isComplete = frontFile != null && backFile != null;
//     final iconData = documentType == 'aadhar' ? Icons.credit_card_rounded : Icons.directions_car_rounded;
//     final cardColor = documentType == 'aadhar' ? const Color(0xFFFF6B35) : const Color(0xFF7C3AED);
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: cardColor.withOpacity(0.08),
//             blurRadius: 25,
//             offset: const Offset(0, 8),
//           ),
//         ],
//         border: Border.all(
//           color: isComplete ? cardColor.withOpacity(0.3) : const Color(0xFFE5E7EB),
//           width: 2,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: cardColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: cardColor.withOpacity(0.2)),
//                   ),
//                   child: Icon(
//                     iconData,
//                     color: cardColor,
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Upload both front and back sides',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: const Color(0xFF6B7280),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (isComplete)
//                   Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF16A34A),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.check_rounded,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildImageSection(
//                     'Front Side',
//                     frontFile,
//                     () => _showImageOptions(documentType, 'front'),
//                     cardColor,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildImageSection(
//                     'Back Side',
//                     backFile,
//                     () => _showImageOptions(documentType, 'back'),
//                     cardColor,
//                   ),
//                 ),
//               ],
//             ),
            
//             if (isComplete) ...[
//               const SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF16A34A).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.2)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.verified_rounded,
//                       color: const Color(0xFF16A34A),
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Both sides uploaded and validated',
//                       style: TextStyle(
//                         color: Color(0xFF16A34A),
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImageSection(String label, File? imageFile, VoidCallback onTap, Color themeColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: imageFile != null ? () => _showFullScreenImage(imageFile) : null,
//           child: Container(
//             height: 100,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: imageFile != null ? themeColor : const Color(0xFFD1D5DB),
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               color: imageFile != null 
//                   ? themeColor.withOpacity(0.05) 
//                   : const Color(0xFFF9FAFB),
//             ),
//             child: imageFile != null
//                 ? Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.file(
//                           imageFile,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       ),
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: Container(
//                           width: 24,
//                           height: 24,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF16A34A),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.check_rounded,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.add_a_photo_rounded,
//                         color: const Color(0xFF9CA3AF),
//                         size: 32,
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Tap to upload',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF6B7280),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _isValidating ? null : onTap,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: imageFile == null ? themeColor : const Color(0xFF6B7280),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   imageFile == null ? 'Upload' : 'Change',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             if (imageFile != null) ...[
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: _isValidating ? null : () => setState(() {
//                   if (label.contains('Front')) {
//                     if (label.contains('Identity') || label.contains('Aadhaar')) {
//                       _aadharFrontFile = null;
//                     } else {
//                       _licenseFrontFile = null;
//                     }
//                   } else {
//                     if (label.contains('Identity') || label.contains('Aadhaar')) {
//                       _aadharBackFile = null;
//                     } else {
//                       _licenseBackFile = null;
//                     }
//                   }
//                 }),
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFDC2626).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.delete_outline_rounded,
//                     color: Color(0xFFDC2626),
//                     size: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ],
//     );
//   }

//   void _showImageOptions(String documentType, String side) {
//     String docName = documentType == 'aadhar' ? 'Identity Card' : 'Driving License';
//     final color = documentType == 'aadhar' ? const Color(0xFFFF6B35) : const Color(0xFF7C3AED);
    
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(top: 12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE5E7EB),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             documentType == 'aadhar' ? Icons.credit_card_rounded : Icons.directions_car_rounded,
//                             color: color,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Upload $docName',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               Text(
//                                 '${side.substring(0, 1).toUpperCase()}${side.substring(1)} side',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF6B7280),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     _buildOptionTile(
//                       icon: Icons.camera_alt_rounded,
//                       title: 'Take Photo',
//                       subtitle: 'Capture document with camera',
//                       onTap: () {
//                         Navigator.pop(context);
//                         _pickImage(ImageSource.camera, documentType, side);
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     _buildOptionTile(
//                       icon: Icons.photo_library_rounded,
//                       title: 'Choose from Gallery',
//                       subtitle: 'Select from device storage',
//                       onTap: () {
//                         Navigator.pop(context);
//                         _pickImage(ImageSource.gallery, documentType, side);
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1A73E8).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: const Color(0xFF1A73E8),
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: Color(0xFF9CA3AF),
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool canSubmit = (_aadharFrontFile != null && _aadharBackFile != null) || 
//                      (_licenseFrontFile != null && _licenseBackFile != null);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 150,
//             floating: false,
//             pinned: true,
//             elevation: 0,
//             backgroundColor: const Color(0xFF1A73E8),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFF1A73E8),
//                       Color(0xFF4285F4),
//                       Color(0xFF34A853),
//                     ],
//                     stops: [0.0, 0.6, 1.0],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.3),
//                                 ),
//                               ),
//                               child: const Icon(
//                                 Icons.verified_user_rounded,
//                                 color: Colors.white,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     widget.isEdit ? 'Update Documents' : 'Identity Verification',
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Text(
//                                     'Secure • Fast • Automated',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white70,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             leading: Container(
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(
//                   Icons.arrow_back_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF3B82F6).withOpacity(0.05),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: const Color(0xFF3B82F6).withOpacity(0.1),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFF3B82F6).withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: const Icon(
//                                     Icons.info_outline_rounded,
//                                     color: Color(0xFF3B82F6),
//                                     size: 20,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 const Expanded(
//                                   child: Text(
//                                     'Upload Requirements',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF1F2937),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Please upload both front and back sides of at least one document. Our AI will automatically validate your documents for authenticity and clarity.',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF6B7280),
//                                 height: 1.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                      
//                       if (_isValidating)
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(16),
//                           margin: const EdgeInsets.only(bottom: 20),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color(0xFF1A73E8).withOpacity(0.1),
//                                 const Color(0xFF4285F4).withOpacity(0.05),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: const Color(0xFF1A73E8).withOpacity(0.2)),
//                           ),
//                           child: Row(
//                             children: [
//                               SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               const Expanded(
//                                 child: Text(
//                                   'AI is validating your document...',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF1A73E8),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
                      
//                       _buildDocumentCard(
//                         'Identity Card (Aadhaar)',
//                         _aadharFrontFile,
//                         _aadharBackFile,
//                         'aadhar',
//                       ),
                      
//                       _buildDocumentCard(
//                         'Driving License',
//                         _licenseFrontFile,
//                         _licenseBackFile,
//                         'license',
//                       ),
                      
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFEF3C7),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2)),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.lightbulb_outline_rounded,
//                               color: const Color(0xFFF59E0B),
//                               size: 20,
//                             ),
//                             const SizedBox(width: 12),
//                             const Expanded(
//                               child: Text(
//                                 'Ensure documents are well-lit, in focus, and all text is clearly readable for faster verification.',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF92400E),
//                                   height: 1.4,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                      
//                       if (_isUploading)
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               CircularProgressIndicator(
//                                 strokeWidth: 3,
//                                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Uploading and processing your documents...',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF374151),
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 'This may take a few moments',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF6B7280),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       else
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: canSubmit && !_isValidating ? _submitDocuments : null,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: canSubmit && !_isValidating 
//                                   ? const Color(0xFF16A34A) 
//                                   : const Color(0xFF9CA3AF),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 18),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               elevation: 0,
//                               shadowColor: Colors.transparent,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.cloud_upload_rounded,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   widget.isEdit ? 'Update Documents' : 'Submit for Verification',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                      
//                       const SizedBox(height: 16),
                      
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.lock_rounded,
//                             color: const Color(0xFF9CA3AF),
//                             size: 16,
//                           ),
//                           const SizedBox(width: 8),
//                           const Text(
//                             'Your documents are encrypted and stored securely',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFF9CA3AF),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
                      
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Enhanced Full Screen Image Viewer
// class FullScreenImageViewer extends StatefulWidget {
//   final File imageFile;
  
//   const FullScreenImageViewer({Key? key, required this.imageFile}) : super(key: key);

//   @override
//   State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
// }

// class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
//   final TransformationController _transformationController = TransformationController();

//   @override
//   void dispose() {
//     _transformationController.dispose();
//     super.dispose();
//   }

//   void _resetZoom() {
//     _transformationController.value = Matrix4.identity();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close_rounded, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Document Preview',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.refresh_rounded,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             onPressed: _resetZoom,
//             tooltip: 'Reset Zoom',
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Center(
//         child: Hero(
//           tag: widget.imageFile.path,
//           child: InteractiveViewer(
//             transformationController: _transformationController,
//             panEnabled: true,
//             scaleEnabled: true,
//             minScale: 0.5,
//             maxScale: 5.0,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.white.withOpacity(0.1),
//                     blurRadius: 20,
//                     spreadRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Image.file(
//                 widget.imageFile,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(20),
//         color: Colors.black,
//         child: SafeArea(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.zoom_in_rounded,
//                 color: Colors.white.withOpacity(0.7),
//                 size: 16,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Pinch to zoom • Drag to pan',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.7),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }













import 'dart:io';
import 'dart:typed_data';
import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class KycVerificationScreen extends StatefulWidget {
  final String userId;
  final bool isEdit;
  
  const KycVerificationScreen({
    Key? key,
    required this.userId,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  File? _aadharFrontFile;
  File? _aadharBackFile;
  File? _licenseFrontFile;
  File? _licenseBackFile;
  
  bool _isUploading = false;
  bool _isValidating = false;
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  // Aadhaar validation patterns
  bool _isValidAadhaarDocument(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final aadhaarKeywords = [
      'aadhaar',
      'aadhar',
      'government of india',
      'भारत सरकार',
      'unique identification authority of india',
      'uidai',
    ];
    
    final aadhaarNumberPattern = RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}\b');
    
    bool hasKeyword = aadhaarKeywords.any((keyword) => cleanText.contains(keyword));
    bool hasAadhaarNumber = aadhaarNumberPattern.hasMatch(text);
    
    return hasKeyword || hasAadhaarNumber;
  }

  // Driving License validation patterns
  bool _isValidLicenseDocument(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final licenseKeywords = [
      'driving licence',
      'driving license',
      'dl',
      'transport',
      'motor vehicles',
      'ड्राइविंग लाइसेंस',
      'वाहन',
      'परिवहन',
    ];
    
    final dlNumberPatterns = [
      RegExp(r'\b[A-Z]{2}[0-9]{2}[A-Z0-9]{11,13}\b'),
      RegExp(r'\b[A-Z]{2}-?[0-9]{2}-?[0-9]{4}-?[0-9]{7}\b'),
    ];
    
    bool hasKeyword = licenseKeywords.any((keyword) => cleanText.contains(keyword));
    bool hasValidPattern = dlNumberPatterns.any((pattern) => pattern.hasMatch(text));
    
    return hasKeyword || hasValidPattern;
  }

  // Basic image quality validation
  bool _isValidImageQuality(File imageFile) {
    try {
      final bytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(bytes);
      
      if (image == null) return false;
      
      // Check minimum dimensions
      if (image.width < 300 || image.height < 200) return false;
      
      // Check file size
      if (bytes.length < 10000 || bytes.length > 10000000) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Combine two images vertically into a single image
  Future<File> _combineImages(File frontImage, File backImage, String documentType) async {
    try {
      final frontBytes = await frontImage.readAsBytes();
      final backBytes = await backImage.readAsBytes();
      
      final frontImg = img.decodeImage(frontBytes)!;
      final backImg = img.decodeImage(backBytes)!;
      
      final maxWidth = frontImg.width > backImg.width ? frontImg.width : backImg.width;
      final resizedFront = img.copyResize(frontImg, width: maxWidth);
      final resizedBack = img.copyResize(backImg, width: maxWidth);
      
      final combinedHeight = resizedFront.height + resizedBack.height + 20;
      final combinedImg = img.Image(width: maxWidth, height: combinedHeight, numChannels: 3);
      
      img.fill(combinedImg, color: img.ColorRgb8(255, 255, 255));
      
      img.compositeImage(combinedImg, resizedFront, dstX: 0, dstY: 0);
      img.compositeImage(combinedImg, resizedBack, dstX: 0, dstY: resizedFront.height + 20);
      
      final combinedBytes = img.encodeJpg(combinedImg, quality: 85);
      
      final tempDir = Directory.systemTemp;
      final combinedFile = File('${tempDir.path}/${documentType}_combined_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await combinedFile.writeAsBytes(combinedBytes);
      
      return combinedFile;
    } catch (e) {
      throw Exception('Failed to combine images: $e');
    }
  }

  Future<bool> _validateDocument(File imageFile, bool isAadhar) async {
    try {
      setState(() => _isValidating = true);
      
      if (!_isValidImageQuality(imageFile)) {
        _showValidationError('Image quality is too low. Please upload a clear photo.');
        return false;
      }
      
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      final extractedText = recognizedText.text;
      
      if (extractedText.isEmpty) {
        _showValidationError('No text found in image. Please upload a clear document photo.');
        return false;
      }
      
      bool isValid = false;
      if (isAadhar) {
        isValid = _isValidAadhaarDocument(extractedText);
        if (!isValid) {
          _showValidationError('This doesn\'t appear to be an Aadhaar card. Please upload a valid Aadhaar document.');
        }
      } else {
        isValid = _isValidLicenseDocument(extractedText);
        if (!isValid) {
          _showValidationError('This doesn\'t appear to be a driving license. Please upload a valid driving license.');
        }
      }
      
      return isValid;
    } catch (e) {
      _showValidationError('Document validation failed. Please try again.');
      return false;
    } finally {
      setState(() => _isValidating = false);
    }
  }

  void _showValidationError(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onError),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, String documentType, String side) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      
      if (image != null) {
        final imageFile = File(image.path);
        bool isValid = false;
        
        if (documentType == 'license' && side == 'back') {
          isValid = true;
        } else {
          isValid = await _validateDocument(imageFile, documentType == 'aadhar');
        }
        
        if (isValid) {
          setState(() {
            if (documentType == 'aadhar' && side == 'front') {
              _aadharFrontFile = imageFile;
            } else if (documentType == 'aadhar' && side == 'back') {
              _aadharBackFile = imageFile;
            } else if (documentType == 'license' && side == 'front') {
              _licenseFrontFile = imageFile;
            } else if (documentType == 'license' && side == 'back') {
              _licenseBackFile = imageFile;
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(width: 12),
                  Text('Document ${side} side validated successfully!'),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
              const SizedBox(width: 12),
              Expanded(child: Text('Error: ${e.toString()}')),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _submitDocuments() async {
    bool hasCompleteAadhar = _aadharFrontFile != null && _aadharBackFile != null;
    bool hasCompleteLicense = _licenseFrontFile != null && _licenseBackFile != null;
    
    if (!hasCompleteAadhar && !hasCompleteLicense) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Theme.of(context).colorScheme.onError),
              const SizedBox(width: 12),
              const Expanded(child: Text('Please upload both front and back sides of at least one document')),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      File? combinedAadhar;
      File? combinedLicense;
      
      if (hasCompleteAadhar) {
        combinedAadhar = await _combineImages(_aadharFrontFile!, _aadharBackFile!, 'aadhar');
      }
      
      if (hasCompleteLicense) {
        combinedLicense = await _combineImages(_licenseFrontFile!, _licenseBackFile!, 'license');
      }

      final provider = Provider.of<DocumentProvider>(context, listen: false);
      await provider.uploadDocuments(widget.userId, combinedAadhar, combinedLicense, widget.isEdit);

      if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
                const SizedBox(width: 12),
                Expanded(child: Text(provider.errorMessage!)),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      } else {
        _showSuccessDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
              const SizedBox(width: 12),
              Expanded(child: Text('Upload failed: ${e.toString()}')),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showFullScreenImage(File imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageFile: imageFile),
      ),
    );
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: colorScheme.primary,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Success!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your documents have been submitted successfully. We\'ll review them and notify you once they\'re approved.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(String title, File? frontFile, File? backFile, String documentType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isComplete = frontFile != null && backFile != null;
    final iconData = documentType == 'aadhar' ? Icons.credit_card_rounded : Icons.directions_car_rounded;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  iconData,
                  color: colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Upload both front and back sides',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isComplete)
                  Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildImageSection(
                    'Front Side',
                    frontFile,
                    () => _showImageOptions(documentType, 'front'),
                    theme,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildImageSection(
                    'Back Side',
                    backFile,
                    () => _showImageOptions(documentType, 'back'),
                    theme,
                    colorScheme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
    String label,
    File? imageFile,
    VoidCallback onTap,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: imageFile != null ? () => _showFullScreenImage(imageFile) : null,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: imageFile != null ? colorScheme.primary : colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: imageFile != null 
                  ? colorScheme.primary.withOpacity(0.05) 
                  : colorScheme.surfaceVariant,
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        color: colorScheme.onSurface.withOpacity(0.5),
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to upload',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isValidating ? null : onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  imageFile == null ? 'Upload' : 'Change',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            if (imageFile != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isValidating ? null : () => setState(() {
                  if (label.contains('Front')) {
                    if (label.contains('Identity') || label.contains('Aadhaar')) {
                      _aadharFrontFile = null;
                    } else {
                      _licenseFrontFile = null;
                    }
                  } else {
                    if (label.contains('Identity') || label.contains('Aadhaar')) {
                      _aadharBackFile = null;
                    } else {
                      _licenseBackFile = null;
                    }
                  }
                }),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showImageOptions(String documentType, String side) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String docName = documentType == 'aadhar' ? 'Identity Card' : 'Driving License';

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload $docName - ${side} side',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.camera_alt_rounded, color: colorScheme.primary),
              title: const Text('Take Photo'),
              subtitle: const Text('Capture document with camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, documentType, side);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: colorScheme.primary),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select from device storage'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, documentType, side);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool canSubmit = (_aadharFrontFile != null && _aadharBackFile != null) || 
                     (_licenseFrontFile != null && _licenseBackFile != null);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Update Documents' : 'Identity Verification'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Upload Requirements',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please upload both front and back sides of at least one document. Our AI will automatically validate your documents for authenticity and clarity.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            if (_isValidating)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircularProgressIndicator(color: colorScheme.primary),
                      const SizedBox(width: 16),
                      Text(
                        'AI is validating your document...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            _buildDocumentCard(
              'Identity Card (Aadhaar)',
              _aadharFrontFile,
              _aadharBackFile,
              'aadhar',
            ),
            
            const SizedBox(height: 16),
            
            _buildDocumentCard(
              'Driving License',
              _licenseFrontFile,
              _licenseBackFile,
              'license',
            ),
            
            const SizedBox(height: 16),
            
            Card(
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ensure documents are well-lit, in focus, and all text is clearly readable for faster verification.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (_isUploading)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Uploading and processing your documents...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSubmit && !_isValidating ? _submitDocuments : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSubmit ? colorScheme.primary : colorScheme.surfaceVariant,
                    foregroundColor: canSubmit ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_rounded),
                      const SizedBox(width: 12),
                      Text(
                        widget.isEdit ? 'Update Documents' : 'Submit for Verification',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            Center(
              child: Text(
                'Your documents are encrypted and stored securely',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final File imageFile;
  
  const FullScreenImageViewer({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(
            imageFile,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}