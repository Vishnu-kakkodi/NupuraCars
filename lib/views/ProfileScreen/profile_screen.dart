
// import 'dart:convert';

// import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
// import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
// import 'package:nupura_cars/views/BookingScreen/booking_screen.dart';
// import 'package:nupura_cars/views/ProfileScreen/document_screen.dart';
// import 'package:nupura_cars/views/ProfileScreen/edit_profile_screen.dart';
// import 'package:nupura_cars/views/ProfileScreen/faq.dart';
// import 'package:nupura_cars/views/ProfileScreen/help_screen.dart';
// import 'package:nupura_cars/views/ProfileScreen/refer_screen.dart';
// import 'package:nupura_cars/views/ProfileScreen/settings_screen.dart';
// import 'package:nupura_cars/views/guest_modal.dart' hide LoginScreen;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;


// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> 
//     with TickerProviderStateMixin {
//   String referalCode = 'Loading...';
//   bool _isLoading = true;
//   String name = '';
//     late String userId;

//   late AnimationController _animationController;
//   late AnimationController _profileAnimationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   // New Modern Color Palette
//   static const Color _primaryColor = Color(0xFF8B5FBF);
//   static const Color _secondaryColor = Color(0xFFB794C4);
//   static const Color _accentColor = Color(0xFFFF8A65);
//   static const Color _backgroundLight = Color(0xFFF7F9FC);
//   static const Color _backgroundDark = Color(0xFF1A1B23);
//   static const Color _cardLight = Color(0xFFFFFFFF);
//   static const Color _cardDark = Color(0xFF2D2E3F);
//   static const Color _textPrimary = Color(0xFF2D3748);
//   static const Color _textSecondary = Color(0xFF718096);

//   @override
//   void initState() {
//     super.initState();
//         _loadUserDataa();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
    
//     _profileAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
//     ));
    
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _profileAnimationController,
//       curve: Curves.bounceOut,
//     ));
    
//     _loadUserData();
//     _animationController.forward();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _profileAnimationController.forward();
//     });
//   }

//     Future<void> _loadUserDataa() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       userId = prefs.getString('userId') ?? '';
//     } catch (e) {
//       debugPrint('Error getting user ID: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _profileAnimationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final userName = await StorageHelper.getUserName();
//       final code = await StorageHelper.getCode();
      
//       setState(() {
//         name = userName ?? 'Guest User';
//         referalCode = code ?? 'Guest User';
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         referalCode = 'Error loading code';
//         _isLoading = false;
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.white),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text('Failed to load data: ${e.toString()}')),
//               ],
//             ),
//             backgroundColor: Colors.redAccent,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
    
//     return Scaffold(
//       backgroundColor: isDark ? _backgroundDark : _backgroundLight,
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // Curved Header with Floating Profile
//             _buildCurvedHeader(context, isDark),
            
//             // Content Section
//             SliverToBoxAdapter(
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 60), // Space for floating profile
                    
//                     // User Info Card
//                     _buildUserInfoCard(context, isDark),
                    
//                     const SizedBox(height: 32),
                
                    
//                     // Menu Grid
//                     _buildMenuGrid(context, isDark),
                    
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCurvedHeader(BuildContext context, bool isDark) {
//     return SliverAppBar(
//       expandedHeight: 220,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 _primaryColor,
//                 _secondaryColor,
//                 _accentColor.withOpacity(0.8),
//               ],
//               stops: const [0.0, 0.6, 1.0],
//             ),
//           ),
//           child: Stack(
//             children: [
//               // Background Pattern
//               Positioned(
//                 top: -50,
//                 right: -50,
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.1),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 100,
//                 left: -30,
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.05),
//                   ),
//                 ),
//               ),
              
//               // Curved Bottom
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: isDark ? _backgroundDark : _backgroundLight,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),
//               ),
              
//               // Floating Profile Image
//               Positioned(
//                 bottom: -30,
//                 left: 0,
//                 right: 0,
//                 child: _buildFloatingProfile(context),
//               ),
//             ],
//           ),
//         ),
//       ),
//       title: const Text(
//         "My Profile",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           letterSpacing: 0.5,
//         ),
//       ),
//       centerTitle: true,
//       // leading: Container(
//       //   margin: const EdgeInsets.all(8),
//       //   decoration: BoxDecoration(
//       //     color: Colors.white.withOpacity(0.2),
//       //     borderRadius: BorderRadius.circular(12),
//       //   ),
//       //   child: IconButton(
//       //     icon: const Icon(Icons.menu, color: Colors.white),
//       //     onPressed: () {
//       //       // Handle menu
//       //     },
//       //   ),
//       // ),
//       // actions: [
//       //   Container(
//       //     margin: const EdgeInsets.all(8),
//       //     decoration: BoxDecoration(
//       //       color: Colors.white.withOpacity(0.2),
//       //       borderRadius: BorderRadius.circular(12),
//       //     ),
//       //     child: IconButton(
//       //       icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//       //       onPressed: () {
//       //         // Handle notifications
//       //       },
//       //     ),
//       //   ),
//       // ],
//     );
//   }

//   Widget _buildFloatingProfile(BuildContext context) {
//     return Center(
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Consumer<AuthProvider>(
//           builder: (context, authProvider, child) {
//             return _buildProfileAvatar(authProvider);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileAvatar(AuthProvider authProvider) {
//     return Container(
//       width: 120,
//       height: 120,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: _primaryColor.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(6),
//       child: FutureBuilder<String?>(
//         future: StorageHelper.getProfileImage(),
//         builder: (context, snapshot) {
//           final profileImageFromAuth = authProvider.user?.profileImage;
//           String imageUrl;

//           if (profileImageFromAuth != null) {
//             imageUrl = profileImageFromAuth;
//           } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
//             imageUrl = snapshot.data!;
//           } else {
//             imageUrl = 'https://avatar.iran.liara.run/public/boy?username=${name.isNotEmpty ? name : 'User'}';
//           }

//           if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
//             imageUrl = 'http://31.97.206.144:4072/$imageUrl';
//           }

//           return Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [_primaryColor, _accentColor],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             padding: const EdgeInsets.all(3),
//             child: Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: _accentColor,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 3),
//               ),
//               child: CircleAvatar(
//                 radius: 52,
//                 backgroundColor: Colors.grey[200],
//                 backgroundImage: NetworkImage(imageUrl),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildUserInfoCard(BuildContext context, bool isDark) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: isDark ? _cardDark : _cardLight,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             name.isNotEmpty ? name : 'Guest User',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : _textPrimary,
//             ),
//           ),
          
//           // const SizedBox(height: 8),
          
//           // Container(
//           //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           //   decoration: BoxDecoration(
//           //     gradient: LinearGradient(
//           //       colors: [_primaryColor.withOpacity(0.1), _accentColor.withOpacity(0.1)],
//           //     ),
//           //     borderRadius: BorderRadius.circular(20),
//           //     border: Border.all(color: _primaryColor.withOpacity(0.3)),
//           //   ),
//           //   child: Row(
//           //     mainAxisSize: MainAxisSize.min,
//           //     children: [
//           //       Icon(
//           //         Icons.stars_rounded,
//           //         size: 20,
//           //         color: _accentColor,
//           //       ),
//           //       const SizedBox(width: 8),
//           //       Text(
//           //         "Premium Member",
//           //         style: TextStyle(
//           //           fontSize: 14,
//           //           fontWeight: FontWeight.w600,
//           //           color: _primaryColor,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
          
//           const SizedBox(height: 16),
          
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: _accentColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _accentColor.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.card_giftcard_rounded,
//                   color: _accentColor,
//                   size: 24,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Referral Code",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: _textSecondary,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         referalCode,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: _accentColor,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Container(
//                 //   padding: const EdgeInsets.all(8),
//                 //   decoration: BoxDecoration(
//                 //     color: _accentColor,
//                 //     borderRadius: BorderRadius.circular(8),
//                 //   ),
//                 //   child: const Icon(
//                 //     Icons.copy_rounded,
//                 //     color: Colors.white,
//                 //     size: 18,
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }



//   // Widget _buildMenuGrid(BuildContext context, bool isDark) {
//   //   final menuItems = [
//   //     {'icon': Icons.person_outline, 'title': 'Edit Profile', 'color': _primaryColor, 'route': const EditProfile()},
//   //     {'icon': Icons.history_outlined, 'title': 'Trip History', 'color': const Color(0xFF4CAF50), 'route': const BookingScreen()},
//   //     {'icon': Icons.description_outlined, 'title': 'FAQ', 'color': const Color(0xFF2196F3), 'route':  FAQScreen()},
//   //     {'icon': Icons.card_giftcard_outlined, 'title': 'Invite & Earn', 'color': _accentColor, 'route': const ReferScreen()},
//   //     {'icon': Icons.settings_outlined, 'title': 'Settings', 'color': const Color(0xFF9E9E9E), 'route': const SettingsScreen()},
//   //     {'icon': Icons.help_outline, 'title': 'HELP', 'color': const Color(0xFF795548), 'route': const HelpSupportScreen()},

//   //   ];

//   //   return Container(
//   //     margin: const EdgeInsets.symmetric(horizontal: 24),
//   //     child: GridView.builder(
//   //       shrinkWrap: true,
//   //       physics: const NeverScrollableScrollPhysics(),
//   //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //         crossAxisCount: 2,
//   //         crossAxisSpacing: 16,
//   //         mainAxisSpacing: 16,
//   //         childAspectRatio: 1.1,
//   //       ),
//   //       itemCount: menuItems.length + 2, // +1 for logout button
//   //       itemBuilder: (context, index) {
//   //         if (index == menuItems.length) {
//   //           // Logout button
//   //           return _buildMenuGridItem(
//   //             context,
//   //             isDark,
//   //             Icons.logout_outlined,
//   //             'Logout',
//   //             const Color(0xFFE53E3E),
//   //             () => _showLogoutDialog(context),
//   //             isDestructive: true,
//   //           );
//   //         }

//   //                   if (index == menuItems.length+1) {
//   //           // Logout button
//   //           return _buildMenuGridItem(
//   //             context,
//   //             isDark,
//   //             Icons.delete_forever_outlined,
//   //             'DELETE',
//   //             const Color(0xFFE53E3E),
//   //             () => _showDeleteAccountDialog(),
//   //             isDestructive: true,
//   //           );
//   //         }
          
//   //         final item = menuItems[index];
//   //         return _buildMenuGridItem(
//   //           context,
//   //           isDark,
//   //           item['icon'] as IconData,
//   //           item['title'] as String,
//   //           item['color'] as Color,
//   //           () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => item['route'] as Widget)),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }


//   Widget _buildMenuGrid(BuildContext context, bool isDark) {
//   final menuItems = [
//     {
//       'icon': Icons.person_outline,
//       'title': 'Edit Profile',
//       'color': _primaryColor,
//       'route': const EditProfile(),
//       'requireAuth': true, // Needs authentication
//     },
//     {
//       'icon': Icons.history_outlined,
//       'title': 'Trip History',
//       'color': const Color(0xFF4CAF50),
//       'route': const BookingScreen(),
//       'requireAuth': true, // Needs authentication
//     },
//     //     {
//     //   'icon': Icons.file_open,
//     //   'title': 'Documents',
//     //   'color': const Color(0xFF4CAF50),
//     //   'route': const Documents(),
//     //   'requireAuth': true, // Needs authentication
//     // },
//     {
//       'icon': Icons.description_outlined,
//       'title': 'FAQ',
//       'color': const Color(0xFF2196F3),
//       'route': FAQScreen(),
//       'requireAuth': false, // Public access
//     },
//     {
//       'icon': Icons.card_giftcard_outlined,
//       'title': 'Invite & Earn',
//       'color': _accentColor,
//       'route': const ReferScreen(),
//       'requireAuth': true, // Needs authentication
//     },
//     {
//       'icon': Icons.settings_outlined,
//       'title': 'Settings',
//       'color': const Color(0xFF9E9E9E),
//       'route': const SettingsScreen(),
//       'requireAuth': false, // Public access
//     },
//     {
//       'icon': Icons.help_outline,
//       'title': 'HELP',
//       'color': const Color(0xFF795548),
//       'route': const HelpSupportScreen(),
//       'requireAuth': false, // Public access
//     },
//   ];

//   return Consumer<AuthProvider>(
//     builder: (context, authProvider, child) {
//       final isGuest = authProvider.isGuest;

//       return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 24),
//         child: GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.1,
//           ),
//           itemCount: menuItems.length + 2, // +2 for logout and delete buttons
//           itemBuilder: (context, index) {
//             if (index == menuItems.length) {
//               // Logout button
//               return _buildMenuGridItem(
//                 context,
//                 isDark,
//                 Icons.logout_outlined,
//                 'Logout',
//                 const Color(0xFFE53E3E),
//                 () {
//                     _showLogoutDialog(context);
//                 },
//                 isDestructive: true,
//               );
//             }

//             if (index == menuItems.length + 1) {
//               // Delete Account button
//               return _buildMenuGridItem(
//                 context,
//                 isDark,
//                 Icons.delete_forever_outlined,
//                 'DELETE',
//                 const Color(0xFFE53E3E),
//                 () {
//                   // Show guest modal if guest, otherwise show delete dialog
//                   if (isGuest) {
//                     GuestLoginBottomSheet.show(context);
//                   } else {
//                     _showDeleteAccountDialog();
//                   }
//                 },
//                 isDestructive: true,
//               );
//             }

//             final item = menuItems[index];
//             final requireAuth = item['requireAuth'] as bool;

//             return _buildMenuGridItem(
//               context,
//               isDark,
//               item['icon'] as IconData,
//               item['title'] as String,
//               item['color'] as Color,
//               () async {
//                 // Check if feature requires authentication
//                 if (requireAuth && isGuest) {
//                   // Show guest login modal
//                   await GuestLoginBottomSheet.show(context);
//                   return;
//                 }

//                 // Navigate to the route if authenticated or public
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (ctx) => item['route'] as Widget),
//                 );
//               },
//             );
//           },
//         ),
//       );
//     },
//   );
// }

//     void _showDeleteAccountDialog() {
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

//     Future<bool> _deleteUserAccount() async {
//     try {
//       if (userId.isEmpty) {
//         throw Exception('User ID not found');
//       }

//             print("Rrrrrrrrrrrrrrrrrrrrrrrrrrrr$userId");


//       final response = await http.delete(
//         Uri.parse('http://31.97.206.144:4072/api/users/delete-user/$userId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       print("Rrrrrrrrrrrrrrrrrrrrrrrrrrrr${response.body}");

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

//     void _showErrorSnackBar(String message) {
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

//   void _logout() {
//     Provider.of<AuthProvider>(context, listen: false).logout();
//     Provider.of<DateTimeProvider>(context, listen: false).resetAll();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (ctx) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   // Widget _buildMenuGridItem(
//   //   BuildContext context,
//   //   bool isDark,
//   //   IconData icon,
//   //   String title,
//   //   Color color,
//   //   VoidCallback onTap, {
//   //   bool isDestructive = false,
//   // }) {
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       color: isDark ? _cardDark : _cardLight,
//   //       borderRadius: BorderRadius.circular(20),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: (isDark ? Colors.black : Colors.grey).withOpacity(0.05),
//   //           blurRadius: 15,
//   //           offset: const Offset(0, 8),
//   //         ),
//   //       ],
//   //     ),
//   //     child: Material(
//   //       color: Colors.transparent,
//   //       child: InkWell(
//   //         onTap: onTap,
//   //         borderRadius: BorderRadius.circular(20),
//   //         child: Padding(
//   //           padding: const EdgeInsets.all(24),
//   //           child: Column(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             children: [
//   //               Container(
//   //                 width: 60,
//   //                 height: 60,
//   //                 decoration: BoxDecoration(
//   //                   color: color.withOpacity(0.15),
//   //                   borderRadius: BorderRadius.circular(20),
//   //                 ),
//   //                 child: Icon(
//   //                   icon,
//   //                   color: color,
//   //                   size: 28,
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 16),
//   //               Text(
//   //                 title,
//   //                 textAlign: TextAlign.center,
//   //                 style: TextStyle(
//   //                   fontSize: 14,
//   //                   fontWeight: FontWeight.w600,
//   //                   color: isDestructive 
//   //                     ? color
//   //                     : (isDark ? Colors.white : _textPrimary),
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }


//   Widget _buildMenuGridItem(
//   BuildContext context,
//   bool isDark,
//   IconData icon,
//   String title,
//   Color color,
//   VoidCallback onTap, {
//   bool isDestructive = false,
// }) {
//   return Container(
//     decoration: BoxDecoration(
//       color: isDark ? _cardDark : _cardLight,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: (isDark ? Colors.black : Colors.grey).withOpacity(0.05),
//           blurRadius: 15,
//           offset: const Offset(0, 8),
//         ),
//       ],
//     ),
//     child: Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Flexible(
//                 flex: 3,
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: color,
//                     size: 28,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Flexible(
//                 flex: 2,
//                 child: Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: isDestructive
//                         ? color
//                         : (isDark ? Colors.white : _textPrimary),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }


//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Theme.of(context).brightness == Brightness.dark ? _cardDark : _cardLight,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           title: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE53E3E).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.logout_outlined,
//                   color: Color(0xFFE53E3E),
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Logout Confirmation',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//             ],
//           ),
//           content: const Text(
//             'Are you sure you want to logout from your account?',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(color: _textSecondary, fontWeight: FontWeight.w600),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [const Color(0xFFE53E3E), const Color(0xFFFF6B6B)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Provider.of<AuthProvider>(context, listen: false).logout();
//                   Provider.of<DateTimeProvider>(context, listen: false).resetAll();
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (ctx) => const LoginScreen()),
//                     (route) => false,
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text(
//                   'Logout',
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


















import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nupura_cars/views/CartScreen/cart_screen.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:nupura_cars/widgects/BackControl/back_confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
import 'package:nupura_cars/views/BookingScreen/booking_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/document_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/edit_profile_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/faq.dart';
import 'package:nupura_cars/views/ProfileScreen/help_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/refer_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/settings_screen.dart';
import 'package:nupura_cars/views/guest_modal.dart' hide LoginScreen;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
    with TickerProviderStateMixin {
  String referalCode = 'Loading...';
  bool _isLoading = true;
  String name = '';
  late String userId;

  late AnimationController _animationController;
  late AnimationController _profileAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Modern Color Palette with Theme Support
  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  Color get _secondaryColor => Theme.of(context).colorScheme.primaryContainer;
  Color get _accentColor => Theme.of(context).colorScheme.secondary;
  Color get _backgroundColor => Theme.of(context).colorScheme.background;
  Color get _cardColor => Theme.of(context).cardColor;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _surfaceColor => Theme.of(context).colorScheme.surface;
  Color get _scaffoldBackgroundColor => Theme.of(context).scaffoldBackgroundColor;
  Color get _dividerColor => Theme.of(context).dividerColor;
   static const Color _errorRed = Color(0xFFE53E3E);
     static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _infoBlue = Color(0xFF2196F3);
  static const Color _warningAmber = Color(0xFFFF9800);
  static const Color _neutralGrey = Color(0xFF9E9E9E);
  static const Color _brown = Color(0xFF795548);

  @override
  void initState() {
    super.initState();
    _loadUserDataa();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.bounceOut,
    ));
    
    _loadUserData();
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _profileAnimationController.forward();
    });
  }

  Future<void> _loadUserDataa() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
    } catch (e) {
      debugPrint('Error getting user ID: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profileAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userName = await StorageHelper.getUserName();
      final code = await StorageHelper.getCode();
      
      setState(() {
        name = userName ?? 'Guest User';
        referalCode = code ?? 'Guest User';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        referalCode = 'Error loading code';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to load data: ${e.toString()}')),
              ],
            ),
            backgroundColor: _errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return PopScope(
      canPop: false,
           onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await showBackConfirmDialog(context);
        if (shouldExit) {
          Navigator.of(context).pop(); // exits app / screen
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Curved Header with Floating Profile
              _buildCurvedHeader(context, theme, isDark),
              
              // Content Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 60), // Space for floating profile
                      
                      // User Info Card
                      _buildUserInfoCard(context, theme, isDark),
                      
                      const SizedBox(height: 32),
                      
                      // Menu Grid
                      _buildMenuGrid(context, theme, isDark),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurvedHeader(BuildContext context, ThemeData theme, bool isDark) {
    return SliverAppBar(
      expandedHeight: 220,
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
                _primaryColor,
                _secondaryColor,
                _accentColor.withOpacity(0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              
              // Curved Bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              
              // Floating Profile Image
              Positioned(
                bottom: -30,
                left: 0,
                right: 0,
                child: _buildFloatingProfile(context),
              ),
            ],
          ),
        ),
      ),
      title: const Text(
        "My Profile",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildFloatingProfile(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return _buildProfileAvatar(authProvider);
          },
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(AuthProvider authProvider) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: FutureBuilder<String?>(
        future: StorageHelper.getProfileImage(),
        builder: (context, snapshot) {
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _accentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            name.isNotEmpty ? name : 'Guest User',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _accentColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard_rounded,
                  color: _accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Referral Code",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        referalCode,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _accentColor,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, ThemeData theme, bool isDark) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit Profile',
        'color': _primaryColor,
        'route': const EditProfile(),
        'requireAuth': true,
      },
      {
        'icon': Icons.history_outlined,
        'title': 'Trip History',
        'color': _successGreen,
        'route': const MainNavigationScreen(initialIndex: 1,),
        'requireAuth': true,
      },
            {
        'icon': Icons.book_online,
        'title': 'Bookings',
        'color': _successGreen,
        'route': const MainNavigationScreen(initialIndex: 2,),
        'requireAuth': true,
      },
      {
        'icon': Icons.file_open,
        'title': 'Documents',
        'color': _infoBlue,
        'route': const Documents(),
        'requireAuth': true,
      },
      {
        'icon': Icons.description_outlined,
        'title': 'FAQ',
        'color': _infoBlue,
        'route': FAQScreen(),
        'requireAuth': false,
      },
      {
        'icon': Icons.card_giftcard_outlined,
        'title': 'Invite & Earn',
        'color': _accentColor,
        'route': const ReferScreen(),
        'requireAuth': true,
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Settings',
        'color': _neutralGrey,
        'route': const SettingsScreen(),
        'requireAuth': false,
      },
      {
        'icon': Icons.help_outline,
        'title': 'HELP',
        'color': _brown,
        'route': const HelpSupportScreen(),
        'requireAuth': false,
      },
    ];

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isGuest = authProvider.isGuest;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: menuItems.length + 2,
            itemBuilder: (context, index) {
              if (index == menuItems.length) {
                return _buildMenuGridItem(
                  context,
                  theme,
                  Icons.logout_outlined,
                  'Logout',
                  _errorRed,
                  () => _showLogoutDialog(context),
                  isDestructive: true,
                );
              }

              if (index == menuItems.length + 1) {
                return _buildMenuGridItem(
                  context,
                  theme,
                  Icons.delete_forever_outlined,
                  'DELETE',
                  _errorRed,
                  () {
                    if (isGuest) {
                      GuestLoginBottomSheet.show(context);
                    } else {
                      _showDeleteAccountDialog();
                    }
                  },
                  isDestructive: true,
                );
              }

              final item = menuItems[index];
              final requireAuth = item['requireAuth'] as bool;

              return _buildMenuGridItem(
                context,
                theme,
                item['icon'] as IconData,
                item['title'] as String,
                item['color'] as Color,
                () async {
                  if (requireAuth && isGuest) {
                    await GuestLoginBottomSheet.show(context);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => item['route'] as Widget),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMenuGridItem(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  flex: 2,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? color : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _errorRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: _errorRed,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Account?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _errorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone. All your data will be permanently deleted including:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _errorRed.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _errorRed.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '• Personal information & profile',
                    '• Booking history & preferences',
                    '• Stored payment methods',
                    '• Account settings & data',
                  ]
                      .map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: _errorRed,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _errorRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void _deleteAccount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_errorRed, Color(0xFFB91C1C)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Deleting Account',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we process your request...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: _successGreen,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Account deleted successfully')),
              ],
            ),
            backgroundColor: _successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: _errorRed,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout_outlined,
                  color: _errorRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout Confirmation',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_errorRed, Color(0xFFFF6B6B)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}