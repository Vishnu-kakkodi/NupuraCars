
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:math' as math;

// class ReferScreen extends StatefulWidget {
//   const ReferScreen({super.key});

//   @override
//   State<ReferScreen> createState() => _ReferScreenState();
// }

// class _ReferScreenState extends State<ReferScreen> 
//     with TickerProviderStateMixin {
//   String inviteCode = 'Loading...';
//   bool _isLoading = true;
  
//   late AnimationController _pulseController;
//   late AnimationController _rotateController;
//   late AnimationController _waveController;
//   late AnimationController _particleController;
//   late AnimationController _morphController;
  
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _rotateAnimation;
//   late Animation<double> _waveAnimation;
//   late Animation<double> _particleAnimation;
//   late Animation<double> _morphAnimation;
//   late Animation<Color?> _colorAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadUserData();
//   }

//   void _initializeAnimations() {
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     )..repeat();

//     _rotateController = AnimationController(
//       duration: const Duration(milliseconds: 8000),
//       vsync: this,
//     )..repeat();

//     _waveController = AnimationController(
//       duration: const Duration(milliseconds: 3000),
//       vsync: this,
//     )..repeat();

//     _particleController = AnimationController(
//       duration: const Duration(milliseconds: 5000),
//       vsync: this,
//     )..repeat();

//     _morphController = AnimationController(
//       duration: const Duration(milliseconds: 4000),
//       vsync: this,
//     )..repeat();

//     _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
//       CurvedAnimation(parent: _rotateController, curve: Curves.linear),
//     );

//     _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
//     );

//     _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _particleController, curve: Curves.linear),
//     );

//     _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _morphController, curve: Curves.easeInOut),
//     );

//     _colorAnimation = ColorTween(
//       begin: Color(0xFF8A2BE2),
//       end: Color(0xFF00CED1),
//     ).animate(CurvedAnimation(parent: _morphController, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _rotateController.dispose();
//     _waveController.dispose();
//     _particleController.dispose();
//     _morphController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
    
//     try {
//       final code = await StorageHelper.getCode();
//       await Future.delayed(const Duration(milliseconds: 1500));
      
//       if (code != null) {
//         setState(() {
//           inviteCode = code;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           inviteCode = 'INVITE2024';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         inviteCode = 'REFER2024';
//         _isLoading = false;
//       });
//     }
//   }

//   void _copyInviteCode() {
//     if (_isValidCode()) {
//       Clipboard.setData(ClipboardData(text: inviteCode));
//       _showQuantumSnackBar('Code copied to quantum clipboard! 🚀', true);
//       HapticFeedback.heavyImpact();
//     }
//   }

//   void _shareInviteCode() {
//     if (_isValidCode()) {
//       final String shareText = 
//           '🌟 Join the future of mobility with VSD!\n\n'
//           '🔮 Use my exclusive code: $inviteCode\n'
//           '💎 Unlock premium discounts and rewards!\n\n'
//           '🎯 Limited time offer - Transform your journey!';
//       Share.share(shareText);
//       HapticFeedback.mediumImpact();
//     }
//   }

//   bool _isValidCode() {
//     return inviteCode != 'Loading...' && inviteCode.isNotEmpty;
//   }

//   void _showQuantumSnackBar(String message, bool isSuccess) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Container(
//           padding: EdgeInsets.symmetric(vertical: 4),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   isSuccess ? Icons.auto_awesome : Icons.warning_amber,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   message,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         backgroundColor: isSuccess ? Color(0xFF8A2BE2) : Color(0xFFFF6B35),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         margin: EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;

//     // Choose one of these revolutionary designs:
//     return _buildHolographicDesign(context, isTablet); // Style 1: Holographic
//     // return _buildQuantumDesign(context, isTablet); // Style 2: Quantum
//     // return _buildCrystallineDesign(context, isTablet); // Style 3: Crystalline
//     // return _buildBioticDesign(context, isTablet); // Style 4: Biotic
//     // return _buildCosmicDesign(context, isTablet); // Style 5: Cosmic
//   }

//   // Style 1: Holographic Design (Default)
//   Widget _buildHolographicDesign(BuildContext context, bool isTablet) {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([_morphController, _particleController]),
//         builder: (context, child) {
//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFF0F0C29),
//                   Color(0xFF24243e),
//                   Color(0xFF302B63),
//                 ],
//                 transform: GradientRotation(_morphAnimation.value * 0.5),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Holographic particles
//                 ..._buildHolographicParticles(),
                
//                 SafeArea(
//                   child: Column(
//                     children: [
//                       _buildHolographicAppBar(context, isTablet),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           physics: BouncingScrollPhysics(),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: isTablet ? 40 : 24,
//                             vertical: 20,
//                           ),
//                           child: Column(
//                             children: [
//                               SizedBox(height: 20),
//                               _buildHolographicHeroSection(context, isTablet),
//                               SizedBox(height: 40),
//                               _buildHolographicCodeCard(context, isTablet),
//                               SizedBox(height: 40),
//                               _buildHolographicActions(context, isTablet),
//                               SizedBox(height: 40),
//                               // _buildHolographicBenefits(context, isTablet),
//                               // SizedBox(height: 40),
//                             ],
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

//   Widget _buildHolographicAppBar(BuildContext context, bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 16),
//       child: Row(
//         children: [
//           AnimatedBuilder(
//             animation: _pulseController,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _pulseAnimation.value * 0.1 + 0.9,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.cyan.withOpacity(0.3),
//                         Colors.purple.withOpacity(0.1),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.cyan.withOpacity(0.4),
//                       width: 1,
//                     ),
//                   ),
//                   child: IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Icon(
//                       Icons.arrow_back_ios_new,
//                       color: Colors.cyan,
//                       size: isTablet ? 24 : 20,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ShaderMask(
//                   shaderCallback: (bounds) => LinearGradient(
//                     colors: [Colors.cyan, Colors.purple, Colors.pink],
//                   ).createShader(bounds),
//                   child: Text(
//                     'Holographic Referrals',
//                     style: TextStyle(
//                       fontSize: isTablet ? 24 : 20,
//                       fontWeight: FontWeight.w800,
//                       color: Colors.white,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Project future rewards',
//                   style: TextStyle(
//                     fontSize: isTablet ? 16 : 14,
//                     color: Colors.cyan.withOpacity(0.8),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHolographicHeroSection(BuildContext context, bool isTablet) {
//     return Column(
//       children: [
//         AnimatedBuilder(
//           animation: _rotateController,
//           builder: (context, child) {
//             return Transform.rotate(
//               angle: _rotateAnimation.value,
//               child: Container(
//                 width: isTablet ? 200 : 160,
//                 height: isTablet ? 200 : 160,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: SweepGradient(
//                     colors: [
//                       Colors.cyan,
//                       Colors.purple,
//                       Colors.pink,
//                       Colors.orange,
//                       Colors.cyan,
//                     ],
//                   ),
//                 ),
//                 child: Container(
//                   margin: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFF1A1A2E),
//                   ),
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.auto_awesome,
//                           size: isTablet ? 60 : 50,
//                           color: Colors.cyan,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'REFER',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: isTablet ? 18 : 16,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(height: 30),
//         ShaderMask(
//           shaderCallback: (bounds) => LinearGradient(
//             colors: [Colors.cyan, Colors.purple, Colors.pink],
//           ).createShader(bounds),
//           child: Text(
//             'Activate Your Referal',
//             style: TextStyle(
//               fontSize: isTablet ? 28 : 24,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               letterSpacing: 1,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         SizedBox(height: 16),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.cyan.withOpacity(0.2),
//                 Colors.purple.withOpacity(0.2),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//               color: Colors.cyan.withOpacity(0.4),
//               width: 1,
//             ),
//           ),
//           child: Text(
//             'Transcend reality through referrals',
//             style: TextStyle(
//               fontSize: isTablet ? 16 : 14,
//               color: Colors.white.withOpacity(0.9),
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHolographicCodeCard(BuildContext context, bool isTablet) {
//     return AnimatedBuilder(
//       animation: _waveController,
//       builder: (context, child) {
//         return Container(
//           padding: EdgeInsets.all(isTablet ? 32 : 24),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.cyan.withOpacity(0.1),
//                 Colors.purple.withOpacity(0.1),
//                 Colors.pink.withOpacity(0.1),
//               ],
//               transform: GradientRotation(_waveAnimation.value * math.pi),
//             ),
//             borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
//             border: Border.all(
//               color: _colorAnimation.value?.withOpacity(0.4) ?? Colors.cyan.withOpacity(0.4),
//               width: 2,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (_colorAnimation.value ?? Colors.cyan).withOpacity(0.3),
//                 blurRadius: 30,
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.qr_code_2,
//                     color: Colors.cyan,
//                     size: isTablet ? 32 : 28,
//                   ),
//                   SizedBox(width: 12),
//                   Text(
//                     'QUANTUM CODE',
//                     style: TextStyle(
//                       fontSize: isTablet ? 18 : 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               if (_isLoading) ...[
//                 Container(
//                   width: 60,
//                   height: 60,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 3,
//                     valueColor: AlwaysStoppedAnimation(Colors.cyan),
//                   ),
//                 ),
//               ] else ...[
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF000014),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.cyan.withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   child: Text(
//                     inviteCode,
//                     style: TextStyle(
//                       fontSize: isTablet ? 28 : 24,
//                       color: Colors.cyan,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 4,
//                       fontFamily: 'monospace',
//                       shadows: [
//                         Shadow(
//                           color: Colors.cyan,
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHolographicActions(BuildContext context, bool isTablet) {
//     return Column(
//       children: [
//         _buildHolographicButton(
//           context,
//           onPressed: _shareInviteCode,
//           icon: Icons.share_rounded,
//           label: 'TRANSMIT CODE',
//           gradient: [Colors.cyan, Colors.blue],
//           isTablet: isTablet,
//         ),
//         SizedBox(height: 16),
//         _buildHolographicButton(
//           context,
//           onPressed: _copyInviteCode,
//           icon: Icons.copy_rounded,
//           label: 'CLONE CODE',
//           gradient: [Colors.purple, Colors.pink],
//           isTablet: isTablet,
//         ),
//       ],
//     );
//   }

//   Widget _buildHolographicButton(
//     BuildContext context, {
//     required VoidCallback onPressed,
//     required IconData icon,
//     required String label,
//     required List<Color> gradient,
//     required bool isTablet,
//   }) {
//     return AnimatedBuilder(
//       animation: _pulseController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.02,
//           child: Container(
//             width: double.infinity,
//             height: isTablet ? 64 : 56,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: gradient),
//               borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
//               boxShadow: [
//                 BoxShadow(
//                   color: gradient.first.withOpacity(0.4),
//                   blurRadius: 20,
//                   offset: Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: onPressed,
//                 borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         icon,
//                         color: Colors.white,
//                         size: isTablet ? 24 : 22,
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         label,
//                         style: TextStyle(
//                           fontSize: isTablet ? 18 : 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHolographicBenefits(BuildContext context, bool isTablet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ShaderMask(
//           shaderCallback: (bounds) => LinearGradient(
//             colors: [Colors.cyan, Colors.purple],
//           ).createShader(bounds),
//           child: Text(
//             'QUANTUM BENEFITS',
//             style: TextStyle(
//               fontSize: isTablet ? 22 : 18,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//               letterSpacing: 1.5,
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//         _buildHolographicBenefit(
//           context,
//           '∞',
//           'INFINITE REWARDS',
//           'Unlimited earning potential through quantum referrals',
//           Colors.cyan,
//           isTablet,
//         ),
//         SizedBox(height: 16),
//         _buildHolographicBenefit(
//           context,
//           '⚡',
//           'INSTANT ACTIVATION',
//           'Immediate rewards upon successful friend registration',
//           Colors.purple,
//           isTablet,
//         ),
//         SizedBox(height: 16),
//         _buildHolographicBenefit(
//           context,
//           '🌌',
//           'COSMIC MULTIPLIERS',
//           'Exponential growth with every new member',
//           Colors.pink,
//           isTablet,
//         ),
//       ],
//     );
//   }

//   Widget _buildHolographicBenefit(
//     BuildContext context,
//     String symbol,
//     String title,
//     String description,
//     Color color,
//     bool isTablet,
//   ) {
//     return AnimatedBuilder(
//       animation: _morphController,
//       builder: (context, child) {
//         return Container(
//           padding: EdgeInsets.all(isTablet ? 20 : 16),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 color.withOpacity(0.1),
//                 Colors.transparent,
//               ],
//             ),
//             borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
//             border: Border.all(
//               color: color.withOpacity(0.3),
//               width: 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: isTablet ? 60 : 50,
//                 height: isTablet ? 60 : 50,
//                 decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     colors: [color, color.withOpacity(0.3)],
//                   ),
//                   borderRadius: BorderRadius.circular(isTablet ? 15 : 12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: color.withOpacity(0.4),
//                       blurRadius: 15,
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     symbol,
//                     style: TextStyle(
//                       fontSize: isTablet ? 24 : 20,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
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
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       description,
//                       style: TextStyle(
//                         fontSize: isTablet ? 14 : 12,
//                         color: Colors.white.withOpacity(0.7),
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   List<Widget> _buildHolographicParticles() {
//     return List.generate(25, (index) {
//       return AnimatedBuilder(
//         animation: _particleController,
//         builder: (context, child) {
//           final offset = _particleAnimation.value * 2 * math.pi + index * 0.8;
//           final size = MediaQuery.of(context).size;
//           final x = (50 + index * 25.0 + 100 * math.sin(offset)) % size.width;
//           final y = (100 + index * 30.0 + 80 * math.cos(offset * 0.7)) % size.height;
//           final particleSize = 3.0 + (index % 4);
          
//           return Positioned(
//             left: x,
//             top: y,
//             child: Container(
//               width: particleSize,
//               height: particleSize,
//               decoration: BoxDecoration(
//                 color: [Colors.cyan, Colors.purple, Colors.pink][index % 3]
//                     .withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(particleSize / 2),
//                 boxShadow: [
//                   BoxShadow(
//                     color: [Colors.cyan, Colors.purple, Colors.pink][index % 3]
//                         .withOpacity(0.8),
//                     blurRadius: 8,
//                     spreadRadius: 0,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   // Style 2: Quantum Design
//   Widget _buildQuantumDesign(BuildContext context, bool isTablet) {
//     return Scaffold(
//       backgroundColor: Color(0xFF000008),
//       body: AnimatedBuilder(
//         animation: Listenable.merge([_morphController, _waveController]),
//         builder: (context, child) {
//           return Stack(
//             children: [
//               // Quantum field background
//               CustomPaint(
//                 painter: QuantumFieldPainter(_morphAnimation.value),
//                 size: Size(double.infinity, double.infinity),
//               ),
              
//               SafeArea(
//                 child: Column(
//                   children: [
//                     _buildQuantumAppBar(context, isTablet),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         physics: BouncingScrollPhysics(),
//                         padding: EdgeInsets.all(isTablet ? 32 : 24),
//                         child: Column(
//                           children: [
//                             _buildQuantumCore(context, isTablet),
//                             SizedBox(height: 40),
//                             _buildQuantumCodeMatrix(context, isTablet),
//                             SizedBox(height: 40),
//                             _buildQuantumActions(context, isTablet),
//                           ],
//                         ),
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

//   Widget _buildQuantumAppBar(BuildContext context, bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 16),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFF00F5FF).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFF00F5FF), width: 1),
//             ),
//             child: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: Icon(Icons.arrow_back, color: Color(0xFF00F5FF)),
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               'QUANTUM REFERRAL PROTOCOL',
//               style: TextStyle(
//                 fontSize: isTablet ? 20 : 18,
//                 fontWeight: FontWeight.w800,
//                 color: Color(0xFF00F5FF),
//                 letterSpacing: 2,
//                 fontFamily: 'monospace',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuantumCore(BuildContext context, bool isTablet) {
//     return AnimatedBuilder(
//       animation: _rotateController,
//       builder: (context, child) {
//         return Column(
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer ring
//                 Transform.rotate(
//                   angle: _rotateAnimation.value,
//                   child: Container(
//                     width: isTablet ? 180 : 150,
//                     height: isTablet ? 180 : 150,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Color(0xFF00F5FF), width: 2),
//                     ),
//                   ),
//                 ),
//                 // Inner ring
//                 Transform.rotate(
//                   angle: -_rotateAnimation.value * 1.5,
//                   child: Container(
//                     width: isTablet ? 120 : 100,
//                     height: isTablet ? 120 : 100,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Color(0xFFFF1493), width: 2),
//                     ),
//                   ),
//                 ),
//                 // Core
//                 Container(
//                   width: isTablet ? 80 : 60,
//                   height: isTablet ? 80 : 60,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [Color(0xFF00F5FF), Color(0xFF000008)],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xFF00F5FF),
//                         blurRadius: 30,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.psychology,
//                       color: Colors.white,
//                       size: isTablet ? 32 : 24,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             Text(
//               'QUANTUM ENTANGLEMENT ACTIVE',
//               style: TextStyle(
//                 fontSize: isTablet ? 18 : 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF00F5FF),
//                 letterSpacing: 1.5,
//                 fontFamily: 'monospace',
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildQuantumCodeMatrix(BuildContext context, bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 20),
//       decoration: BoxDecoration(
//         color: Color(0xFF001122).withOpacity(0.8),
//         borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
//         border: Border.all(color: Color(0xFF00F5FF), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF00F5FF).withOpacity(0.3),
//             blurRadius: 20,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             '< QUANTUM_CODE />',
//             style: TextStyle(
//               fontSize: isTablet ? 16 : 14,
//               color: Color(0xFF00F5FF),
//               fontFamily: 'monospace',
//               letterSpacing: 1,
//             ),
//           ),
//           SizedBox(height: 16),
//           if (_isLoading) ...[
//             Text(
//               'INITIALIZING QUANTUM STATE...',
//               style: TextStyle(
//                 fontSize: isTablet ? 14 : 12,
//                 color: Color(0xFFFF1493),
//                 fontFamily: 'monospace',
//               ),
//             ),
//           ] else ...[
//             Container(
//               padding: EdgeInsets.all(isTablet ? 16 : 12),
//               decoration: BoxDecoration(
//                 color: Color(0xFF000008),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Color(0xFF00F5FF).withOpacity(0.3)),
//               ),
//               child: Text(
//                 'ID: $inviteCode',
//                 style: TextStyle(
//                   fontSize: isTablet ? 24 : 20,
//                   color: Color(0xFF00F5FF),
//                   fontFamily: 'monospace',
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 3,
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildQuantumActions(BuildContext context, bool isTablet) {
//     return Column(
//       children: [
//         _buildQuantumButton(
//           context,
//           onPressed: _shareInviteCode,
//           label: 'TRANSMIT_QUANTUM_DATA()',
//           color: Color(0xFF00F5FF),
//           isTablet: isTablet,
//         ),
//         SizedBox(height: 16),
//         _buildQuantumButton(
//           context,
//           onPressed: _copyInviteCode,
//           label: 'CLONE_TO_BUFFER()',
//           color: Color(0xFFFF1493),
//           isTablet: isTablet,
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantumButton(
//     BuildContext context, {
//     required VoidCallback onPressed,
//     required String label,
//     required Color color,
//     required bool isTablet,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: isTablet ? 60 : 50,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color, width: 2),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(8),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: isTablet ? 16 : 14,
//                 color: color,
//                 fontFamily: 'monospace',
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Style 3: Crystalline Design
//   Widget _buildCrystallineDesign(BuildContext context, bool isTablet) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF1E3C72),
//               Color(0xFF2A5298),
//               Color(0xFF1E3C72),
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Crystalline patterns
//             ..._buildCrystallineElements(),
            
//             SafeArea(
//               child: Column(
//                 children: [
//                   _buildCrystallineAppBar(context, isTablet),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       physics: BouncingScrollPhysics(),
//                       padding: EdgeInsets.all(isTablet ? 32 : 24),
//                       child: Column(
//                         children: [
//                           _buildCrystallineGem(context, isTablet),
//                           SizedBox(height: 40),
//                           _buildCrystallineCodeCrystal(context, isTablet),
//                           SizedBox(height: 40),
//                           _buildCrystallineActions(context, isTablet),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]
//                 ),
//               ),
            
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCrystallineAppBar(BuildContext context, bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 24 : 16),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.white.withOpacity(0.2), Colors.transparent],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.white.withOpacity(0.3)),
//             ),
//             child: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Crystal Referrals',
//                   style: TextStyle(
//                     fontSize: isTablet ? 22 : 20,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   'Forge your network',
//                   style: TextStyle(
//                     fontSize: isTablet ? 14 : 12,
//                     color: Colors.white.withOpacity(0.8),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCrystallineGem(BuildContext context, bool isTablet) {
//     return AnimatedBuilder(
//       animation: _rotateController,
//       builder: (context, child) {
//         return Transform.rotate(
//           angle: _rotateAnimation.value * 0.1,
//           child: Container(
//             width: isTablet ? 160 : 140,
//             height: isTablet ? 160 : 140,
//             child: CustomPaint(
//               painter: CrystalPainter(_morphAnimation.value),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.diamond,
//                       size: isTablet ? 50 : 40,
//                       color: Colors.white,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'REFER',
//                       style: TextStyle(
//                         fontSize: isTablet ? 16 : 14,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCrystallineCodeCrystal(BuildContext context, bool isTablet) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 28 : 24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.15),
//             Colors.white.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.1),
//             blurRadius: 30,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             '💎 CRYSTAL CODE 💎',
//             style: TextStyle(
//               fontSize: isTablet ? 18 : 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//               letterSpacing: 1,
//             ),
//           ),
//           SizedBox(height: 20),
//           if (_isLoading) ...[
//             Text(
//               'Forging crystal...',
//               style: TextStyle(
//                 fontSize: isTablet ? 14 : 12,
//                 color: Colors.white.withOpacity(0.8),
//               ),
//             ),
//           ] else ...[
//             Container(
//               padding: EdgeInsets.all(isTablet ? 20 : 16),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.white.withOpacity(0.2)),
//               ),
//               child: Text(
//                 inviteCode,
//                 style: TextStyle(
//                   fontSize: isTablet ? 26 : 22,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.white,
//                   letterSpacing: 3,
//                   shadows: [
//                     Shadow(
//                       color: Colors.white.withOpacity(0.5),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildCrystallineActions(BuildContext context, bool isTablet) {
//     return Column(
//       children: [
//         _buildCrystallineButton(
//           context,
//           onPressed: _shareInviteCode,
//           icon: Icons.share,
//           label: 'TRANSMIT CRYSTAL',
//           isTablet: isTablet,
//         ),
//         SizedBox(height: 16),
//         _buildCrystallineButton(
//           context,
//           onPressed: _copyInviteCode,
//           icon: Icons.copy,
//           label: 'REPLICATE CRYSTAL',
//           isTablet: isTablet,
//         ),
//       ],
//     );
//   }

//   Widget _buildCrystallineButton(
//     BuildContext context, {
//     required VoidCallback onPressed,
//     required IconData icon,
//     required String label,
//     required bool isTablet,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: isTablet ? 60 : 50,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.2),
//             Colors.white.withOpacity(0.1),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(16),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, color: Colors.white, size: isTablet ? 24 : 20),
//                 SizedBox(width: 12),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: isTablet ? 16 : 14,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildCrystallineElements() {
//     return List.generate(12, (index) {
//       return AnimatedBuilder(
//         animation: _morphController,
//         builder: (context, child) {
//           final size = MediaQuery.of(context).size;
//           final x = (index * 60.0) % size.width;
//           final y = (index * 80.0 + _morphAnimation.value * 50) % size.height;
          
//           return Positioned(
//             left: x,
//             top: y,
//             child: Transform.rotate(
//               angle: _morphAnimation.value * math.pi + index,
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// class QuantumFieldPainter extends CustomPainter {
//   final double animationValue;
  
//   QuantumFieldPainter(this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Color(0xFF00F5FF).withOpacity(0.3)
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     final rows = 20;
//     final cols = 15;
//     final cellWidth = size.width / cols;
//     final cellHeight = size.height / rows;

//     for (int i = 0; i < rows; i++) {
//       for (int j = 0; j < cols; j++) {
//         final x = j * cellWidth;
//         final y = i * cellHeight + math.sin(animationValue * 2 * math.pi + j * 0.5) * 10;
        
//         if ((i + j) % 3 == 0) {
//           canvas.drawCircle(
//             Offset(x, y),
//             3 + math.sin(animationValue * 2 * math.pi + i + j) * 2,
//             paint,
//           );
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class CrystalPainter extends CustomPainter {
//   final double animationValue;
  
//   CrystalPainter(this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.3)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2 - 20;

//     // Draw hexagonal crystal
//     final path = Path();
//     for (int i = 0; i < 6; i++) {
//       final angle = i * math.pi / 3 + animationValue * math.pi;
//       final x = center.dx + radius * math.cos(angle);
//       final y = center.dy + radius * math.sin(angle);
      
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();
    
//     canvas.drawPath(path, paint);
    
//     // Inner crystal pattern
//     paint.color = Colors.white.withOpacity(0.2);
//     canvas.drawCircle(center, radius * 0.6, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }































import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  String inviteCode = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      final code = await StorageHelper.getCode();
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (code != null) {
        setState(() {
          inviteCode = code;
          _isLoading = false;
        });
      } else {
        setState(() {
          inviteCode = 'INVITE2024';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        inviteCode = 'REFER2024';
        _isLoading = false;
      });
    }
  }

  void _copyInviteCode() {
    if (_isValidCode()) {
      Clipboard.setData(ClipboardData(text: inviteCode));
      _showSnackBar('Referral code copied to clipboard!', true);
    }
  }

  void _shareInviteCode() {
    if (_isValidCode()) {
      final String shareText = 
          'Join the future of mobility with VSD!\n\n'
          'Use my exclusive code: $inviteCode\n'
          'Unlock premium discounts and rewards!\n\n'
          'Limited time offer - Transform your journey!';
      Share.share(shareText);
    }
  }

  bool _isValidCode() {
    return inviteCode != 'Loading...' && inviteCode.isNotEmpty;
  }

  void _showSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
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
        title: const Text('Refer & Earn'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 20,
          vertical: 24,
        ),
        child: Column(
          children: [
            _buildHeaderSection(theme, colorScheme, isTablet),
            const SizedBox(height: 32),
            _buildReferralCard(theme, colorScheme, isTablet),
            const SizedBox(height: 32),
            _buildActionButtons(theme, colorScheme, isTablet),
            const SizedBox(height: 40),
            _buildBenefitsSection(theme, colorScheme, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Column(
      children: [
        Container(
          width: isTablet ? 120 : 100,
          height: isTablet ? 120 : 100,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.people_alt_rounded,
            size: isTablet ? 50 : 40,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Refer Your Friends',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your referral code and earn rewards when your friends join',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReferralCard(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.confirmation_number_rounded,
                color: colorScheme.primary,
                size: isTablet ? 24 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Referral Code',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoading) ...[
            SizedBox(
              height: isTablet ? 60 : 50,
              child: Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 20,
                vertical: isTablet ? 20 : 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    inviteCode,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share this code with your friends',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: isTablet ? 56 : 50,
          child: ElevatedButton(
            onPressed: _shareInviteCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share_rounded,
                  size: isTablet ? 20 : 18,
                ),
                const SizedBox(width: 12),
                Text(
                  'Share Referral Code',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: isTablet ? 56 : 50,
          child: OutlinedButton(
            onPressed: _copyInviteCode,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copy_rounded,
                  size: isTablet ? 20 : 18,
                ),
                const SizedBox(width: 12),
                Text(
                  'Copy Code',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(ThemeData theme, ColorScheme colorScheme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral Benefits',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'What you get when your friends join',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 20),
        _buildBenefitItem(
          theme,
          colorScheme,
          icon: Icons.discount_rounded,
          title: 'Discount Rewards',
          description: 'Get instant discounts on your next bookings',
          isTablet: isTablet,
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(
          theme,
          colorScheme,
          icon: Icons.celebration_rounded,
          title: 'Bonus Credits',
          description: 'Earn bonus credits for every successful referral',
          isTablet: isTablet,
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(
          theme,
          colorScheme,
          icon: Icons.rocket_launch_rounded,
          title: 'Priority Support',
          description: 'Get priority customer support as a valued referrer',
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    ThemeData theme,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String description,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 50 : 44,
            height: isTablet ? 50 : 44,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: isTablet ? 24 : 20,
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
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}