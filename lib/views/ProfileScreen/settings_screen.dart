
// import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
// import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
// import 'package:nupura_cars/providers/ThemeProvider/theme_provider.dart';
// import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen>
//     with TickerProviderStateMixin {
//   bool _notificationsEnabled = true;
//   bool _locationServices = true;
//   bool _biometricAuth = false;
//   String _selectedLanguage = 'English';
//   String _selectedCurrency = 'INR (₹)';
//   late String userId;
  
//   late AnimationController _animationController;
//   late AnimationController _cardController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
    
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _cardController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
    
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     ));
    
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _cardController,
//       curve: Curves.elasticOut,
//     ));
    
//     _animationController.forward();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _cardController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _cardController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       userId = prefs.getString('userId') ?? '';
//     } catch (e) {
//       debugPrint('Error getting user ID: $e');
//     }
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
//             expandedHeight: isTablet ? 200 : 160,
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
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(isTablet ? 12 : 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.3),
//                                 ),
//                               ),
//                               child: Icon(
//                                 Icons.settings_rounded,
//                                 color: Colors.white,
//                                 size: isTablet ? 28 : 24,
//                               ),
//                             ),
//                             SizedBox(width: isTablet ? 16 : 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Settings & Support',
//                                     style: TextStyle(
//                                       fontSize: isTablet ? 28 : 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                   SizedBox(height: isTablet ? 6 : 4),
//                                   Text(
//                                     'Manage your preferences',
//                                     style: TextStyle(
//                                       fontSize: isTablet ? 16 : 14,
//                                       color: Colors.white.withOpacity(0.9),
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

//           // Content
//           SliverPadding(
//             padding: EdgeInsets.all(isTablet ? 24 : 16),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: isTablet ? 24 : 20),

//                           // Support & Legal Section
//                           _buildModernSection(
//                             title: 'Support & Information',
//                             icon: Icons.help_center_rounded,
//                             children: [
//                               _buildModernTile(
//                                 icon: Icons.privacy_tip_rounded,
//                                 title: 'Privacy Policy',
//                                 subtitle: 'How we protect your data',
//                                 onTap: () => _launchPrivacyPolicy(),
//                                 color: const Color(0xFF1A73E8),
//                                 isTablet: isTablet,
//                               ),
//                               _buildModernTile(
//                                 icon: Icons.description_rounded,
//                                 title: 'Terms of Service',
//                                 subtitle: 'App terms and conditions',
//                                 onTap: () => _launchTermsOfService(),
//                                 color: const Color(0xFF34A853),
//                                 isTablet: isTablet,
//                               ),
//                               _buildModernTile(
//                                 icon: Icons.language_rounded,
//                                 title: 'Cancellation Policy',
//                                 subtitle: 'Booking cancellation policy',
//                                 onTap: () => _launchCancellation(),
//                                 color: const Color(0xFF4285F4),
//                                 isTablet: isTablet,
//                               ),
//                             ],
//                             isTablet: isTablet,
//                           ),

//                           SizedBox(height: isTablet ? 32 : 24),

//                           // Account Actions Section
//                           // _buildModernSection(
//                           //   title: 'Account Management',
//                           //   icon: Icons.manage_accounts_rounded,
//                           //   children: [
//                           //     _buildModernTile(
//                           //       icon: Icons.delete_forever_rounded,
//                           //       title: 'Delete Account',
//                           //       subtitle: 'Permanently remove your account',
//                           //       onTap: () => _showDeleteAccountDialog(),
//                           //       color: const Color(0xFFDC2626),
//                           //       isDestructive: true,
//                           //       isTablet: isTablet,
//                           //     ),
//                           //   ],
//                           //   isDangerous: true,
//                           //   isTablet: isTablet,
//                           // ),

//                           SizedBox(height: isTablet ? 40 : 32),

//                           // App Info Footer
//                           // _buildAppInfoFooter(isTablet),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernSection({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//     bool isDangerous = false,
//     required bool isTablet,
//   }) {
//     final sectionColor = isDangerous ? const Color(0xFFDC2626) : const Color(0xFF1A73E8);
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: isTablet ? 8 : 4, bottom: isTablet ? 16 : 12),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isTablet ? 12 : 8),
//                 decoration: BoxDecoration(
//                   color: sectionColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: sectionColor.withOpacity(0.2)),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: isTablet ? 24 : 20,
//                   color: sectionColor,
//                 ),
//               ),
//               SizedBox(width: isTablet ? 16 : 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: isTablet ? 22 : 18,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF1F2937),
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
//             boxShadow: [
//               BoxShadow(
//                 color: sectionColor.withOpacity(0.08),
//                 blurRadius: 25,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//             border: Border.all(
//               color: isDangerous 
//                   ? const Color(0xFFDC2626).withOpacity(0.2)
//                   : const Color(0xFF1A73E8).withOpacity(0.1),
//               width: 1,
//             ),
//           ),
//           child: Column(
//             children: children
//                 .expand((child) => [
//                       child,
//                       if (child != children.last)
//                         Container(
//                           height: 1,
//                           margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.transparent,
//                                 const Color(0xFFE5E7EB),
//                                 Colors.transparent,
//                               ],
//                             ),
//                           ),
//                         ),
//                     ])
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildModernTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required Color color,
//     bool isDestructive = false,
//     required bool isTablet,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
//         child: Container(
//           padding: EdgeInsets.all(isTablet ? 24 : 20),
//           child: Row(
//             children: [
//               Container(
//                 width: isTablet ? 56 : 52,
//                 height: isTablet ? 56 : 52,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: color.withOpacity(0.2), width: 1),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: isTablet ? 28 : 24,
//                 ),
//               ),
//               SizedBox(width: isTablet ? 20 : 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: isTablet ? 18 : 16,
//                         fontWeight: FontWeight.bold,
//                         color: isDestructive ? color : const Color(0xFF1F2937),
//                         letterSpacing: 0.2,
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 6 : 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: isTablet ? 14 : 13,
//                         color: const Color(0xFF6B7280),
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(isTablet ? 12 : 8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: color,
//                   size: isTablet ? 18 : 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppInfoFooter(bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
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
//                 padding: EdgeInsets.all(isTablet ? 16 : 12),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.directions_car_rounded,
//                   color: Colors.white,
//                   size: isTablet ? 32 : 28,
//                 ),
//               ),
//               SizedBox(width: isTablet ? 20 : 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Drive a App',
//                       style: TextStyle(
//                         fontSize: isTablet ? 20 : 18,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1F2937),
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 6 : 4),
//                     Text(
//                       'Version 1.0.0',
//                       style: TextStyle(
//                         fontSize: isTablet ? 16 : 14,
//                         color: const Color(0xFF6B7280),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: isTablet ? 16 : 12),
//           Text(
//             'Your trusted partner for convenient and reliable car rental services. Drive safely!',
//             style: TextStyle(
//               fontSize: isTablet ? 14 : 12,
//               color: const Color(0xFF6B7280),
//               height: 1.5,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // URL Launch Methods
//   Future<void> _launchPrivacyPolicy() async {
//     const url = 'https://self-drive-cars.onrender.com/privacy-and-policy';
//     await _launchUrl(url);
//   }

//   Future<void> _launchTermsOfService() async {
//     const url = 'https://self-drive-cars.onrender.com/terms-and-conditions';
//     await _launchUrl(url);
//   }

//     Future<void> _launchCancellation() async {
//     const url = 'https://self-drive-cars.onrender.com/cancellation-refund-policy';
//     await _launchUrl(url);
//   }


//   Future<void> _launchUrl(String url) async {
//     try {
//       final Uri uri = Uri.parse(url);
//       print(uri);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(
//           uri,
//           mode: LaunchMode.externalApplication,
//         );
//       } else {
//         print('Could not launch $url');
//         _showErrorSnackBar('Could not launch $url');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error launching URL: $e');
//     }
//   }

//   void _showErrorSnackBar(String message) {
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
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFFDC2626),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   // API call to delete user account
//   Future<bool> _deleteUserAccount() async {
//     try {
//       if (userId.isEmpty) {
//         throw Exception('User ID not found');
//       }

//       final response = await http.delete(
//         Uri.parse('http://31.97.206.144:4072/api/users/delete-user/$userId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         debugPrint('Delete account response: $responseData');
//         return true;
//       } else {
//         debugPrint('Delete account failed with status: ${response.statusCode}');
//         debugPrint('Response body: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       debugPrint('Error deleting account: $e');
//       return false;
//     }
//   }

//   void _showDeleteAccountDialog() {
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
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFDC2626).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.warning_amber_rounded,
//                   color: Color(0xFFDC2626),
//                   size: 40,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Delete Account?',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFDC2626),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'This action cannot be undone. All your data will be permanently deleted including:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF6B7280),
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFDC2626).withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: const Color(0xFFDC2626).withOpacity(0.2),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     '• Personal information & profile',
//                     '• Booking history & preferences',
//                     '• Stored payment methods',
//                     '• Account settings & data',
//                   ]
//                       .map((item) => Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 3),
//                             child: Text(
//                               item,
//                               style: const TextStyle(
//                                 color: Color(0xFFDC2626),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         side: const BorderSide(color: Color(0xFF6B7280)),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           color: Color(0xFF6B7280),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _deleteAccount();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFDC2626),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         'Delete Account',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _deleteAccount() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
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
//                 'Deleting Account',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Please wait while we process your request...',
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

//     try {
//       bool isDeleted = await _deleteUserAccount();
//       Navigator.of(context).pop(); // Close loading dialog

//       if (isDeleted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_rounded,
//                     color: Color(0xFF16A34A),
//                     size: 16,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(child: Text('Account deleted successfully')),
//               ],
//             ),
//             backgroundColor: const Color(0xFF16A34A),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//         _logout();
//       } else {
//         _showErrorSnackBar('Failed to delete account. Please try again.');
//       }
//     } catch (e) {
//       Navigator.of(context).pop(); // Close loading dialog
//       _showErrorSnackBar('Error: ${e.toString()}');
//     }
//   }

//   void _logout() {
//     Provider.of<AuthProvider>(context, listen: false).logout();
//     Provider.of<DateTimeProvider>(context, listen: false).resetAll();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (ctx) => const LoginScreen()),
//       (route) => false,
//     );
//   }
// }






















import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/providers/ThemeProvider/theme_provider.dart';
import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
    } catch (e) {
      debugPrint('Error getting user ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings & Support'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support & Legal Section
            _buildSection(
              theme: theme,
              colorScheme: colorScheme,
              title: 'Support & Information',
              icon: Icons.help_center_rounded,
              children: [
                _buildSettingTile(
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'How we protect your data',
                  onTap: () => _launchPrivacyPolicy(),
                  isTablet: isTablet,
                ),
                _buildSettingTile(
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.description_rounded,
                  title: 'Terms of Service',
                  subtitle: 'App terms and conditions',
                  onTap: () => _launchTermsOfService(),
                  isTablet: isTablet,
                ),
                _buildSettingTile(
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.language_rounded,
                  title: 'Cancellation Policy',
                  subtitle: 'Booking cancellation policy',
                  onTap: () => _launchCancellation(),
                  isTablet: isTablet,
                ),
              ],
              isTablet: isTablet,
            ),

            SizedBox(height: isTablet ? 32 : 24),

            // Account Actions Section
            _buildSection(
              theme: theme,
              colorScheme: colorScheme,
              title: 'Account Management',
              icon: Icons.manage_accounts_rounded,
              children: [
                _buildSettingTile(
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete Account',
                  subtitle: 'Permanently remove your account',
                  onTap: () => _showDeleteAccountDialog(),
                  isDestructive: true,
                  isTablet: isTablet,
                ),
              ],
              isTablet: isTablet,
            ),

            SizedBox(height: isTablet ? 32 : 24),

            // App Info Footer
            _buildAppInfoFooter(theme, colorScheme, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: isTablet ? 8 : 4, bottom: isTablet ? 16 : 12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                ),
                child: Icon(
                  icon,
                  size: isTablet ? 24 : 20,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: children
                .expand((child) => [
                      child,
                      if (child != children.last)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.outline.withOpacity(0.1),
                          indent: isTablet ? 24 : 16,
                          endIndent: isTablet ? 24 : 16,
                        ),
                    ])
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
    required bool isTablet,
  }) {
    final tileColor = isDestructive ? colorScheme.error : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Row(
            children: [
              Container(
                width: isTablet ? 48 : 44,
                height: isTablet ? 48 : 44,
                decoration: BoxDecoration(
                  color: tileColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: tileColor,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? tileColor : colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.onSurface.withOpacity(0.5),
                size: isTablet ? 18 : 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoFooter(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
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
                  Icons.directions_car_rounded,
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
                      'Drive a App',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Your trusted partner for convenient and reliable car rental services. Drive safely!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // URL Launch Methods
  Future<void> _launchPrivacyPolicy() async {
    const url = 'https://nupura-self-drive-cars-policies.onrender.com/privacy-and-policy';
    await _launchUrl(url);
  }

  Future<void> _launchTermsOfService() async {
    const url = 'https://nupura-self-drive-cars-policies.onrender.com/terms-and-conditions';
    await _launchUrl(url);
  }

  Future<void> _launchCancellation() async {
    const url = 'https://nupura-self-drive-cars-policies.onrender.com/cancellation-refund-policy';
    await _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackBar('Could not launch $url');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching URL: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.onError,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // API call to delete user account
  Future<bool> _deleteUserAccount() async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID not found');
      }

      final response = await http.delete(
        Uri.parse('http://31.97.206.144:4072/api/users/delete-user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint('Delete account response: $responseData');
        return true;
      } else {
        debugPrint('Delete account failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');
      return false;
    }
  }

  void _showDeleteAccountDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Account?',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted including:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '• Personal information & profile',
                  '• Booking history & preferences',
                  '• Account settings & data',
                ]
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text(
              'Delete Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() async {
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
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Deleting Account',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we process your request...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    try {
      bool isDeleted = await _deleteUserAccount();
      Navigator.of(context).pop(); // Close loading dialog

      if (isDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Account deleted successfully')),
              ],
            ),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
        _logout();
      } else {
        _showErrorSnackBar('Failed to delete account. Please try again.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Provider.of<DateTimeProvider>(context, listen: false).resetAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
      (route) => false,
    );
  }
}