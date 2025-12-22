import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// Color constants (same as your LoginScreen)
const Color _primaryColor = Color(0xFF00BFA5); // Teal
const Color _secondaryColor = Color(0xFF26A69A); // Darker Teal
const Color _accentColor = Color(0xFFFF6B35);
const Color _backgroundGradientStart = Color(0xFF004D47);
const Color _backgroundGradientEnd = Color(0xFF00695C);
const Color _cardColor = Color(0xFFF8F9FA);
const Color _textPrimary = Color(0xFF2E3440);
const Color _textSecondary = Color(0xFF5E6772);

// API base
const String _baseUrl = 'http://31.97.206.144:4072/api/users';

/// Full flow screens: ForgotMobileScreen -> OtpVerificationScreen -> ResetPasswordScreen

/// 1) Screen to input mobile number
class ForgotMobileScreen extends StatefulWidget {
  const ForgotMobileScreen({Key? key}) : super(key: key);

  @override
  State<ForgotMobileScreen> createState() => _ForgotMobileScreenState();
}

class _ForgotMobileScreenState extends State<ForgotMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your mobile number';
    if (value.length != 10) return 'Mobile number must be exactly 10 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only digits allowed';
    if (!RegExp(r'^[6-9]').hasMatch(value)) {
      return 'Mobile must start with 6,7,8 or 9';
    }
    return null;
  }

  Future<void> _submitMobile() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final mobile = _mobileController.text.trim();

    try {
      final uri = Uri.parse('$_baseUrl/forgot-password');
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'mobile': mobile}),
          )
          .timeout(const Duration(seconds: 10));

      final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;

      if (res.statusCode == 200 || res.statusCode == 201) {
        final message = body != null && body['message'] != null ? body['message'] : 'OTP sent';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim, sec) => OtpVerificationScreen(mobile: mobile),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        final err = body != null && body['message'] != null
            ? body['message']
            : 'Failed to send OTP (${res.statusCode})';
        _showSnack(err);
      }
    } on TimeoutException {
      _showSnack('Request timed out. Check your connection.');
    } catch (e) {
      _showSnack('Could not send OTP. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;
    final horizontalPadding = isTablet ? media.size.width * 0.2 : 20.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundGradientStart, _backgroundGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 30 : 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Enter your registered mobile number. We'll send an OTP to verify.",
                            style: TextStyle(color: Colors.white70, fontSize: isTablet ? 16 : 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: _cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildInputField(
                                          controller: _mobileController,
                                          label: "Mobile Number",
                                          hint: "Enter mobile number",
                                          icon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          validator: _validateMobile,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 52,
                                          child: ElevatedButton(
                                            onPressed: _isLoading ? null : _submitMobile,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: _isLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                                  )
                                                : const Text(
                                                    "Send OTP",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); // back to login
                                          },
                                          child: const Text("Back to Sign In"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Spacer(flex: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: controller.text.isNotEmpty ? _primaryColor.withOpacity(0.6) : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: _textSecondary, size: 20),
          ),
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          counterText: "",
        ),
        validator: validator,
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

/// 2) OTP Screen
class OtpVerificationScreen extends StatefulWidget {
  final String mobile;
  const OtpVerificationScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;
  bool _canResend = true;
  int _resendSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 30;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendSeconds--;
        if (_resendSeconds <= 0) _canResend = true;
      });
      return _resendSeconds > 0;
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 4 || !RegExp(r'^[0-9]{4}$').hasMatch(otp)) {
      _showSnack("Enter a valid 4-digit OTP");
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isVerifying = true);
    HapticFeedback.mediumImpact();

    try {
      final uri = Uri.parse('$_baseUrl/verify-forgot-password');
      final res = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'mobile': widget.mobile, 'otp': otp}))
          .timeout(const Duration(seconds: 10));

      final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;

      if (res.statusCode == 200 || res.statusCode == 201) {
        final message = body != null && body['message'] != null ? body['message'] : 'OTP verified';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim, sec) => ResetPasswordScreen(mobile: widget.mobile),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        final err = body != null && body['message'] != null ? body['message'] : 'OTP verification failed';
        _showSnack(err);
      }
    } on TimeoutException {
      _showSnack('Request timed out. Check your connection.');
    } catch (e) {
      _showSnack('OTP verification failed. Try again.');
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    HapticFeedback.lightImpact();
    setState(() => _canResend = false);

    try {
      final uri = Uri.parse('$_baseUrl/resendotp');
      final res = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'mobile': widget.mobile}))
          .timeout(const Duration(seconds: 10));

      final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;

      if (res.statusCode == 200 || res.statusCode == 201) {
        final msg = body != null && body['message'] != null ? body['message'] : 'OTP resent';
        _showSnack(msg);
        _startResendTimer();
      } else {
        final err = body != null && body['message'] != null ? body['message'] : 'Failed to resend OTP';
        _showSnack(err);
        // allow retry sooner if server returned error
        if (mounted) setState(() => _canResend = true);
      }
    } on TimeoutException {
      _showSnack('Request timed out. Check your connection.');
      if (mounted) setState(() => _canResend = true);
    } catch (e) {
      _showSnack('Unable to resend OTP. Try again.');
      if (mounted) setState(() => _canResend = true);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;
    final horizontalPadding = isTablet ? media.size.width * 0.2 : 20.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundGradientStart, _backgroundGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(height: 18),
                        Text("Enter OTP", style: TextStyle(color: Colors.white, fontSize: isTablet ? 26 : 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("We sent a 4-digit code to +91 •••• ${widget.mobile.substring(widget.mobile.length - 3)}",
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 28),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _otpController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: "Enter 4-digit OTP",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      ),
                                      style: const TextStyle(letterSpacing: 8, fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: _isVerifying ? null : _verifyOtp,
                                        style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: _isVerifying ? const CircularProgressIndicator(color: Colors.white) : const Text("Verify & Continue"),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: _canResend ? _resendOtp : null,
                                          child: Text(_canResend ? "Resend OTP" : "Resend in $_resendSeconds s"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// 3) Reset new password screen
class ResetPasswordScreen extends StatefulWidget {
  final String mobile;
  const ResetPasswordScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm password';
    if (v != _newController.text) return "Passwords don't match";
    return null;
  }

  Future<void> _submitNewPassword() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final payload = {
      'mobile': widget.mobile,
      'newPassword': _newController.text.trim(),
      'confirmPassword': _confirmController.text.trim(),
    };

    try {
      final uri = Uri.parse('$_baseUrl/set-new-password');
      final res = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));

      final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;

      if (res.statusCode == 200 || res.statusCode == 201) {
        final msg = body != null && body['message'] != null ? body['message'] : 'Password updated successfully';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));

        // Navigate back to login (replace with your main screen if desired)
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        final err = body != null && body['message'] != null ? body['message'] : 'Unable to update password';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), behavior: SnackBarBehavior.floating));
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request timed out.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to update password')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;
    final horizontalPadding = isTablet ? media.size.width * 0.2 : 20.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundGradientStart, _backgroundGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
                        const SizedBox(height: 18),
                        Text("Set New Password", style: TextStyle(color: Colors.white, fontSize: isTablet ? 26 : 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Choose a strong password to secure your account", style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildPasswordField(controller: _newController, label: "New Password", validator: _validatePassword),
                                      const SizedBox(height: 12),
                                      _buildPasswordField(controller: _confirmController, label: "Confirm Password", validator: _validateConfirm),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _submitNewPassword,
                                          style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Update Password"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: controller.text.isNotEmpty ? _primaryColor.withOpacity(0.6) : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        validator: validator,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
