// import 'package:drive_car/providers/AuthProvider/auth_provider.dart';
// import 'package:drive_car/views/MainScreen/main_navbar_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'dart:async';

// class OtpScreen extends StatefulWidget {
//   final String mobile;

//   const OtpScreen({super.key, required this.mobile});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen>
//     with SingleTickerProviderStateMixin {
//   final List<TextEditingController> _controllers = List.generate(
//     4,
//     (index) => TextEditingController(),
//   );

//   final List<FocusNode> _focusNodes = List.generate(
//     4,
//     (index) => FocusNode(),
//   );

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   Timer? _resendTimer;
//   int _resendCountdown = 30;
//   bool _canResend = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize animations
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
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
//       curve: Curves.easeOutCubic,
//     ));
    
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));

//     _animationController.forward();
//     _startResendTimer();

//     // Focus on first field initially
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNodes[0].requestFocus();
//     });
//   }

//   void _startResendTimer() {
//     _canResend = false;
//     _resendCountdown = 30;
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           if (_resendCountdown > 0) {
//             _resendCountdown--;
//           } else {
//             _canResend = true;
//             timer.cancel();
//           }
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     _animationController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }

//   String get otpCode {
//     return _controllers.map((controller) => controller.text).join();
//   }

//   bool get isOtpComplete {
//     return otpCode.length == 4 && otpCode.split('').every((char) => char.isNotEmpty);
//   }

//   void _onOtpChanged(String value, int index) {
//     if (value.isNotEmpty) {
//       // Move to next field
//       if (index < 3) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         // Last field, unfocus and auto-verify
//         _focusNodes[index].unfocus();
//         if (isOtpComplete) {
//           _verifyOtp();
//         }
//       }
//     }

//     setState(() {}); // Update UI for button state
//   }

//   void _onBackspace(String value, int index) {
//     if (value.isEmpty && index > 0) {
//       _controllers[index - 1].clear();
//       _focusNodes[index - 1].requestFocus();
//     }
//     setState(() {}); // Update UI for button state
//   }

//   Future<void> _verifyOtp() async {
//     if (!isOtpComplete || _isLoading) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final success = await authProvider.verifyOtp(otpCode);

//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });

//         if (success) {
//           _showSuccessSnackBar('OTP verified successfully!');
//           await Future.delayed(const Duration(milliseconds: 500));
// Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//   (Route<dynamic> route) => false, // This removes all previous routes
// );

//         } else {
//           _showErrorSnackBar('Invalid OTP. Please try again.');
//           _clearOtp();
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         _showErrorSnackBar('An error occurred. Please try again.');
//         _clearOtp();
//       }
//     }
//   }

//   void _clearOtp() {
//     for (var controller in _controllers) {
//       controller.clear();
//     }
//     _focusNodes[0].requestFocus();
//     setState(() {});
//   }

//   Future<void> _resendOtp() async {
//     if (!_canResend) return;

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final success = await authProvider.resendOtp(widget.mobile);

//       if (mounted) {
//         if (success) {
//           _showSuccessSnackBar('OTP sent successfully!');
//           _clearOtp();
//           _startResendTimer();
//         } else {
//           _showErrorSnackBar('Failed to resend OTP. Please try again.');
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('An error occurred. Please try again.');
//       }
//     }
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }

//   Widget _buildOtpField(int index) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;
    
//     // Calculate responsive sizes
//     final availableWidth = screenWidth - (isTablet ? screenWidth * 0.4 : 48.0) - 64; // Subtract padding
//     final fieldSize = (availableWidth / 4 - 16).clamp(45.0, isTablet ? 70.0 : 60.0); // Max field size with minimum
//     final spacing = ((availableWidth - (fieldSize * 4)) / 3).clamp(4.0, 12.0); // Dynamic spacing
    
//     return Container(
//       width: fieldSize,
//       height: fieldSize,
//       margin: EdgeInsets.symmetric(horizontal: spacing / 2),
//       decoration: BoxDecoration(
//         color: _controllers[index].text.isNotEmpty
//             ? const Color(0xFF6366F1).withOpacity(0.1)
//             : Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: _focusNodes[index].hasFocus
//               ? const Color(0xFF6366F1)
//               : _controllers[index].text.isNotEmpty
//                   ? const Color(0xFF6366F1).withOpacity(0.5)
//                   : Colors.grey[300]!,
//           width: 2,
//         ),
//       ),
//       child: TextField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         style: TextStyle(
//           fontSize: (fieldSize * 0.4).clamp(18.0, 28.0), // Responsive font size
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF1F2937),
//         ),
//         decoration: const InputDecoration(
//           counterText: "",
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.zero,
//         ),
//         onChanged: (value) => _onOtpChanged(value, index),
//         onTap: () {
//           // Select all text when tapped
//           _controllers[index].selection = TextSelection(
//             baseOffset: 0,
//             extentOffset: _controllers[index].text.length,
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;
//     final isTablet = screenWidth > 600;
//     final horizontalPadding = isTablet ? screenWidth * 0.2 : 24.0;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: screenHeight - mediaQuery.padding.top,
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: Column(
//                     children: [
//                       // Header Section
//                       Container(
//                         height: screenHeight * 0.25,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Back Button
//                             Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => Navigator.pop(context),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(12),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(12),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.1),
//                                           blurRadius: 10,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Icon(
//                                       Icons.arrow_back_ios_new,
//                                       color: Color(0xFF374151),
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 24),
//                             // Title
//                             Text(
//                               "Verify OTP",
//                               style: TextStyle(
//                                 fontSize: isTablet ? 32 : 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF1F2937),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "Enter the 4-digit code sent to",
//                               style: TextStyle(
//                                 fontSize: isTablet ? 18 : 16,
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "+91 ${widget.mobile}",
//                               style: TextStyle(
//                                 fontSize: isTablet ? 18 : 16,
//                                 color: const Color(0xFF6366F1),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // OTP Form Section
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(32),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(24),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 20,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             // Security Icon
//                             ScaleTransition(
//                               scale: _scaleAnimation,
//                               child: Container(
//                                 height: 80,
//                                 width: 80,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: const Color(0xFF6366F1).withOpacity(0.3),
//                                       blurRadius: 20,
//                                       offset: const Offset(0, 10),
//                                     ),
//                                   ],
//                                 ),
//                                 child: const Icon(
//                                   Icons.security,
//                                   color: Colors.white,
//                                   size: 40,
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(height: 32),

//                             // OTP Input Fields - FIXED RESPONSIVE LAYOUT
//                             LayoutBuilder(
//                               builder: (context, constraints) {
//                                 return Container(
//                                   width: constraints.maxWidth,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: List.generate(4, (index) => _buildOtpField(index)),
//                                   ),
//                                 );
//                               },
//                             ),

//                             const SizedBox(height: 32),

//                             // Timer and Resend Section
//                             if (!_canResend)
//                               Text(
//                                 "Resend code in ${_resendCountdown}s",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               )
//                             else
//                               GestureDetector(
//                                 onTap: _resendOtp,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 24,
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFF6366F1).withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.refresh,
//                                         color: const Color(0xFF6366F1),
//                                         size: 20,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         "Resend Code",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: const Color(0xFF6366F1),
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                             const SizedBox(height: 32),

//                             // Verify Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: ElevatedButton(
//                                 onPressed: (_isLoading || !isOtpComplete) ? null : _verifyOtp,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: isOtpComplete
//                                       ? const Color(0xFF6366F1)
//                                       : Colors.grey[300],
//                                   foregroundColor: Colors.white,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 child: _isLoading
//                                     ? const SizedBox(
//                                         height: 24,
//                                         width: 24,
//                                         child: CircularProgressIndicator(
//                                           color: Colors.white,
//                                           strokeWidth: 2.5,
//                                         ),
//                                       )
//                                     : Text(
//                                         "Verify & Continue",
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                           color: isOtpComplete 
//                                               ? Colors.white 
//                                               : Colors.grey[600],
//                                         ),
//                                       ),
//                               ),
//                             ),

//                             const SizedBox(height: 24),

//                             // Help Text
//                             Text(
//                               "Didn't receive the code? Check your SMS or try resending.",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                                 height: 1.4,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 32),

//                       // Security Notice
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.blue[200]!,
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.info_outline,
//                               color: Colors.blue[600],
//                               size: 20,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 "For your security, please don't share this OTP with anyone.",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.blue[800],
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: screenHeight * 0.02),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }













import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  Timer? _resendTimer;
  int _resendCountdown = 30;
  bool _canResend = false;
  bool _isLoading = false;

  // New Color Scheme - matching login screen
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
    
    // Initialize main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Initialize pulse animation for OTP fields
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _startResendTimer();

    // Focus on first field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
      _pulseController.repeat(reverse: true);
    });
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 30;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _animationController.dispose();
    _pulseController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  String get otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  bool get isOtpComplete {
    return otpCode.length == 4 && otpCode.split('').every((char) => char.isNotEmpty);
  }

  void _onOtpChanged(String value, int index) {
    HapticFeedback.lightImpact();
    
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus and auto-verify
        _focusNodes[index].unfocus();
        _pulseController.stop();
        if (isOtpComplete) {
          _verifyOtp();
        }
      }
    }

    setState(() {}); // Update UI for button state
  }

  void _onBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {}); // Update UI for button state
  }

  Future<void> _verifyOtp() async {
    if (!isOtpComplete || _isLoading) {
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyOtp(otpCode);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          HapticFeedback.lightImpact();
          _showSuccessSnackBar('OTP verified successfully!');
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MainNavigationScreen(),
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
            (Route<dynamic> route) => false,
          );
        } else {
          HapticFeedback.heavyImpact();
          _showErrorSnackBar('Invalid OTP. Please try again.');
          _clearOtp();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        HapticFeedback.heavyImpact();
        _showErrorSnackBar('An error occurred. Please try again.');
        _clearOtp();
      }
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    _pulseController.repeat(reverse: true);
    setState(() {});
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    HapticFeedback.lightImpact();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resendOtp(widget.mobile);

      if (mounted) {
        if (success) {
          _showSuccessSnackBar('OTP sent successfully!');
          _clearOtp();
          _startResendTimer();
        } else {
          _showErrorSnackBar('Failed to resend OTP. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('An error occurred. Please try again.');
      }
    }
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

  Widget _buildOtpField(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    final availableWidth = screenWidth - (isTablet ? screenWidth * 0.4 : 48.0) - 64;
    final fieldSize = (availableWidth / 4 - 16).clamp(50.0, isTablet ? 75.0 : 65.0);
    final spacing = ((availableWidth - (fieldSize * 4)) / 3).clamp(6.0, 14.0);
    
    final bool isFilled = _controllers[index].text.isNotEmpty;
    final bool isFocused = _focusNodes[index].hasFocus;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: (isFocused && !isFilled) ? _pulseAnimation.value : 1.0,
          child: Container(
            width: fieldSize,
            height: fieldSize,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            decoration: BoxDecoration(
              gradient: isFilled
                  ? LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isFilled
                  ? null
                  : isFocused
                      ? Colors.white
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isFilled
                    ? _primaryColor
                    : isFocused
                        ? _primaryColor
                        : Colors.grey[300]!,
                width: isFilled || isFocused ? 3 : 2,
              ),
              boxShadow: [
                if (isFilled || isFocused)
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: (fieldSize * 0.35).clamp(20.0, 30.0),
                fontWeight: FontWeight.bold,
                color: isFilled ? Colors.white : _textPrimary,
              ),
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _onOtpChanged(value, index),
              onTap: () {
                _controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controllers[index].text.length,
                );
              },
            ),
          ),
        );
      },
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                        
                        // Header Section with modern back button
                        _buildHeaderSection(screenHeight, isTablet),
                        
                        SizedBox(height: screenHeight * 0.06),
                        
                        // OTP Form Section
                        _buildOtpForm(screenHeight, screenWidth, isTablet),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Security Notice with new design
                        // _buildSecurityNotice(),
                        
                        // SizedBox(height: screenHeight * 0.03),
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
        Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            // Expanded(
            //   child: Center(
            //     child: Text(
            //       "Verification",
            //       style: TextStyle(
            //         fontSize: isTablet ? 24 : 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //         letterSpacing: 0.5,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 52), // Balance the back button
          ],
        ),
        
        SizedBox(height: screenHeight * 0.04),
        
        // Verification Icon
        // ScaleTransition(
        //   scale: _scaleAnimation,
        //   child: Container(
        //     height: 100,
        //     width: 100,
        //     decoration: BoxDecoration(
        //       gradient: const LinearGradient(
        //         colors: [_primaryColor, _secondaryColor],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //       borderRadius: BorderRadius.circular(25),
        //       boxShadow: [
        //         BoxShadow(
        //           color: _primaryColor.withOpacity(0.4),
        //           blurRadius: 25,
        //           offset: const Offset(0, 15),
        //           spreadRadius: 2,
        //         ),
        //       ],
        //     ),
        //     child: const Icon(
        //       Icons.verified_user_outlined,
        //       color: Colors.white,
        //       size: 45,
        //     ),
        //   ),
        // ),
        
        // SizedBox(height: screenHeight * 0.03),
        
        // // Title and Description
        // Text(
        //   "Enter Verification Code",
        //   style: TextStyle(
        //     fontSize: isTablet ? 30 : 26,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //     letterSpacing: 0.8,
        //   ),
        // ),
        
        // SizedBox(height: screenHeight * 0.02),
        
        // Text(
        //   "We sent a 4-digit code to",
        //   style: TextStyle(
        //     fontSize: isTablet ? 18 : 16,
        //     color: Colors.white.withOpacity(0.9),
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        
        // const SizedBox(height: 6),
        
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: Colors.white.withOpacity(0.2),
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(
        //       color: Colors.white.withOpacity(0.3),
        //       width: 1,
        //     ),
        //   ),
        //   child: Text(
        //     "+91 ${widget.mobile}",
        //     style: TextStyle(
        //       fontSize: isTablet ? 18 : 16,
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       letterSpacing: 1.0,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildOtpForm(double screenHeight, double screenWidth, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
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
          
          const SizedBox(height: 24),
          
          Text(
            "Enter 4-Digit Code",
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            "Type the code we sent to your phone",
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
          
          const SizedBox(height: 36),

          // OTP Input Fields
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => _buildOtpField(index)),
                ),
              );
            },
          ),

          const SizedBox(height: 36),

          // Timer and Resend Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                if (!_canResend) ...[
                  Icon(
                    Icons.timer_outlined,
                    color: _primaryColor,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Resend code in ${_resendCountdown}s",
                    style: TextStyle(
                      fontSize: 16,
                      color: _textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else
                  GestureDetector(
                    onTap: _resendOtp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_primaryColor, _secondaryColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Resend Code",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Verify Button
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: isOtpComplete
                  ? LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isOtpComplete ? null : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
              boxShadow: isOtpComplete
                  ? [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: (_isLoading || !isOtpComplete) ? null : _verifyOtp,
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
                          "Verifying...",
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
                          "Verify & Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isOtpComplete ? Colors.white : Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (isOtpComplete) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Help Text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Didn't receive the code? Check your SMS or try resending after the timer expires.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.security_rounded,
              color: _accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "For your security, never share this OTP with anyone. Our team will never ask for it.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}