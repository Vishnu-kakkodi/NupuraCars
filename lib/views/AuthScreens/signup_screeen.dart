// import 'package:drive_car/providers/AuthProvider/auth_provider.dart';
// import 'package:drive_car/views/AuthScreens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _referralCodeController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _acceptTerms = false;
//   int _currentStep = 0;
  
//   late AnimationController _animationController;
//   late AnimationController _stepController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _progressAnimation;

//   final AuthProvider _authProvider = AuthProvider();

//   // New Color Scheme - matching other screens
//   static const Color _primaryColor = Color(0xFF00BFA5);
//   static const Color _secondaryColor = Color(0xFF26A69A);
//   static const Color _accentColor = Color(0xFFFF6B35);
//   static const Color _backgroundGradientStart = Color(0xFF004D47);
//   static const Color _backgroundGradientEnd = Color(0xFF00695C);
//   static const Color _cardColor = Color(0xFFF8F9FA);
//   static const Color _textPrimary = Color(0xFF2E3440);
//   static const Color _textSecondary = Color(0xFF5E6772);

//   @override
//   void initState() {
//     super.initState();
    
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
    
//     _stepController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//     ));
    
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
//     ));

//     _progressAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _stepController,
//       curve: Curves.easeInOut,
//     ));
    
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _referralCodeController.dispose();
//     _animationController.dispose();
//     _stepController.dispose();
//     super.dispose();
//   }

//   // Name validation - only alphabets and spaces
//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your name';
//     }
//     if (value.trim().length < 2) {
//       return 'Name must be at least 2 characters long';
//     }
//     if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//       return 'Name can only contain letters and spaces';
//     }
//     return null;
//   }

//   // Mobile number validation - exactly 10 digits
//   String? _validateMobile(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your mobile number';
//     }
//     if (value.length != 10) {
//       return 'Mobile number must be exactly 10 digits';
//     }
//     if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//       return 'Mobile number can only contain digits';
//     }
//     if (!RegExp(r'^[6-9]').hasMatch(value)) {
//       return 'Mobile number must start with 6, 7, 8, or 9';
//     }
//     return null;
//   }

//   // Email validation - proper email format
//   String? _validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter your email';
//     }

//     final emailRegex = RegExp(
//       r'^[a-zA-Z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );

//     if (!emailRegex.hasMatch(value.trim())) {
//       return 'Please enter a valid email (must start with a letter)';
//     }
//     return null;
//   }

//   // Referral code validation - only alphanumeric (optional)
//   String? _validateReferralCode(String? value) {
//     if (value == null || value.isEmpty) {
//       return null; // Optional field
//     }
//     if (value.length < 3) {
//       return 'Referral code must be at least 3 characters long';
//     }
//     if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
//       return 'Referral code can only contain letters and numbers';
//     }
//     return null;
//   }

//   Future<void> _handleSignup() async {
//     if (!_formKey.currentState!.validate()) {
//       HapticFeedback.heavyImpact();
//       return;
//     }

//     HapticFeedback.mediumImpact();
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final userId = await _authProvider.registerUser(
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         mobile: _mobileController.text.trim(),
//         referralCode: _referralCodeController.text.trim().isEmpty
//             ? null
//             : _referralCodeController.text.trim(),
//       );

//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });

//         if (userId == true) {
//           HapticFeedback.lightImpact();
//           _showSuccessSnackBar('Account created successfully!');
//           await Future.delayed(const Duration(milliseconds: 800));
//           Navigator.pushReplacement(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) =>
//                   const LoginScreen(),
//               transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                 return SlideTransition(
//                   position: animation.drive(
//                     Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
//                         .chain(CurveTween(curve: Curves.easeInOut)),
//                   ),
//                   child: child,
//                 );
//               },
//               transitionDuration: const Duration(milliseconds: 400),
//             ),
//           );
//         } else {
//           HapticFeedback.heavyImpact();
//           _showErrorSnackBar('Registration failed. Please try again.');
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         HapticFeedback.heavyImpact();
//         _showErrorSnackBar('Error: ${e.toString()}');
//       }
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: _accentColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: "Dismiss",
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: _primaryColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required String? Function(String?) validator,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? inputFormatters,
//     TextCapitalization? textCapitalization,
//     int? maxLength,
//   }) {
//     final bool hasError = _formKey.currentState != null &&
//         _formKey.currentState!.validate() == false &&
//         validator(controller.text) != null;
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: _textPrimary,
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: hasError 
//                   ? _accentColor 
//                   : controller.text.isNotEmpty
//                       ? _primaryColor.withOpacity(0.5)
//                       : Colors.grey[300]!,
//               width: hasError ? 2 : 1.5,
//             ),
//             boxShadow: [
//               if (controller.text.isNotEmpty || hasError)
//                 BoxShadow(
//                   color: (hasError ? _accentColor : _primaryColor).withOpacity(0.1),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//             ],
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             inputFormatters: inputFormatters,
//             textCapitalization: textCapitalization ?? TextCapitalization.none,
//             maxLength: maxLength,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: _textPrimary,
//               letterSpacing: 0.5,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: _textSecondary.withOpacity(0.6),
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//               prefixIcon: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Icon(
//                   icon,
//                   color: controller.text.isNotEmpty ? _primaryColor : _textSecondary,
//                   size: 22,
//                 ),
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 20,
//               ),
//               counterText: "",
//             ),
//             validator: validator,
//             onChanged: (value) {
//               setState(() {}); // Update UI for visual feedback
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProgressIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_primaryColor.withOpacity(0.1), _secondaryColor.withOpacity(0.1)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _primaryColor.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Account Setup",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: _textPrimary,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [_primaryColor, _secondaryColor],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   "Almost Done!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: AnimatedBuilder(
//               animation: _progressAnimation,
//               builder: (context, child) {
//                 return Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [_primaryColor, _secondaryColor],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     borderRadius: BorderRadius.circular(3),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;
//     final isTablet = screenWidth > 600;
//     final horizontalPadding = isTablet ? screenWidth * 0.2 : 20.0;

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [_backgroundGradientStart, _backgroundGradientEnd],
//             stops: [0.0, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: screenHeight - mediaQuery.padding.top,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: Column(
//                       children: [
//                         SizedBox(height: screenHeight * 0.05),
                        
//                         // Header Section
//                         _buildHeaderSection(screenHeight, isTablet),
                        
//                         SizedBox(height: screenHeight * 0.04),
                        
//                         // Form Section
//                         _buildFormSection(screenHeight, screenWidth, isTablet),
                        
//                         SizedBox(height: screenHeight * 0.04),
                        
//                         // Sign In Section
//                         _buildSignInSection(),
                        
//                         SizedBox(height: screenHeight * 0.03),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(double screenHeight, bool isTablet) {
//     return Column(
//       children: [
//         // Back Button and Title Row
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.lightImpact();
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 15,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 22,
//                 ),
//               ),
//             ),
//             // Expanded(
//             //   child: Center(
//             //     child: Text(
//             //       "Join Us",
//             //       style: TextStyle(
//             //         fontSize: isTablet ? 24 : 20,
//             //         fontWeight: FontWeight.bold,
//             //         color: Colors.white,
//             //         letterSpacing: 0.5,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(width: 52), // Balance the back button
//           ],
//         ),
        
//         // SizedBox(height: screenHeight * 0.04),
        
//         // // Welcome Icon
//         // Container(
//         //   height: 100,
//         //   width: 100,
//         //   decoration: BoxDecoration(
//         //     gradient: const LinearGradient(
//         //       colors: [_primaryColor, _secondaryColor],
//         //       begin: Alignment.topLeft,
//         //       end: Alignment.bottomRight,
//         //     ),
//         //     borderRadius: BorderRadius.circular(25),
//         //     boxShadow: [
//         //       BoxShadow(
//         //         color: _primaryColor.withOpacity(0.4),
//         //         blurRadius: 25,
//         //         offset: const Offset(0, 15),
//         //         spreadRadius: 2,
//         //       ),
//         //     ],
//         //   ),
//         //   child: const Icon(
//         //     Icons.person_add_outlined,
//         //     color: Colors.white,
//         //     size: 45,
//         //   ),
//         // ),
        
//         // SizedBox(height: screenHeight * 0.03),
        
//         // // Title and Description
//         Text(
//           "Create Your Account",
//           style: TextStyle(
//             fontSize: isTablet ? 30 : 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             letterSpacing: 0.8,
//           ),
//         ),
        
//         // SizedBox(height: screenHeight * 0.015),
        
//         // Text(
//         //   "Fill in your details to get started on your journey",
//         //   textAlign: TextAlign.center,
//         //   style: TextStyle(
//         //     fontSize: isTablet ? 18 : 16,
//         //     color: Colors.white.withOpacity(0.9),
//         //     fontWeight: FontWeight.w400,
//         //     height: 1.3,
//         //   ),
//         // ),
//       ],
//     );
//   }

//   Widget _buildFormSection(double screenHeight, double screenWidth, bool isTablet) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(28),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 30,
//             offset: const Offset(0, 15),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             // Form Header
//             Container(
//               width: 50,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: _primaryColor,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
            
//             const SizedBox(height: 20),
            
//             Text(
//               "Personal Information",
//               style: TextStyle(
//                 fontSize: isTablet ? 22 : 20,
//                 fontWeight: FontWeight.bold,
//                 color: _textPrimary,
//                 letterSpacing: 0.5,
//               ),
//             ),
            
//             const SizedBox(height: 8),
            
//             Text(
//               "Please provide your details below",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: _textSecondary,
//               ),
//             ),

//             // const SizedBox(height: 32),

//             // Progress Indicator
//             // _buildProgressIndicator(),

//             const SizedBox(height: 32),

//             // Name Field
//             _buildInputField(
//               controller: _nameController,
//               label: "Full Name",
//               hint: "Enter your full name",
//               icon: Icons.person_outline_rounded,
//               validator: _validateName,
//               keyboardType: TextInputType.name,
//               textCapitalization: TextCapitalization.words,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // Mobile Field
//             _buildInputField(
//               controller: _mobileController,
//               label: "Mobile Number",
//               hint: "Enter your 10-digit mobile number",
//               icon: Icons.phone_outlined,
//               validator: _validateMobile,
//               keyboardType: TextInputType.phone,
//               maxLength: 10,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // Email Field
//             _buildInputField(
//               controller: _emailController,
//               label: "Email Address",
//               hint: "Enter your email address",
//               icon: Icons.email_outlined,
//               validator: _validateEmail,
//               keyboardType: TextInputType.emailAddress,
//             ),

//             const SizedBox(height: 24),

//             // Referral Code Field
//             _buildInputField(
//               controller: _referralCodeController,
//               label: "Referral Code (Optional)",
//               hint: "Enter referral code if available",
//               icon: Icons.card_giftcard_outlined,
//               validator: _validateReferralCode,
//               textCapitalization: TextCapitalization.characters,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
//               ],
//             ),

//             const SizedBox(height: 36),

//             // Sign Up Button
//             Container(
//               width: double.infinity,
//               height: 60,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [_primaryColor, _secondaryColor],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _primaryColor.withOpacity(0.4),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _handleSignup,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 3,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Text(
//                             "Creating Account...",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Create Account",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           const Icon(
//                             Icons.arrow_forward_rounded,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Terms Notice
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: _primaryColor.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 "By creating an account, you agree to our Terms of Service and Privacy Policy",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: _textSecondary,
//                   height: 1.4,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSignInSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Already have an account? ",
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.9),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.lightImpact();
//               Navigator.pushReplacement(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation, secondaryAnimation) =>
//                       const LoginScreen(),
//                   transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                     return SlideTransition(
//                       position: animation.drive(
//                         Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
//                             .chain(CurveTween(curve: Curves.easeInOut)),
//                       ),
//                       child: child,
//                     );
//                   },
//                   transitionDuration: const Duration(milliseconds: 300),
//                 ),
//               );
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: _accentColor,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _accentColor.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 "Sign In",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




























import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/views/AuthScreens/login_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _acceptTerms = false;
  int _currentStep = 0;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  late AnimationController _animationController;
  late AnimationController _stepController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  final AuthProvider _authProvider = AuthProvider();

  // New Color Scheme - matching other screens
  static const Color _primaryColor = Color(0xFF00BFA5);
  static const Color _secondaryColor = Color(0xFF26A69A);
  static const Color _accentColor = Color(0xFFFF6B35);
  static const Color _backgroundGradientStart = Color(0xFF004D47);
  static const Color _backgroundGradientEnd = Color(0xFF00695C);
  static const Color _cardColor = Color(0xFFF8F9FA);
  static const Color _textPrimary = Color(0xFF2E3440);
  static const Color _textSecondary = Color(0xFF5E6772);

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stepController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose();
    _animationController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  // Name validation - only alphabets and spaces
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Mobile number validation - exactly 10 digits
  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number can only contain digits';
    }
    if (!RegExp(r'^[6-9]').hasMatch(value)) {
      return 'Mobile number must start with 6, 7, 8, or 9';
    }
    return null;
  }

  // Email validation - proper email format
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email (must start with a letter)';
    }
    return null;
  }

  // Password validation - strong password requirements
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number & special character';
    }
    return null;
  }

  // Confirm password validation
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Referral code validation - only alphanumeric (optional)
  String? _validateReferralCode(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (value.length < 3) {
      return 'Referral code must be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Referral code can only contain letters and numbers';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await _authProvider.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim(),
        password: _passwordController.text.trim(),
        referralCode: _referralCodeController.text.trim().isEmpty
            ? null
            : _referralCodeController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (userId == true) {
          HapticFeedback.lightImpact();
          _showSuccessSnackBar('Account created successfully!');
          await Future.delayed(const Duration(milliseconds: 800));
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        } else {
          HapticFeedback.heavyImpact();
          _showErrorSnackBar('Registration failed. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        HapticFeedback.heavyImpact();
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: "Dismiss",
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization? textCapitalization,
    int? maxLength,
    bool obscureText = false,
    bool? isPasswordVisible,
    VoidCallback? togglePasswordVisibility,
  }) {
    final bool hasError = _formKey.currentState != null &&
        _formKey.currentState!.validate() == false &&
        validator(controller.text) != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError 
                  ? _accentColor 
                  : controller.text.isNotEmpty
                      ? _primaryColor.withOpacity(0.5)
                      : Colors.grey[300]!,
              width: hasError ? 2 : 1.5,
            ),
            boxShadow: [
              if (controller.text.isNotEmpty || hasError)
                BoxShadow(
                  color: (hasError ? _accentColor : _primaryColor).withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            maxLength: maxLength,
            obscureText: obscureText && !(isPasswordVisible ?? false),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: _textSecondary.withOpacity(0.6),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Container(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  icon,
                  color: controller.text.isNotEmpty ? _primaryColor : _textSecondary,
                  size: 22,
                ),
              ),
              suffixIcon: obscureText
                  ? GestureDetector(
                      onTap: togglePasswordVisibility,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          (isPasswordVisible ?? false)
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: _textSecondary,
                          size: 22,
                        ),
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              counterText: "",
            ),
            validator: validator,
            onChanged: (value) {
              setState(() {}); // Update UI for visual feedback
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor.withOpacity(0.1), _secondaryColor.withOpacity(0.1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Account Setup",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _secondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Almost Done!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.2 : 20.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_backgroundGradientStart, _backgroundGradientEnd],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - mediaQuery.padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        
                        // Header Section
                        _buildHeaderSection(screenHeight, isTablet),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Form Section
                        _buildFormSection(screenHeight, screenWidth, isTablet),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Sign In Section
                        _buildSignInSection(),
                        
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double screenHeight, bool isTablet) {
    return Column(
      children: [
        // Back Button and Title Row
        // Row(
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         HapticFeedback.lightImpact();
        //         Navigator.pop(context);
        //       },
        //       child: Container(
        //         padding: const EdgeInsets.all(14),
        //         decoration: BoxDecoration(
        //           color: Colors.white.withOpacity(0.2),
        //           borderRadius: BorderRadius.circular(16),
        //           border: Border.all(
        //             color: Colors.white.withOpacity(0.3),
        //             width: 1,
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.1),
        //               blurRadius: 15,
        //               offset: const Offset(0, 5),
        //             ),
        //           ],
        //         ),
        //         child: const Icon(
        //           Icons.arrow_back_ios_new,
        //           color: Colors.white,
        //           size: 22,
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 52), // Balance the back button
        //   ],
        // ),
        
        // Title
        Text(
          "Create Your Account",
          style: TextStyle(
            fontSize: isTablet ? 30 : 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(double screenHeight, double screenWidth, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Form Header
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              "Personal Information",
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
                letterSpacing: 0.5,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              "Please provide your details below",
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // Name Field
            _buildInputField(
              controller: _nameController,
              label: "Full Name",
              hint: "Enter your full name",
              icon: Icons.person_outline_rounded,
              validator: _validateName,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),

            const SizedBox(height: 24),

            // Mobile Field
            _buildInputField(
              controller: _mobileController,
              label: "Mobile Number",
              hint: "Enter your 10-digit mobile number",
              icon: Icons.phone_outlined,
              validator: _validateMobile,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),

            const SizedBox(height: 24),

            // Email Field
            _buildInputField(
              controller: _emailController,
              label: "Email Address",
              hint: "Enter your email address",
              icon: Icons.email_outlined,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 24),

            // Password Field
            _buildInputField(
              controller: _passwordController,
              label: "Password",
              hint: "Create a strong password",
              icon: Icons.lock_outline_rounded,
              validator: _validatePassword,
              obscureText: true,
              isPasswordVisible: _isPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 24),

            // Confirm Password Field
            _buildInputField(
              controller: _confirmPasswordController,
              label: "Confirm Password",
              hint: "Re-enter your password",
              icon: Icons.lock_reset_outlined,
              validator: _validateConfirmPassword,
              obscureText: true,
              isPasswordVisible: _isConfirmPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 24),

            // Referral Code Field
            _buildInputField(
              controller: _referralCodeController,
              label: "Referral Code (Optional)",
              hint: "Enter referral code if available",
              icon: Icons.card_giftcard_outlined,
              validator: _validateReferralCode,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
            ),

            const SizedBox(height: 36),

            // Sign Up Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "Creating Account...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Terms Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "By creating an account, you agree to our Terms of Service and Privacy Policy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondary,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}