
// import 'dart:io';
// import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<EditProfile> with TickerProviderStateMixin {
//   String name = '';
//   String email = '';
//   String mobile = '';
  
//   late AnimationController _animationController;
//   late AnimationController _profileImageController;
//   late AnimationController _cardController;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _profileScaleAnimation;
//   late Animation<Offset> _cardSlideAnimation;
  
//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize animations
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
    
//     _profileImageController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _cardController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
    
//     _slideAnimation = Tween<double>(
//       begin: 50.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     ));
    
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
    
//     _profileScaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _profileImageController,
//       curve: Curves.elasticOut,
//     ));
    
//     _cardSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _cardController,
//       curve: Curves.easeOutCubic,
//     ));
    
//     // Start animations with delays
//     _animationController.forward();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _profileImageController.forward();
//     });
//     Future.delayed(const Duration(milliseconds: 600), () {
//       _cardController.forward();
//     });
    
//     // Refresh profile image when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<AuthProvider>(context, listen: false).refreshProfileImage();
//     });
//     _loadUserData();
//   }
  
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _profileImageController.dispose();
//     _cardController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     final userName = await StorageHelper.getUserName();
//     final userEmail = await StorageHelper.getEmail();
//     final userMobile = await StorageHelper.getMobile();

//     setState(() {
//       name = userName ?? '';
//       email = userEmail ?? '';
//       mobile = userMobile ?? '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isTablet = screenSize.width > 600;
    
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         slivers: [
//           // Modern Gradient App Bar
//           SliverAppBar(
//             expandedHeight: isTablet ? 220 : 100,
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
//                     padding: EdgeInsets.all(isTablet ? 24 : 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'My Profile',
//                           style: TextStyle(
//                             fontSize: isTablet ? 28 : 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 0.5,
//                           ),
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
          
//           // Profile Content
//           SliverToBoxAdapter(
//             child: AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(0, _slideAnimation.value),
//                   child: Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: Padding(
//                       padding: EdgeInsets.all(isTablet ? 24 : 20),
//                       child: Column(
//                         children: [
//                           SizedBox(height: isTablet ? 24 : 20),
                          
//                           // Profile Image Section
//                           _buildProfileImageSection(context, isTablet),
                          
//                           SizedBox(height: isTablet ? 48 : 40),
                          
//                           // Profile Information Cards
//                           SlideTransition(
//                             position: _cardSlideAnimation,
//                             child: Column(
//                               children: [
//                                 _buildInfoCard(
//                                   context,
//                                   icon: Icons.person_rounded,
//                                   label: "Full Name",
//                                   value: name,
//                                   color: const Color(0xFF1A73E8),
//                                   isTablet: isTablet,
//                                 ),
                                
//                                 SizedBox(height: isTablet ? 20 : 16),
                                
//                                 _buildInfoCard(
//                                   context,
//                                   icon: Icons.phone_rounded,
//                                   label: "Mobile Number",
//                                   value: mobile,
//                                   color: const Color(0xFF34A853),
//                                   isTablet: isTablet,
//                                 ),
                                
//                                 SizedBox(height: isTablet ? 20 : 16),
                                
//                                 _buildInfoCard(
//                                   context,
//                                   icon: Icons.email_rounded,
//                                   label: "Email Address",
//                                   value: email,
//                                   color: const Color(0xFFFF6B35),
//                                   isTablet: isTablet,
//                                 ),
//                               ],
//                             ),
//                           ),
                          
//                           SizedBox(height: isTablet ? 32 : 24),
                          
//                           // Security Notice
//                           _buildSecurityNotice(isTablet),
                          
//                           SizedBox(height: isTablet ? 40 : 32),
//                         ],
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

//   Widget _buildProfileImageSection(BuildContext context, bool isTablet) {
//     return Center(
//       child: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           return AnimatedBuilder(
//             animation: _profileImageController,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _profileScaleAnimation.value,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFF1A73E8),
//                         Color(0xFF4285F4),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF1A73E8).withOpacity(0.3),
//                         blurRadius: 30,
//                         spreadRadius: 10,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(6),
//                   child: Stack(
//                     children: [
//                       // Profile Image
//                       _buildProfileImage(context, authProvider, isTablet),
                      
//                       // Edit Button
//                       Positioned(
//                         bottom: isTablet ? 12 : 8,
//                         right: isTablet ? 12 : 8,
//                         child: GestureDetector(
//                           onTap: () => _updateProfileImage(context, authProvider),
//                           child: Container(
//                             width: isTablet ? 48 : 44,
//                             height: isTablet ? 48 : 44,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF34A853), Color(0xFF0F9D58)],
//                               ),
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFF34A853).withOpacity(0.4),
//                                   blurRadius: 15,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.camera_alt_rounded,
//                               color: Colors.white,
//                               size: isTablet ? 24 : 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProfileImage(BuildContext context, AuthProvider authProvider, bool isTablet) {
//     return FutureBuilder<String?>(
//       future: StorageHelper.getProfileImage(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             width: isTablet ? 140 : 120,
//             height: isTablet ? 140 : 120,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//             ),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF1A73E8),
//                 strokeWidth: 3,
//               ),
//             ),
//           );
//         }
        
//         final profileImageFromAuth = authProvider.user?.profileImage;
//         String imageUrl;
        
//         if (profileImageFromAuth != null) {
//           imageUrl = profileImageFromAuth;
//         } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
//           imageUrl = snapshot.data!;
//         } else {
//           imageUrl = 'https://avatar.iran.liara.run/public/boy?username=Ash';
//         }
        
//         if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
//           imageUrl = 'http://31.97.206.144:4072/$imageUrl';
//         }
        
//         final cacheBuster = '?t=${DateTime.now().millisecondsSinceEpoch}';
        
//         return Container(
//           width: isTablet ? 140 : 120,
//           height: isTablet ? 140 : 120,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: ClipOval(
//             child: Consumer<AuthProvider>(
//               builder: (context, authProvider, _) {
//                 final profileImageFromAuth = authProvider.user?.profileImage;
//                 String imageUrl;

//                 if (profileImageFromAuth != null) {
//                   imageUrl = profileImageFromAuth;
//                 } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
//                   imageUrl = snapshot.data!;
//                 } else {
//                   imageUrl = 'https://avatar.iran.liara.run/public/boy?username=Ash';
//                 }

//                 if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
//                   imageUrl = 'http://31.97.206.144:4072/$imageUrl';
//                 }

//                 final cacheBuster = '?t=${DateTime.now().millisecondsSinceEpoch}';

//                 return Image.network(
//                   '$imageUrl$cacheBuster',
//                   fit: BoxFit.fill,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             Color(0xFF1A73E8),
//                             Color(0xFF4285F4),
//                           ],
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.person_rounded,
//                         size: isTablet ? 70 : 60,
//                         color: Colors.white,
//                       ),
//                     );
//                   },
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                       ),
//                       child: const Center(
//                         child: CircularProgressIndicator(
//                           color: Color(0xFF1A73E8),
//                           strokeWidth: 3,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//     required bool isTablet,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.08),
//             blurRadius: 25,
//             offset: const Offset(0, 8),
//           ),
//         ],
//         border: Border.all(
//           color: color.withOpacity(0.1),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: isTablet ? 56 : 52,
//             height: isTablet ? 56 : 52,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: color.withOpacity(0.2), width: 1),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: isTablet ? 28 : 24,
//             ),
//           ),
//           SizedBox(width: isTablet ? 20 : 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: isTablet ? 16 : 14,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF6B7280),
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//                 SizedBox(height: isTablet ? 6 : 4),
//                 Text(
//                   value.isEmpty ? 'Not provided' : value,
//                   style: TextStyle(
//                     fontSize: isTablet ? 18 : 16,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF1F2937),
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(isTablet ? 10 : 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF6B7280).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               Icons.lock_rounded,
//               color: const Color(0xFF6B7280),
//               size: isTablet ? 20 : 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSecurityNotice(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 20 : 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF1A73E8).withOpacity(0.05),
//             const Color(0xFF4285F4).withOpacity(0.02),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFF1A73E8).withOpacity(0.1),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isTablet ? 12 : 10),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1A73E8).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.security_rounded,
//                   color: const Color(0xFF1A73E8),
//                   size: isTablet ? 24 : 20,
//                 ),
//               ),
//               SizedBox(width: isTablet ? 16 : 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Profile Security',
//                       style: TextStyle(
//                         fontSize: isTablet ? 18 : 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1F2937),
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 6 : 4),
//                     Text(
//                       'Your information is protected',
//                       style: TextStyle(
//                         fontSize: isTablet ? 14 : 12,
//                         color: const Color(0xFF6B7280),
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // SizedBox(height: isTablet ? 16 : 12),
//           // Row(
//           //   children: [
//           //     Icon(
//           //       Icons.verified_rounded,
//           //       color: const Color(0xFF34A853),
//           //       size: isTablet ? 18 : 16,
//           //     ),
//           //     SizedBox(width: isTablet ? 8 : 6),
//           //     Expanded(
//           //       child: Text(
//           //         'Profile data is verified and cannot be edited directly for security',
//           //         style: TextStyle(
//           //           fontSize: isTablet ? 14 : 12,
//           //           color: const Color(0xFF34A853),
//           //           fontWeight: FontWeight.w500,
//           //         ),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }

//   Future<void> _updateProfileImage(BuildContext context, AuthProvider authProvider) async {
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
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.photo_camera_rounded,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Update Profile Photo',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               Text(
//                                 'Choose your profile picture',
//                                 style: TextStyle(
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
//                     _buildImageOptionTile(
//                       icon: Icons.camera_alt_rounded,
//                       title: 'Take Photo',
//                       subtitle: 'Capture with camera',
//                       onTap: () {
//                         Navigator.pop(context);
//                         _pickImage(ImageSource.camera, authProvider);
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     _buildImageOptionTile(
//                       icon: Icons.photo_library_rounded,
//                       title: 'Choose from Gallery',
//                       subtitle: 'Select from device storage',
//                       onTap: () {
//                         Navigator.pop(context);
//                         _pickImage(ImageSource.gallery, authProvider);
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

//   Widget _buildImageOptionTile({
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

//   Future<void> _pickImage(ImageSource source, AuthProvider authProvider) async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: source);

//     if (image != null) {
//       final userId = await StorageHelper.getUserId();
//       if (userId != null) {
//         _showLoadingDialog(context);

//         try {
//           // Clear image cache
//           imageCache.clear();
//           imageCache.clearLiveImages();

//           await authProvider.updateProfileImage(
//             context: context,
//             image: image,
//             id: userId,
//             authProvider: authProvider,
//           );

//           if (mounted) {
//             Navigator.of(context).pop(); // Close loading dialog
//             _showSuccessMessage(context);
//           }
//         } catch (e) {
//           if (mounted) {
//             Navigator.of(context).pop(); // Close loading dialog
//             _showErrorMessage(context, e.toString());
//           }
//         }
//       }
//     }
//   }

//   void _showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 3,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Updating Profile',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Please wait while we update your profile image...',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF6B7280),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showSuccessMessage(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_rounded,
//                 color: Color(0xFF16A34A),
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'Profile image updated successfully!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color(0xFF16A34A),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showErrorMessage(BuildContext context, String error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline_rounded,
//                 color: Color(0xFFDC2626),
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'Error updating image: $error',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color(0xFFDC2626),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }


















import 'dart:io';
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<EditProfile> with TickerProviderStateMixin {
  String name = '';
  String email = '';
  String mobile = '';
  
  late AnimationController _animationController;
  late AnimationController _profileImageController;
  late AnimationController _cardController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<Offset> _cardSlideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _profileImageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _profileScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profileImageController,
      curve: Curves.elasticOut,
    ));
    
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations with delays
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _profileImageController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _cardController.forward();
    });
    
    // Refresh profile image when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).refreshProfileImage();
    });
    _loadUserData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _profileImageController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userName = await StorageHelper.getUserName();
    final userEmail = await StorageHelper.getEmail();
    final userMobile = await StorageHelper.getMobile();

    setState(() {
      name = userName ?? '';
      email = userEmail ?? '';
      mobile = userMobile ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Modern Gradient App Bar
          SliverAppBar(
            expandedHeight: isTablet ? 220 : 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                      colorScheme.secondary,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'My Profile',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage your profile information',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          
          // Profile Content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 24 : 20),
                      child: Column(
                        children: [
                          SizedBox(height: isTablet ? 24 : 20),
                          
                          // Profile Image Section
                          _buildProfileImageSection(context, theme, colorScheme, isTablet),
                          
                          SizedBox(height: isTablet ? 48 : 40),
                          
                          // Profile Information Cards
                          SlideTransition(
                            position: _cardSlideAnimation,
                            child: Column(
                              children: [
                                _buildInfoCard(
                                  context,
                                  theme,
                                  colorScheme,
                                  icon: Icons.person_rounded,
                                  label: "Full Name",
                                  value: name,
                                  isTablet: isTablet,
                                ),
                                
                                SizedBox(height: isTablet ? 20 : 16),
                                
                                _buildInfoCard(
                                  context,
                                  theme,
                                  colorScheme,
                                  icon: Icons.phone_rounded,
                                  label: "Mobile Number",
                                  value: mobile,
                                  isTablet: isTablet,
                                ),
                                
                                SizedBox(height: isTablet ? 20 : 16),
                                
                                _buildInfoCard(
                                  context,
                                  theme,
                                  colorScheme,
                                  icon: Icons.email_rounded,
                                  label: "Email Address",
                                  value: email,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: isTablet ? 32 : 24),
                          
                          // Security Notice
                          _buildSecurityNotice(theme, colorScheme, isTablet),
                          
                          SizedBox(height: isTablet ? 40 : 32),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context, ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Center(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return AnimatedBuilder(
            animation: _profileImageController,
            builder: (context, child) {
              return Transform.scale(
                scale: _profileScaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primaryContainer,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Stack(
                    children: [
                      // Profile Image
                      _buildProfileImage(context, authProvider, theme, colorScheme, isTablet),
                      
                      // Edit Button
                      Positioned(
                        bottom: isTablet ? 12 : 8,
                        right: isTablet ? 12 : 8,
                        child: GestureDetector(
                          onTap: () => _updateProfileImage(context, authProvider, theme, colorScheme),
                          child: Container(
                            width: isTablet ? 48 : 44,
                            height: isTablet ? 48 : 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.secondary,
                                  colorScheme.primary,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.secondary.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: colorScheme.onPrimary,
                              size: isTablet ? 24 : 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, AuthProvider authProvider, ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return FutureBuilder<String?>(
      future: StorageHelper.getProfileImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: isTablet ? 140 : 120,
            height: isTablet ? 140 : 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surface,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3,
              ),
            ),
          );
        }
        
        final profileImageFromAuth = authProvider.user?.profileImage;
        String imageUrl;
        
        if (profileImageFromAuth != null) {
          imageUrl = profileImageFromAuth;
        } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          imageUrl = snapshot.data!;
        } else {
          imageUrl = 'https://avatar.iran.liara.run/public/boy?username=${name.isNotEmpty ? name : 'User'}';
        }
        
        if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
          imageUrl = 'http://31.97.206.144:4072/$imageUrl';
        }
        
        return Container(
          width: isTablet ? 140 : 120,
          height: isTablet ? 140 : 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final profileImageFromAuth = authProvider.user?.profileImage;
                String imageUrl;

                if (profileImageFromAuth != null) {
                  imageUrl = profileImageFromAuth;
                } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                  imageUrl = snapshot.data!;
                } else {
                  imageUrl = 'https://avatar.iran.liara.run/public/boy?username=${name.isNotEmpty ? name : 'User'}';
                }

                if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                  imageUrl = 'http://31.97.206.144:4072/$imageUrl';
                }

                final cacheBuster = '?t=${DateTime.now().millisecondsSinceEpoch}';

                return Image.network(
                  '$imageUrl$cacheBuster',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primaryContainer,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: isTablet ? 70 : 60,
                        color: colorScheme.onPrimary,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.surface,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme, {
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 56 : 52,
            height: isTablet ? 56 : 52,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 1),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: isTablet ? 28 : 24,
            ),
          ),
          SizedBox(width: isTablet ? 20 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  value.isEmpty ? 'Not provided' : value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(isTablet ? 10 : 8),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.lock_rounded,
              color: colorScheme.onSurface.withOpacity(0.6),
              size: isTablet ? 20 : 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.05),
            colorScheme.primaryContainer.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.security_rounded,
                  color: colorScheme.primary,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Security',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Text(
                      'Your information is protected and secure',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfileImage(BuildContext context, AuthProvider authProvider, ThemeData theme, ColorScheme colorScheme) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primaryContainer,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.photo_camera_rounded,
                            color: colorScheme.onPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Profile Photo',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Choose your profile picture',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildImageOptionTile(
                      theme,
                      colorScheme,
                      icon: Icons.camera_alt_rounded,
                      title: 'Take Photo',
                      subtitle: 'Capture with camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera, authProvider, theme, colorScheme);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildImageOptionTile(
                      theme,
                      colorScheme,
                      icon: Icons.photo_library_rounded,
                      title: 'Choose from Gallery',
                      subtitle: 'Select from device storage',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery, authProvider, theme, colorScheme);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOptionTile(
    ThemeData theme,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onSurface.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, AuthProvider authProvider, ThemeData theme, ColorScheme colorScheme) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      final userId = await StorageHelper.getUserId();
      if (userId != null) {
        _showLoadingDialog(context, theme, colorScheme);

        try {
          // Clear image cache
          imageCache.clear();
          imageCache.clearLiveImages();

          await authProvider.updateProfileImage(
            context: context,
            image: image,
            id: userId,
            authProvider: authProvider,
          );

          if (mounted) {
            Navigator.of(context).pop(); // Close loading dialog
            _showSuccessMessage(context, theme, colorScheme);
          }
        } catch (e) {
          if (mounted) {
            Navigator.of(context).pop(); // Close loading dialog
            _showErrorMessage(context, e.toString(), theme, colorScheme);
          }
        }
      }
    }
  }

  void _showLoadingDialog(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.cardColor,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Updating Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we update your profile image...',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: colorScheme.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Profile image updated successfully!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String error, ThemeData theme, ColorScheme colorScheme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.onError,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Error updating image: $error',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}