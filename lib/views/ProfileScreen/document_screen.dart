
// import 'package:nupura_cars/models/DocumentModel/document_model.dart';
// import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
// import 'package:nupura_cars/views/BookingScreen/kyc_verification_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class Documents extends StatefulWidget {
//   const Documents({Key? key}) : super(key: key);

//   @override
//   State<Documents> createState() => _DocumentsState();
// }

// class _DocumentsState extends State<Documents> with TickerProviderStateMixin {
//   late String userId;
//   bool isLoading = true;
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _getUserIdAndFetchDocuments();
//   }

//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
//           CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
//         );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
//     );
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   Future<void> _getUserIdAndFetchDocuments() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       userId = prefs.getString('userId') ?? '';

//       if (userId.isNotEmpty) {
//         await Provider.of<DocumentProvider>(
//           context,
//           listen: false,
//         ).fetchDocuments(userId);
//       } else {
//         print('User ID not found in SharedPreferences');
//       }
//     } catch (e) {
//       print('Error getting user ID: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         _fadeController.forward();
//         _slideController.forward();
//         _scaleController.forward();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(context, isTablet),
//           SliverToBoxAdapter(
//             child: Consumer<DocumentProvider>(
//               builder: (context, documentProvider, child) {
//                 if (documentProvider.isLoading || isLoading) {
//                   return _buildLoadingState(isTablet);
//                 }

//                 if (documentProvider.errorMessage != null) {
//                   return _buildErrorState(
//                     context,
//                     documentProvider,
//                     isTablet,
//                   );
//                 }

//                 final documents = documentProvider.uploadedDocuments;

//                 return FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: _buildDocumentsContent(
//                         context,
//                         documents,
//                         documentProvider,
//                         isTablet,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSliverAppBar(BuildContext context, bool isTablet) {
//     final theme = Theme.of(context);
    
//     return SliverAppBar(
//       expandedHeight: isTablet ? 200 : 160,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: const Color(0xFF1A73E8),
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF1A73E8),
//                 Color(0xFF4285F4),
//                 Color(0xFF34A853),
//               ],
//               stops: [0.0, 0.6, 1.0],
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.all(isTablet ? 32 : 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(isTablet ? 12 : 8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.shield_rounded,
//                           color: Colors.white,
//                           size: isTablet ? 32 : 24,
//                         ),
//                       ),
//                       SizedBox(width: isTablet ? 16 : 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Document Vault',
//                               style: TextStyle(
//                                 fontSize: isTablet ? 28 : 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                             SizedBox(height: isTablet ? 8 : 4),
//                             Text(
//                               'Secure • Verified • Trusted',
//                               style: TextStyle(
//                                 fontSize: isTablet ? 16 : 14,
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(
//             Icons.arrow_back_rounded,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState(bool isTablet) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: isTablet ? 100 : 80,
//               height: isTablet ? 100 : 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF1A73E8).withOpacity(0.1),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
//                 ),
//               ),
//             ),
//             SizedBox(height: isTablet ? 32 : 24),
//             Text(
//               'Fetching your documents...',
//               style: TextStyle(
//                 fontSize: isTablet ? 18 : 16,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF374151),
//               ),
//             ),
//             SizedBox(height: isTablet ? 12 : 8),
//             Text(
//               'Please wait while we load your verification files',
//               style: TextStyle(
//                 fontSize: isTablet ? 16 : 14,
//                 color: const Color(0xFF6B7280),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState(
//     BuildContext context,
//     DocumentProvider provider,
//     bool isTablet,
//   ) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       padding: EdgeInsets.all(isTablet ? 40 : 24),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: isTablet ? 120 : 100,
//               height: isTablet ? 120 : 100,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFEE2E2),
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: Icon(
//                 Icons.cloud_off_rounded,
//                 size: isTablet ? 60 : 50,
//                 color: const Color(0xFFDC2626),
//               ),
//             ),
//             SizedBox(height: isTablet ? 32 : 24),
//             Text(
//               'Connection Issue',
//               style: TextStyle(
//                 fontSize: isTablet ? 24 : 20,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF1F2937),
//               ),
//             ),
//             SizedBox(height: isTablet ? 16 : 12),
//             Text(
//               provider.errorMessage ?? 'Unable to load documents',
//               style: TextStyle(
//                 fontSize: isTablet ? 16 : 14,
//                 color: const Color(0xFF6B7280),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: isTablet ? 40 : 32),
//             ElevatedButton.icon(
//               onPressed: _getUserIdAndFetchDocuments,
//               icon: const Icon(Icons.refresh_rounded, color: Colors.white),
//               label: const Text(
//                 'Retry',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1A73E8),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isTablet ? 32 : 24,
//                   vertical: isTablet ? 16 : 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentsContent(
//     BuildContext context,
//     UploadedDocuments? documents,
//     DocumentProvider provider,
//     bool isTablet,
//   ) {
//     if (!_hasDocuments(documents)) {
//       return _buildEmptyState(context, isTablet);
//     }

//     return Padding(
//       padding: EdgeInsets.all(isTablet ? 24 : 16),
//       child: Column(
//         children: [
//           _buildStatusCard(context, documents!, isTablet),
//           SizedBox(height: isTablet ? 24 : 20),
//           _buildDocumentGrid(context, documents, provider, isTablet),
//           SizedBox(height: isTablet ? 32 : 24),
//           _buildActionSection(context, documents, isTablet),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusCard(
//     BuildContext context,
//     UploadedDocuments documents,
//     bool isTablet,
//   ) {
//     final completedDocs = _getCompletedDocumentsCount(documents);
//     final totalDocs = 2;
//     final progress = completedDocs / totalDocs;
    
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1A73E8).withOpacity(0.08),
//             blurRadius: 25,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isTablet ? 16 : 12),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.verified_user_rounded,
//                   color: Colors.white,
//                   size: isTablet ? 28 : 24,
//                 ),
//               ),
//               SizedBox(width: isTablet ? 16 : 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Verification Progress',
//                       style: TextStyle(
//                         fontSize: isTablet ? 18 : 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1F2937),
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 8 : 6),
//                     Text(
//                       '$completedDocs of $totalDocs documents verified',
//                       style: TextStyle(
//                         fontSize: isTablet ? 14 : 12,
//                         color: const Color(0xFF6B7280),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               CircleAvatar(
//                 radius: isTablet ? 28 : 24,
//                 backgroundColor: const Color(0xFFEBF8FF),
//                 child: Text(
//                   '${(progress * 100).toInt()}%',
//                   style: TextStyle(
//                     fontSize: isTablet ? 14 : 12,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF1A73E8),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: isTablet ? 20 : 16),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: progress,
//               minHeight: isTablet ? 8 : 6,
//               backgroundColor: const Color(0xFFE5E7EB),
//               valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34A853)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentGrid(
//     BuildContext context,
//     UploadedDocuments documents,
//     DocumentProvider provider,
//     bool isTablet,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
//           child: Text(
//             'Your Documents',
//             style: TextStyle(
//               fontSize: isTablet ? 22 : 18,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xFF1F2937),
//             ),
//           ),
//         ),
//         SizedBox(height: isTablet ? 16 : 12),
//         _buildModernDocumentCard(
//           context,
//           title: 'Identity Card',
//           subtitle: 'Government issued Aadhar',
//           icon: Icons.credit_card_rounded,
//           color: const Color(0xFFFF6B35),
//           documentInfo: documents.aadharCard,
//           provider: provider,
//           isTablet: isTablet,
//         ),
//         SizedBox(height: isTablet ? 16 : 12),
//         _buildModernDocumentCard(
//           context,
//           title: 'Driving License',
//           subtitle: 'Valid driving permit',
//           icon: Icons.directions_car_rounded,
//           color: const Color(0xFF7C3AED),
//           documentInfo: documents.drivingLicense,
//           provider: provider,
//           isTablet: isTablet,
//         ),
//       ],
//     );
//   }

//   Widget _buildModernDocumentCard(
//     BuildContext context, {
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//     required DocumentInfo? documentInfo,
//     required DocumentProvider provider,
//     required bool isTablet,
//   }) {
//     final hasDocument = documentInfo?.url != null && documentInfo!.url.isNotEmpty;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: hasDocument
//               ? () => _showDocumentPreview(context, title, documentInfo!.url, isTablet)
//               : () => _navigateToUpload(context),
//           child: Padding(
//             padding: EdgeInsets.all(isTablet ? 20 : 16),
//             child: Row(
//               children: [
//                 Container(
//                   width: isTablet ? 64 : 56,
//                   height: isTablet ? 64 : 56,
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: color.withOpacity(0.2), width: 1),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: color,
//                     size: isTablet ? 28 : 24,
//                   ),
//                 ),
//                 SizedBox(width: isTablet ? 16 : 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               title,
//                               style: TextStyle(
//                                 fontSize: isTablet ? 18 : 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF1F2937),
//                               ),
//                             ),
//                           ),
//                           if (hasDocument)
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF34A853).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 'Uploaded',
//                                 style: TextStyle(
//                                   fontSize: isTablet ? 12 : 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color(0xFF34A853),
//                                 ),
//                               ),
//                             )
//                           else
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFF59E0B).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 'Pending',
//                                 style: TextStyle(
//                                   fontSize: isTablet ? 12 : 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color(0xFFF59E0B),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: isTablet ? 8 : 6),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: isTablet ? 14 : 12,
//                           color: const Color(0xFF6B7280),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       if (hasDocument) ...[
//                         SizedBox(height: isTablet ? 8 : 6),
//                         Text(
//                           'Uploaded on ${_formatDate(documentInfo!.uploadedAt)}',
//                           style: TextStyle(
//                             fontSize: isTablet ? 12 : 10,
//                             color: const Color(0xFF9CA3AF),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => KycVerificationScreen(
//                               userId: userId,
//                               isEdit: true,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(isTablet ? 12 : 8),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           Icons.edit_rounded,
//                           color: color,
//                           size: isTablet ? 20 : 18,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Icon(
//                       hasDocument ? Icons.visibility_rounded : Icons.add_circle_outline_rounded,
//                       color: color,
//                       size: isTablet ? 24 : 20,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context, bool isTablet) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.all(isTablet ? 40 : 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: isTablet ? 150 : 120,
//                 height: isTablet ? 150 : 120,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
//                   ),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Icon(
//                   Icons.folder_outlined,
//                   size: isTablet ? 70 : 60,
//                   color: const Color(0xFF0284C7),
//                 ),
//               ),
//               SizedBox(height: isTablet ? 32 : 24),
//               Text(
//                 'No Documents Found',
//                 style: TextStyle(
//                   fontSize: isTablet ? 24 : 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1F2937),
//                 ),
//               ),
//               SizedBox(height: isTablet ? 16 : 12),
//               Text(
//                 'Start by uploading your identity documents\nfor quick and secure verification',
//                 style: TextStyle(
//                   fontSize: isTablet ? 16 : 14,
//                   color: const Color(0xFF6B7280),
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: isTablet ? 40 : 32),
//               ElevatedButton.icon(
//                 onPressed: () => _navigateToUpload(context),
//                 icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
//                 label: const Text(
//                   'Upload Documents',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A73E8),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isTablet ? 32 : 24,
//                     vertical: isTablet ? 16 : 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionSection(
//     BuildContext context,
//     UploadedDocuments documents,
//     bool isTablet,
//   ) {
//     final hasAllDocuments = _hasAllDocuments(documents);

//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           if (!hasAllDocuments) ...[
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => _navigateToUpload(context),
//                 icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
//                 label: Text(
//                   _getUploadButtonText(documents),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF34A853),
//                   padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ),
//             SizedBox(height: isTablet ? 16 : 12),
//           ],
//           Row(
//             children: [
//               Icon(
//                 Icons.security_rounded,
//                 color: const Color(0xFF6B7280),
//                 size: isTablet ? 20 : 18,
//               ),
//               SizedBox(width: isTablet ? 8 : 6),
//               Expanded(
//                 child: Text(
//                   'Your documents are encrypted and stored securely',
//                   style: TextStyle(
//                     fontSize: isTablet ? 14 : 12,
//                     color: const Color(0xFF6B7280),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToUpload(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => KycVerificationScreen(userId: userId, isEdit: false),
//       ),
//     );
//   }

//   void _showDocumentPreview(
//     BuildContext context,
//     String title,
//     String imageUrl,
//     bool isTablet,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog.fullscreen(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           appBar: AppBar(
//             backgroundColor: Colors.black,
//             foregroundColor: Colors.white,
//             title: Text(title),
//             actions: [
//               IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.close_rounded),
//               ),
//             ],
//           ),
//           body: Center(
//             child: InteractiveViewer(
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 fit: BoxFit.contain,
//                 placeholder: (context, url) => const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),
//                 errorWidget: (context, url, error) => const Center(
//                   child: Icon(Icons.error, color: Colors.white, size: 48),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper methods remain the same
//   bool _hasDocuments(UploadedDocuments? documents) {
//     if (documents == null) return false;
//     bool hasAadhar = documents.aadharCard?.url != null && documents.aadharCard!.url.isNotEmpty;
//     bool hasLicense = documents.drivingLicense?.url != null && documents.drivingLicense!.url.isNotEmpty;
//     return hasAadhar || hasLicense;
//   }

//   bool _hasAllDocuments(UploadedDocuments documents) {
//     bool hasAadhar = documents.aadharCard?.url != null && documents.aadharCard!.url.isNotEmpty;
//     bool hasLicense = documents.drivingLicense?.url != null && documents.drivingLicense!.url.isNotEmpty;
//     return hasAadhar && hasLicense;
//   }

//   int _getCompletedDocumentsCount(UploadedDocuments documents) {
//     int count = 0;
//     if (documents.aadharCard?.url != null && documents.aadharCard!.url.isNotEmpty) count++;
//     if (documents.drivingLicense?.url != null && documents.drivingLicense!.url.isNotEmpty) count++;
//     return count;
//   }

//   String _getUploadButtonText(UploadedDocuments? documents) {
//     if (documents == null) return "Upload Documents";
//     bool hasAadhar = documents.aadharCard?.url != null && documents.aadharCard!.url.isNotEmpty;
//     bool hasLicense = documents.drivingLicense?.url != null && documents.drivingLicense!.url.isNotEmpty;

//     if (!hasAadhar && !hasLicense) return "Upload Documents";
//     if (hasAadhar && hasLicense) return "Update Documents";
//     return "Complete Upload";
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Icons.schedule_rounded;
//       case 'approved':
//         return Icons.check_circle_rounded;
//       case 'rejected':
//         return Icons.cancel_rounded;
//       default:
//         return Icons.help_outline_rounded;
//     }
//   }

//   String _formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
//   }
// }
















import 'package:nupura_cars/models/DocumentModel/document_model.dart';
import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
import 'package:nupura_cars/views/BookingScreen/kyc_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Documents extends StatefulWidget {
  const Documents({Key? key}) : super(key: key);

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  late String userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserIdAndFetchDocuments();
  }

  Future<void> _getUserIdAndFetchDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';

      if (userId.isNotEmpty) {
        await Provider.of<DocumentProvider>(
          context,
          listen: false,
        ).fetchDocuments(userId);
      } else {
        print('User ID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error getting user ID: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Document Vault'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, documentProvider, child) {
          if (documentProvider.isLoading || isLoading) {
            return _buildLoadingState(theme, colorScheme, isTablet);
          }

          if (documentProvider.errorMessage != null) {
            return _buildErrorState(
              context,
              documentProvider,
              theme,
              colorScheme,
              isTablet,
            );
          }

          final documents = documentProvider.uploadedDocuments;
          return _buildDocumentsContent(
            context,
            documents,
            documentProvider,
            theme,
            colorScheme,
            isTablet,
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          SizedBox(height: isTablet ? 24 : 16),
          Text(
            'Fetching your documents...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    DocumentProvider provider,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: isTablet ? 80 : 60,
              color: colorScheme.error,
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'Connection Issue',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              provider.errorMessage ?? 'Unable to load documents',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 24 : 16),
            ElevatedButton(
              onPressed: _getUserIdAndFetchDocuments,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsContent(
    BuildContext context,
    UploadedDocuments? documents,
    DocumentProvider provider,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    if (!_hasDocuments(documents)) {
      return _buildEmptyState(context, theme, colorScheme, isTablet);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        children: [
          _buildStatusCard(context, documents!, theme, colorScheme, isTablet),
          SizedBox(height: isTablet ? 24 : 16),
          _buildDocumentGrid(
            context,
            documents,
            provider,
            theme,
            colorScheme,
            isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 16),
          _buildActionSection(context, documents, theme, colorScheme, isTablet),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    UploadedDocuments documents,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    final completedDocs = _getCompletedDocumentsCount(documents);
    final totalDocs = 2;
    final progress = completedDocs / totalDocs;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: colorScheme.primary,
                  size: isTablet ? 32 : 28,
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verification Progress',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$completedDocs of $totalDocs documents verified',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceVariant,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentGrid(
    BuildContext context,
    UploadedDocuments documents,
    DocumentProvider provider,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Documents',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        _buildDocumentCard(
          context,
          title: 'Identity Card',
          subtitle: 'Government issued Aadhar',
          icon: Icons.credit_card_rounded,
          documentInfo: documents.aadharCard,
          provider: provider,
          theme: theme,
          colorScheme: colorScheme,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 8),
        _buildDocumentCard(
          context,
          title: 'Driving License',
          subtitle: 'Valid driving permit',
          icon: Icons.directions_car_rounded,
          documentInfo: documents.drivingLicense,
          provider: provider,
          theme: theme,
          colorScheme: colorScheme,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildDocumentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required DocumentInfo? documentInfo,
    required DocumentProvider provider,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isTablet,
  }) {
    final hasDocument = documentInfo?.url != null && documentInfo!.url.isNotEmpty;

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: isTablet ? 32 : 28,
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: hasDocument
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          hasDocument ? 'Uploaded' : 'Pending',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: hasDocument ? colorScheme.primary : colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  if (hasDocument) ...[
                    SizedBox(height: 4),
                    Text(
                      'Uploaded on ${_formatDate(documentInfo!.uploadedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KycVerificationScreen(
                          userId: userId,
                          isEdit: true,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: hasDocument
                      ? () => _showDocumentPreview(
                            context,
                            title,
                            documentInfo!.url,
                            theme,
                            colorScheme,
                            isTablet,
                          )
                      : () => _navigateToUpload(context),
                  icon: Icon(
                    hasDocument ? Icons.visibility_rounded : Icons.add_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_rounded,
              size: isTablet ? 80 : 60,
              color: colorScheme.primary.withOpacity(0.5),
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'No Documents Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              'Upload your identity documents for verification',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 24 : 16),
            ElevatedButton(
              onPressed: () => _navigateToUpload(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Upload Documents'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(
    BuildContext context,
    UploadedDocuments documents,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    final hasAllDocuments = _hasAllDocuments(documents);

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          children: [
            if (!hasAllDocuments) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToUpload(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text(_getUploadButtonText(documents)),
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
            ],
            Row(
              children: [
                Icon(
                  Icons.security_rounded,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your documents are encrypted and stored securely',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KycVerificationScreen(
          userId: userId,
          isEdit: false,
        ),
      ),
    );
  }

  void _showDocumentPreview(
    BuildContext context,
    String title,
    String imageUrl,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.error,
                    color: colorScheme.error,
                    size: 48,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  bool _hasDocuments(UploadedDocuments? documents) {
    if (documents == null) return false;
    bool hasAadhar = documents.aadharCard?.url != null &&
        documents.aadharCard!.url.isNotEmpty;
    bool hasLicense = documents.drivingLicense?.url != null &&
        documents.drivingLicense!.url.isNotEmpty;
    return hasAadhar || hasLicense;
  }

  bool _hasAllDocuments(UploadedDocuments documents) {
    bool hasAadhar = documents.aadharCard?.url != null &&
        documents.aadharCard!.url.isNotEmpty;
    bool hasLicense = documents.drivingLicense?.url != null &&
        documents.drivingLicense!.url.isNotEmpty;
    return hasAadhar && hasLicense;
  }

  int _getCompletedDocumentsCount(UploadedDocuments documents) {
    int count = 0;
    if (documents.aadharCard?.url != null &&
        documents.aadharCard!.url.isNotEmpty) count++;
    if (documents.drivingLicense?.url != null &&
        documents.drivingLicense!.url.isNotEmpty) count++;
    return count;
  }

  String _getUploadButtonText(UploadedDocuments? documents) {
    if (documents == null) return "Upload Documents";
    bool hasAadhar = documents.aadharCard?.url != null &&
        documents.aadharCard!.url.isNotEmpty;
    bool hasLicense = documents.drivingLicense?.url != null &&
        documents.drivingLicense!.url.isNotEmpty;

    if (!hasAadhar && !hasLicense) return "Upload Documents";
    if (hasAadhar && hasLicense) return "Update Documents";
    return "Complete Upload";
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}