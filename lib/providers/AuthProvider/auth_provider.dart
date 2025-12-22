import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nupura_cars/models/AuthModel/auth_model.dart';
import 'package:nupura_cars/services/AuthService/auth_service.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthModel? _user;
  String? _token;
  String? _localImageUrl;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isGuest = false;

  AuthModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
    bool get isGuest => _isGuest;
  String get errorMessage => _errorMessage;

  String get localImageUrl =>
      _localImageUrl ?? 'https://avatar.iran.liara.run/public/boy?username=Ash';

  /// Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

    void isGuestSetUp(bool value) {
    _isGuest = value;
    print("ooooooooooooooooooooooooooooo$isGuest");
    notifyListeners();
  }

      void _isGuestSetUp(bool value) {
    _isGuest = value;
    print("ooooooooooooooooooooooooooooo$isGuest");
    notifyListeners();
  }

  /// Login user by mobile number
  Future<bool?> loginUser(String mobile, String password) async {
    try {
      _setLoading(true);
      clearError();
      _isGuestSetUp(false);
            notifyListeners();

      
      final result = await _authService.login(mobile, password);
            if (result != null) {
        final user = result['user'] as AuthModel;
        final token = result['token'] as String?;
        
        // Set user and token
        setUser(user);
        if (token != null) {
          setToken(token);
        }
        
        debugPrint('✅ OTP verification completed successfully');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Register user and store in provider
  Future<bool?> registerUser({
    required String name,
    required String email,
    required String mobile,
        required String password,

    String? referralCode,
  }) async {
    try {
      _setLoading(true);
      clearError();
      
      final bool? user = await _authService.register(
        name,
        email,
        mobile,
        password,
        referralCode,
      );
      return user;
    } catch (e) {
      debugPrint('Registration error: $e');
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify OTP and complete authentication
  Future<bool> verifyOtp(String otp) async {
    try {
      _setLoading(true);
      clearError();
      
      final result = await _authService.verifyOtp(otp);
      
      if (result != null) {
        final user = result['user'] as AuthModel;
        final token = result['token'] as String?;
        
        // Set user and token
        setUser(user);
        if (token != null) {
          setToken(token);
        }
        
        debugPrint('✅ OTP verification completed successfully');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ OTP verification failed: $e');
      _setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Resend OTP to mobile number
  Future<bool> resendOtp(String mobile) async {
    try {
      _setLoading(true);
      clearError();
      
      final success = await _authService.resendOtp(mobile);
      return success;
    } catch (e) {
      debugPrint('❌ Resend OTP failed: $e');
      _setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Set user data to provider and local storage
  void setUser(AuthModel user) {
    _user = user;

    StorageHelper.saveUserId(
      user.id,
      user.name,
      user.mobile,
      user.profileImage,
      user.code,
      user.email ?? '',
    );

    loadProfileImage();
    notifyListeners();
  }

  /// Set token to memory and persist it
  void setToken(String token) {
    _token = token;
    StorageHelper.saveToken(token);
    notifyListeners();
  }

  /// Initialize from saved storage (on app start)
  Future<bool> init() async {
    final userId = await StorageHelper.getUserId();
    final token = await StorageHelper.getToken();

    if (userId != null) {
      _user = AuthModel(
        id: userId,
        name: await StorageHelper.getUserName() ?? '',
        mobile: await StorageHelper.getMobile() ?? '',
        email: await StorageHelper.getEmail(),
        code: await StorageHelper.getCode() ?? '',
        myBookings: [],
        profileImage: await StorageHelper.getProfileImage(),
      );

      _token = token;
      await loadProfileImage();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Update only the profile image
Future<void> updateProfileImage({
  required BuildContext context,
  required XFile image,
  required String id,
  required AuthProvider authProvider,
}) async {
  try {
    _setLoading(true);
    clearError();
    
    print("Starting profile image update for user: $id");
    final response = await _authService.updateProfileImage(image, id);

    // Extract updated profileImage from response
    final updatedUser = response['user'];
    print("Response from server: ${updatedUser['profileImage']}");
    
    if (updatedUser != null && updatedUser['profileImage'] != null) {
      final newProfileImagePath = updatedUser['profileImage'].toString();
      print("New profile image path: $newProfileImagePath");

      // Update the current user's profile image
        _user?.profileImage = newProfileImagePath;
        print("Updated user profile image: ${_user?.profileImage}");
        
        // Update stored profile image in SharedPreferences
        await StorageHelper.saveProfileImage(newProfileImagePath);
        
        // Refresh the local image URL
        await loadProfileImage();
        
        // Clear image cache to ensure new image loads
        await refreshProfileImage();
        
        print("Profile image updated successfully!");
    } else {
      throw Exception("Invalid response from server");
    }
    
    notifyListeners();
    
  } catch (e) {
    print("Error uploading profile image: $e");
    _setError("Failed to update profile image: ${e.toString()}");
    
    // Show error to user
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Failed to update profile image')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  } finally {
    _setLoading(false);
  }
}


  /// Reload profile image and clear cache
  Future<void> refreshProfileImage() async {
    imageCache.clear();
    imageCache.clearLiveImages();
    await loadProfileImage();
    notifyListeners();
  }

  /// Load user profile image
  Future<void> loadProfileImage() async {
    final profileImage = _user?.profileImage ?? await StorageHelper.getProfileImage();

    if (profileImage != null && profileImage.isNotEmpty) {
      _localImageUrl = 'http://31.97.206.144:4072/$profileImage';
    } else {
      _localImageUrl = 'https://avatar.iran.liara.run/public/boy?username=Ash';
    }
    notifyListeners();
  }

  /// Clear all user session
  Future<void> logout() async {
    _user = null;
    _localImageUrl = null;
    _token = null;
    _errorMessage = '';
    _isLoading = false;
    await StorageHelper.clearUserData();
    notifyListeners();
  }
}