
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
// import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _primaryController;
//   late AnimationController _secondaryController;
//   late AnimationController _waveController;
//   late AnimationController _morphController;
  
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _rotateAnimation;
//   late Animation<Color?> _colorAnimation;
//   late Animation<double> _waveAnimation;
//   late Animation<double> _morphAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startAnimations();
//     _checkLoginStatus();
//   }

//   void _initializeAnimations() {
//     _primaryController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _secondaryController = AnimationController(
//       duration: const Duration(milliseconds: 1800),
//       vsync: this,
//     );

//     _waveController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     )..repeat();

//     _morphController = AnimationController(
//       duration: const Duration(milliseconds: 4000),
//       vsync: this,
//     )..repeat();

//     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _primaryController, curve: Curves.bounceOut),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _primaryController, curve: Curves.easeInOut),
//     );

//     _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
//       CurvedAnimation(parent: _secondaryController, curve: Curves.elasticOut),
//     );

//     _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
//       CurvedAnimation(parent: _morphController, curve: Curves.linear),
//     );

//     _colorAnimation = ColorTween(
//       begin: Color(0xFF00D4FF),
//       end: Color(0xFF5A67D8),
//     ).animate(CurvedAnimation(parent: _morphController, curve: Curves.easeInOut));

//     _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
//     );

//     _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _morphController, curve: Curves.easeInOut),
//     );
//   }

//   void _startAnimations() {
//     Future.delayed(Duration(milliseconds: 300), () {
//       _primaryController.forward();
//     });
    
//     Future.delayed(Duration(milliseconds: 800), () {
//       _secondaryController.forward();
//     });
//   }

//   Future<void> _checkLoginStatus() async {
//     await Future.delayed(const Duration(milliseconds: 3500));

//     final userId = await StorageHelper.getUserId();
//     final p = await StorageHelper.getProfileImage();

//     print("Profile Image: $p");
//     print("User ID: $userId");

//     if (!mounted) return;

//     // Unique exit animation
//     await _performExitAnimation();

//     if (userId != null && userId.isNotEmpty) {
//       try {
//         print("Navigating to Home Screen for User ID: $userId");
//         _navigateToScreen(MainNavigationScreen());
//       } catch (e) {
//         _navigateToScreen(const LoginScreen());
//       }
//     } else {
//       _navigateToScreen(const LoginScreen());
//     }
//   }

//   Future<void> _performExitAnimation() async {
//     await Future.wait([
//       _primaryController.reverse(),
//       _secondaryController.reverse(),
//     ]);
//   }

//   void _navigateToScreen(Widget screen) {
//     Navigator.of(context).pushReplacement(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => screen,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset(0.0, 1.0),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeOutCubic,
//             )),
//             child: child,
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 800),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _primaryController.dispose();
//     _secondaryController.dispose();
//     _waveController.dispose();
//     _morphController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Choose one of these completely different designs:
//     return _buildLiquidSplash(); // Style 1: Liquid morphing design
//     // return _buildCyberSplash(); // Style 2: Cyberpunk/neon style
//     // return _buildOrganicSplash(); // Style 3: Organic/nature inspired
//     // return _buildArchitecturalSplash(); // Style 4: Geometric/architectural
//     // return _buildSpaceSplash(); // Style 5: Space/cosmic theme
//   }

//   // Style 1: Liquid Morphing Splash (Default)
//   Widget _buildLiquidSplash() {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([_morphController, _waveController]),
//         builder: (context, child) {
//           return Container(
//             decoration: BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment.center,
//                 colors: [
//                   Color(0xFF1A2980),
//                   Color(0xFF26D0CE),
//                   Color(0xFF1A2980),
//                 ],
//                 stops: [0.0, 0.5, 1.0],
//                 radius: 1.0 + 0.3 * math.sin(_morphAnimation.value * 2 * math.pi),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Animated liquid shapes
//                 ..._buildLiquidShapes(),
                
//                 // Main content
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Morphing logo container
//                       AnimatedBuilder(
//                         animation: _primaryController,
//                         builder: (context, child) {
//                           return Transform.scale(
//                             scale: _scaleAnimation.value,
//                             child: FadeTransition(
//                               opacity: _fadeAnimation,
//                               child: Container(
//                                 width: 160,
//                                 height: 160,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   gradient: SweepGradient(
//                                     colors: [
//                                       Colors.cyan.withOpacity(0.8),
//                                       Colors.blue.withOpacity(0.8),
//                                       Colors.purple.withOpacity(0.8),
//                                       Colors.cyan.withOpacity(0.8),
//                                     ],
//                                     transform: GradientRotation(_rotateAnimation.value),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.cyan.withOpacity(0.4),
//                                       blurRadius: 30,
//                                       spreadRadius: 5,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Container(
//                                   margin: EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(0xFF0F1419),
//                                   ),
//                                   child: Center(
//                                     child: ClipOval(
//                                       child: Image.asset(
//                                         'assets/images/logo.png',
//                                         width: 120,
//                                         height: 120,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Icon(
//                                             Icons.car_rental,
//                                             size: 80,
//                                             color: Colors.cyan,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),

//                       SizedBox(height: 60),

//                       // Animated text
//                       AnimatedBuilder(
//                         animation: _secondaryController,
//                         builder: (context, child) {
//                           return Transform.translate(
//                             offset: Offset(0, _slideAnimation.value),
//                             child: FadeTransition(
//                               opacity: _fadeAnimation,
//                               child: Column(
//                                 children: [
//                                   ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       colors: [
//                                         Colors.cyan,
//                                         Colors.blue,
//                                         Colors.purple,
//                                         Colors.cyan,
//                                       ],
//                                       stops: [0.0, 0.3, 0.7, 1.0],
//                                     ).createShader(bounds),
//                                     child: Text(
//                                       'DRIVE',
//                                       style: TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                         letterSpacing: 4,
//                                         shadows: [
//                                           Shadow(
//                                             color: Colors.cyan.withOpacity(0.5),
//                                             blurRadius: 20,
//                                             offset: Offset(0, 0),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 4),
//                                                                     ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       colors: [
//                                         Colors.cyan,
//                                         Colors.blue,
//                                         Colors.purple,
//                                         Colors.cyan,
//                                       ],
//                                       stops: [0.0, 0.3, 0.7, 1.0],
//                                     ).createShader(bounds),
//                                     child: Text(
//                                       'CAR RENTAL',
//                                       style: TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                         letterSpacing: 4,
//                                         shadows: [
//                                           Shadow(
//                                             color: Colors.cyan.withOpacity(0.5),
//                                             blurRadius: 20,
//                                             offset: Offset(0, 0),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Colors.cyan.withOpacity(0.2),
//                                           Colors.blue.withOpacity(0.2),
//                                         ],
//                                       ),
//                                       borderRadius: BorderRadius.circular(30),
//                                       border: Border.all(
//                                         color: Colors.cyan.withOpacity(0.4),
//                                         width: 1,
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'Experience Premium Mobility',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white.withOpacity(0.9),
//                                         letterSpacing: 0.8,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),

//                       SizedBox(height: 80),

//                       // Liquid progress indicator
//                       AnimatedBuilder(
//                         animation: _waveController,
//                         builder: (context, child) {
//                           return Container(
//                             width: 280,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               color: Colors.white.withOpacity(0.1),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: LinearProgressIndicator(
//                                 value: null, // Indeterminate
//                                 backgroundColor: Colors.transparent,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   _colorAnimation.value ?? Colors.cyan,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),

//                       SizedBox(height: 24),

//                       FadeTransition(
//                         opacity: _fadeAnimation,
//                         child: Text(
//                           'Initializing...',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.7),
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Style 2: Cyberpunk/Neon Splash
//   Widget _buildCyberSplash() {
//     return Scaffold(
//       backgroundColor: Color(0xFF0A0A0A),
//       body: AnimatedBuilder(
//         animation: Listenable.merge([_morphController, _primaryController]),
//         builder: (context, child) {
//           return Stack(
//             children: [
//               // Animated grid background
//               CustomPaint(
//                 painter: CyberGridPainter(_morphAnimation.value),
//                 size: Size(double.infinity, double.infinity),
//               ),
              
//               // Neon glitch effects
//               ..._buildGlitchEffects(),
              
//               SafeArea(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Neon logo
//                     AnimatedBuilder(
//                       animation: _primaryController,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: _scaleAnimation.value,
//                           child: Container(
//                             width: 180,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Color(0xFF00FFFF),
//                                 width: 2,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0xFF00FFFF).withOpacity(0.5),
//                                   blurRadius: 30,
//                                   spreadRadius: 0,
//                                 ),
//                                 BoxShadow(
//                                   color: Color(0xFFFF0080).withOpacity(0.3),
//                                   blurRadius: 50,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(18),
//                               child: Container(
//                                 color: Color(0xFF1A1A1A),
//                                 child: Center(
//                                   child: Image.asset(
//                                     'assets/images/logo.png',
//                                     width: 140,
//                                     height: 80,
//                                     fit: BoxFit.contain,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Icon(
//                                         Icons.speed,
//                                         size: 60,
//                                         color: Color(0xFF00FFFF),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//                     SizedBox(height: 50),

//                     // Glitch text effect
//                     AnimatedBuilder(
//                       animation: _secondaryController,
//                       builder: (context, child) {
//                         return Transform.translate(
//                           offset: Offset(0, _slideAnimation.value),
//                           child: Column(
//                             children: [
//                               Stack(
//                                 children: [
//                                   // Main text
//                                   Text(
//                                     'DRIVE A CAR',
//                                     style: TextStyle(
//                                       fontSize: 56,
//                                       fontWeight: FontWeight.w800,
//                                       color: Color(0xFF00FFFF),
//                                       letterSpacing: 8,
//                                       shadows: [
//                                         Shadow(
//                                           color: Color(0xFF00FFFF),
//                                           blurRadius: 20,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // Glitch overlay
//                                   if (_morphAnimation.value > 0.5)
//                                     Transform.translate(
//                                       offset: Offset(2, 0),
//                                       child: Text(
//                                         'DRIVE A CAR',
//                                         style: TextStyle(
//                                           fontSize: 56,
//                                           fontWeight: FontWeight.w800,
//                                           color: Color(0xFFFF0080),
//                                           letterSpacing: 8,
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               SizedBox(height: 20),
//                               Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Color(0xFF00FFFF),
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Text(
//                                   '> FUTURE_MOBILITY_PROTOCOL',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontFamily: 'monospace',
//                                     color: Color(0xFF00FFFF),
//                                     letterSpacing: 1,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),

//                     SizedBox(height: 80),

//                     // Cyber progress bar
//                     Container(
//                       width: 300,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'LOADING',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Color(0xFF00FFFF),
//                                   fontFamily: 'monospace',
//                                   letterSpacing: 2,
//                                 ),
//                               ),
//                               Text(
//                                 '${(_morphAnimation.value * 100).toInt()}%',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Color(0xFF00FFFF),
//                                   fontFamily: 'monospace',
//                                   letterSpacing: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Container(
//                             height: 4,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Color(0xFF00FFFF), width: 1),
//                             ),
//                             child: LinearProgressIndicator(
//                               value: null,
//                               backgroundColor: Color(0xFF1A1A1A),
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Color(0xFF00FFFF),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Style 3: Organic/Nature Splash
//   Widget _buildOrganicSplash() {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF1B5E20),
//               Color(0xFF2E7D32),
//               Color(0xFF43A047),
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Organic floating elements
//             ..._buildOrganicElements(),
            
//             SafeArea(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Organic logo container
//                   // AnimatedBuilder(
//                   //   animation: _primaryController,
//                   //   builder: (context, child) {
//                   //     return Transform.scale(
//                   //       scale: _scaleAnimation.value,
//                   //       child: Container(
//                   //         width: 140,
//                   //         height: 140,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(70),
//                   //           gradient: RadialGradient(
//                   //             colors: [
//                   //               Color(0xFF66BB6A),
//                   //               Color(0xFF4CAF50),
//                   //               Color(0xFF2E7D32),
//                   //             ],
//                   //           ),
//                   //           boxShadow: [
//                   //             BoxShadow(
//                   //               color: Color(0xFF4CAF50).withOpacity(0.4),
//                   //               blurRadius: 25,
//                   //               spreadRadius: 5,
//                   //             ),
//                   //           ],
//                   //         ),
//                   //         child: Container(
//                   //           margin: EdgeInsets.all(8),
//                   //           decoration: BoxDecoration(
//                   //             borderRadius: BorderRadius.circular(62),
//                   //             color: Colors.white.withOpacity(0.1),
//                   //           ),
//                   //           child: ClipRRect(
//                   //             borderRadius: BorderRadius.circular(62),
//                   //             child: Image.asset(
//                   //               'assets/images/logo.png',
//                   //               fit: BoxFit.cover,
//                   //               errorBuilder: (context, error, stackTrace) {
//                   //                 return Icon(
//                   //                   Icons.eco,
//                   //                   size: 70,
//                   //                   color: Colors.white,
//                   //                 );
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     );
//                   //   },
//                   // ),

//                   SizedBox(height: 50),

//                   // Organic text design
//                   AnimatedBuilder(
//                     animation: _secondaryController,
//                     builder: (context, child) {
//                       return Transform.translate(
//                         offset: Offset(0, _slideAnimation.value),
//                         child: Column(
//                           children: [
//                             Text(
//                               'DRIVE A CAR',
//                               style: TextStyle(
//                                 fontSize: 44,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                                 letterSpacing: 3,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.green.withOpacity(0.5),
//                                     blurRadius: 15,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(25),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.3),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Text(
//                                 'Eco-Friendly Transportation',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white.withOpacity(0.95),
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),

//                   SizedBox(height: 80),

//                   // Organic progress indicator
//                   AnimatedBuilder(
//                     animation: _waveController,
//                     builder: (context, child) {
//                       return Column(
//                         children: [
//                           Container(
//                             width: 260,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(3),
//                               color: Colors.white.withOpacity(0.2),
//                             ),
//                             child: LinearProgressIndicator(
//                               value: null,
//                               backgroundColor: Colors.transparent,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           Text(
//                             'Growing your experience...',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white.withOpacity(0.8),
//                               fontWeight: FontWeight.w400,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildLiquidShapes() {
//     return List.generate(8, (index) {
//       return AnimatedBuilder(
//         animation: _morphController,
//         builder: (context, child) {
//           final offset = _morphAnimation.value * 2 * math.pi + index;
//           final size = 60.0 + index * 20.0 + 30 * math.sin(offset);
//           final x = 100 + index * 40.0 + 80 * math.cos(offset * 0.5);
//           final y = 150 + index * 60.0 + 60 * math.sin(offset * 0.3);
          
//           return Positioned(
//             left: x % MediaQuery.of(context).size.width,
//             top: y % MediaQuery.of(context).size.height,
//             child: Container(
//               width: size,
//               height: size,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(size / 2),
//                 gradient: RadialGradient(
//                   colors: [
//                     Colors.cyan.withOpacity(0.3),
//                     Colors.blue.withOpacity(0.1),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   List<Widget> _buildGlitchEffects() {
//     return List.generate(15, (index) {
//       return AnimatedBuilder(
//         animation: _morphController,
//         builder: (context, child) {
//           if (_morphAnimation.value < 0.3 || _morphAnimation.value > 0.7) {
//             return Container();
//           }
          
//           final x = (index * 30.0) % MediaQuery.of(context).size.width;
//           final y = (index * 50.0) % MediaQuery.of(context).size.height;
          
//           return Positioned(
//             left: x,
//             top: y,
//             child: Container(
//               width: 2,
//               height: 20 + (index % 3) * 10,
//               color: index % 2 == 0 ? Color(0xFF00FFFF) : Color(0xFFFF0080),
//             ),
//           );
//         },
//       );
//     });
//   }

//   List<Widget> _buildOrganicElements() {
//     return List.generate(12, (index) {
//       return AnimatedBuilder(
//         animation: _waveController,
//         builder: (context, child) {
//           final offset = _waveAnimation.value * 2 * math.pi + index;
//           final size = 40.0 + index * 15.0;
//           final x = 50 + index * 35.0 + 50 * math.sin(offset * 0.8);
//           final y = 80 + index * 45.0 + 40 * math.cos(offset * 0.6);
          
//           return Positioned(
//             left: x % MediaQuery.of(context).size.width,
//             top: y % MediaQuery.of(context).size.height,
//             child: Container(
//               width: size,
//               height: size * 0.8,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF4CAF50).withOpacity(0.4),
//                     Color(0xFF2E7D32).withOpacity(0.2),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// class CyberGridPainter extends CustomPainter {
//   final double animationValue;
  
//   CyberGridPainter(this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Color(0xFF00FFFF).withOpacity(0.2)
//       ..strokeWidth = 0.5
//       ..style = PaintingStyle.stroke;

//     final gridSize = 50.0;
//     final offsetY = (animationValue * gridSize) % gridSize;

//     // Vertical lines
//     for (double x = 0; x < size.width; x += gridSize) {
//       canvas.drawLine(
//         Offset(x, 0),
//         Offset(x, size.height),
//         paint,
//       );
//     }

//     // Horizontal lines with animation
//     for (double y = -gridSize + offsetY; y < size.height + gridSize; y += gridSize) {
//       canvas.drawLine(
//         Offset(0, y),
//         Offset(size.width, y),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }












import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late AnimationController _waveController;
  late AnimationController _morphController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _checkLoginStatus();
  }

  void _initializeAnimations() {
    _primaryController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _secondaryController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _morphController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _secondaryController, curve: Curves.easeOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _morphController, curve: Curves.linear),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF00D4FF),
      end: const Color(0xFF4F46E5),
    ).animate(
      CurvedAnimation(parent: _morphController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _morphController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _primaryController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _secondaryController.forward();
    });
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 3500));

    final userId = await StorageHelper.getUserId();
    final p = await StorageHelper.getProfileImage();

    // Debug prints
    // ignore: avoid_print
    print("Profile Image: $p");
    // ignore: avoid_print
    print("User ID: $userId");

    if (!mounted) return;

    await _performExitAnimation();

    if (userId != null && userId.isNotEmpty) {
      try {
        // ignore: avoid_print
        print("Navigating to Home Screen for User ID: $userId");
        _navigateToScreen(const MainNavigationScreen());
      } catch (e) {
        _navigateToScreen(const LoginScreen());
      }
    } else {
      _navigateToScreen(const LoginScreen());
    }
  }

  Future<void> _performExitAnimation() async {
    await Future.wait([
      _primaryController.reverse(),
      _secondaryController.reverse(),
    ]);
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _waveController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _primaryController,
          _secondaryController,
          _waveController,
          _morphController,
        ]),
        builder: (context, _) {
          final size = MediaQuery.of(context).size;

          return Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF020617), // slate-950
                  Color(0xFF0F172A), // slate-900
                  Color(0xFF1E293B), // slate-800
                ],
              ),
            ),
            child: Stack(
              children: [
                // Soft background circles
                _buildBackgroundCircle(
                  size: size,
                  diameter: size.width * 0.9,
                  offset: Offset(
                    -size.width * 0.25,
                    -size.width * 0.3,
                  ),
                  color: const Color(0xFF22D3EE).withOpacity(0.12),
                ),
                _buildBackgroundCircle(
                  size: size,
                  diameter: size.width * 0.8,
                  offset: Offset(
                    size.width * 0.35,
                    size.height * 0.65,
                  ),
                  color: const Color(0xFF6366F1).withOpacity(0.12),
                ),

                // Animated subtle wave at bottom
                _buildBottomWave(size),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Top mini headline
                        Align(
                          alignment: Alignment.topLeft,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.06),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.shield_moon_outlined,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Nupura Cars',
                                    style: TextStyle(
                                      fontSize: 11,
                                      letterSpacing: 0.6,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Center logo + animated circle
                        Center(
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: _buildLogoCard(size),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Title + subtitle
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: const [
                              Text(
                                'Car rental',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Wash, service & bookings handled\nin one seamless experience.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Bottom progress + hint
                        _buildBottomSection(),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Big rotating soft card with logo + car illustration
  Widget _buildLogoCard(Size size) {
    final cardSize = size.width * 0.58;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating ring
        Transform.rotate(
          angle: _rotateAnimation.value,
          child: Container(
            width: cardSize + 26,
            height: cardSize + 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  const Color(0xFF22D3EE).withOpacity(0.0),
                  const Color(0xFF22D3EE).withOpacity(0.6),
                  const Color(0xFF6366F1).withOpacity(0.0),
                  const Color(0xFF22D3EE).withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),

        // Main card
        Container(
          width: cardSize,
          height: cardSize * 0.72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: const Color(0xFF020617).withOpacity(0.9),
            border: Border.all(
              color: Colors.white.withOpacity(0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0EA5E9).withOpacity(0.8),
                blurRadius: 32,
                spreadRadius: -16,
                offset: const Offset(0, 22),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF22D3EE),
                          Color(0xFF6366F1),
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.directions_car_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),

                // Text + mini tags
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Nupura Cars',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quick wash • Full service • Instant booking',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     _buildSmallPill(
                      //       icon: Icons.local_car_wash_outlined,
                      //       label: 'Car wash',
                      //     ),
                      //     const SizedBox(width: 6),
                      //     _buildSmallPill(
                      //       icon: Icons.build_outlined,
                      //       label: 'Service',
                      //     ),
                      //     const SizedBox(width: 6),
                      //     _buildSmallPill(
                      //       icon: Icons.event_available_outlined,
                      //       label: 'Booking',
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallPill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircle({
    required Size size,
    required double diameter,
    required Offset offset,
    required Color color,
  }) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBottomWave(Size size) {
    final waveHeight = 80.0;
    final progress = _waveAnimation.value;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: size.width,
        height: waveHeight,
        child: CustomPaint(
          painter: _BottomWavePainter(
            animationValue: progress,
            color: const Color(0xFF020617),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Progress bar
        Container(
          width: double.infinity,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.white.withOpacity(0.05),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: null,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _colorAnimation.value ?? const Color(0xFF22D3EE),
              ),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Getting your car ready',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.white70,
                ),
              ),
              Text(
                'Checking saved profile…',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Painter for subtle bottom wave / road-like shape
class _BottomWavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _BottomWavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final height = size.height;

    final waveOffset = (animationValue * 40);

    path.moveTo(0, height * 0.35);

    path.quadraticBezierTo(
      size.width * 0.25,
      height * (0.55 + 0.10 * math.sin(animationValue * math.pi)),
      size.width * 0.5,
      height * (0.45 + waveOffset / 200),
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      height * (0.35 + 0.08 * math.cos(animationValue * math.pi)),
      size.width,
      height * 0.55,
    );

    path.lineTo(size.width, height);
    path.lineTo(0, height);
    path.close();

    final paint = Paint()
      ..color = color.withOpacity(0.96)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}
