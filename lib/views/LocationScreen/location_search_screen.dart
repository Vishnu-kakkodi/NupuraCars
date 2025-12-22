import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationSearchScreen extends StatefulWidget {
  final String? userId;
  const LocationSearchScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> 
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoadingCurrentLocation = false;
  String? userId;
  bool _hasSearchStarted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
    _searchController.addListener(_onSearchChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _slideController.forward();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _focusNode.requestFocus();
        });
      }
    });
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
  }

  void _onSearchChanged() {
    setState(() {
      _hasSearchStarted = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    print("Loading user data in LocationSearchScreen...");
    try {
      print('Current widget userId: ${widget.userId}');
      userId = await StorageHelper.getUserId();
      print('StorageHelper userId: $userId');

      if (userId != null) {
        setState(() {
          userId = userId;
        });
      }
    } catch (e) {
      setState(() {
        userId = widget.userId ?? '';
      });

      if (mounted) {
        _showCustomSnackBar('Failed to load user ID: ${e.toString()}', isError: true);
      }
    }
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isError 
                  ? [
                      const Color(0xFF2D1B21),
                      const Color(0xFF1A0E13),
                    ]
                  : [
                      const Color(0xFF1B2D21),
                      const Color(0xFF0E1A13),
                    ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isError 
                  ? const Color(0xFFFF6B6B).withOpacity(0.3)
                  : const Color(0xFF4ECDC4).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isError ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4))
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isError ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                    color: isError ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: isError ? 4 : 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> _handleCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.initLocation(userId ?? widget.userId.toString(),AuthProvider().isGuest);

      if (mounted) {
        if (locationProvider.hasError) {
          _showCustomSnackBar(locationProvider.errorMessage, isError: true);
        } else {
          _showCustomSnackBar('Location acquired successfully!');
          
          await Future.delayed(const Duration(milliseconds: 800));
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar("Failed to get current location: ${e.toString()}", isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCurrentLocation = false;
        });
      }
    }
  }

  Future<void> _handleLocationSelection(Prediction prediction) async {
    try {
      final latStr = prediction.lat ?? '0';
      final lngStr = prediction.lng ?? '0';
      final latitude = double.tryParse(latStr) ?? 0.0;
      final longitude = double.tryParse(lngStr) ?? 0.0;
      final address = prediction.description ?? 'Unknown location';

      if (latitude == 0.0 && longitude == 0.0) {
        throw Exception('Invalid coordinates received');
      }

      if (mounted) {
        final locationProvider = Provider.of<LocationProvider>(context, listen: false);

        List<String> parts = address.split(',');
        String trimmedAddress = parts.length > 1
            ? parts.sublist(0, 2).join(',').trim()
            : address;

        await locationProvider.updateLocation(
          trimmedAddress,
          [latitude, longitude],
          userId ?? widget.userId.toString(),
          AuthProvider().isGuest
        );

        _showCustomSnackBar('Location set to: ${trimmedAddress.split(',')[0]}');

        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint("Error parsing coordinates: $e");
      if (mounted) {
        _showCustomSnackBar("Error selecting location. Please try again.", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2.0,
            colors: [
              const Color(0xFF1A1A2E).withOpacity(0.3),
              const Color(0xFF0B0B0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Neo-morphic Header
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1A1A2E).withOpacity(0.8),
                        const Color(0xFF16213E).withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        // inset: false,
                      ),
                      BoxShadow(
                        color: const Color(0xFF1A1A2E).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                        // inset: true,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF2D2D44),
                                const Color(0xFF1A1A2E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF4ECDC4),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location Finder",
                              style: GoogleFonts.orbitron(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Navigate to your destination",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4ECDC4).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Pulsing Current Location Card
                      SlideTransition(
                        position: _slideAnimation,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 32),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _isLoadingCurrentLocation ? null : _handleCurrentLocation,
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF4ECDC4).withOpacity(0.2),
                                            const Color(0xFF44A08D).withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4ECDC4).withOpacity(0.2),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFF4ECDC4),
                                                  const Color(0xFF44A08D),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.gps_fixed_rounded,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Auto-Locate",
                                                  style: GoogleFonts.orbitron(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  "Activate GPS positioning system",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(0xFF4ECDC4).withOpacity(0.8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_isLoadingCurrentLocation)
                                            Container(
                                              width: 32,
                                              height: 32,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  const Color(0xFF4ECDC4),
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white.withOpacity(0.2),
                                                    Colors.white.withOpacity(0.1),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.chevron_right_rounded,
                                                size: 24,
                                                color: Color(0xFF4ECDC4),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Hexagonal Search Header
                      SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4ECDC4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE66D),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "MANUAL SEARCH",
                                style: GoogleFonts.orbitron(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Futuristic Search Field
                      SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: GooglePlaceAutoCompleteTextField(
                            textEditingController: _searchController,
                            focusNode: _focusNode,
                            googleAPIKey: "AIzaSyBAgjZGzhUBDznc-wI5eGRHyjVTfENnLSs",
                            inputDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                              hintText: "Enter coordinates or location...",
                              
                              hintStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: const Color(0xFF4ECDC4).withOpacity(0.5),
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(14),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: _hasSearchStarted 
                                      ? const Color(0xFF4ECDC4)
                                      : const Color(0xFF4ECDC4).withOpacity(0.5),
                                  size: 24,
                                ),
                              ),
                              suffixIcon: _hasSearchStarted
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {
                                          _hasSearchStarted = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Icon(
                                          Icons.clear_rounded,
                                          color: Color(0xFFFF6B6B),
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.keyboard_voice_rounded,
                                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                        size: 20,
                                      ),
                                    ),
                              filled: true,
                              fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: const Color(0xFF4ECDC4).withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: const Color(0xFF4ECDC4).withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4ECDC4),
                                  width: 3,
                                ),
                              ),
                            ),
                            debounceTime: 600,
                            countries: const ["in"],
                            isLatLngRequired: true,
                            getPlaceDetailWithLatLng: (Prediction prediction) async {
                              await _handleLocationSelection(prediction);
                            },
                            itemClick: (Prediction prediction) {
                              _searchController.text = prediction.description ?? "";
                              _searchController.selection = TextSelection.fromPosition(
                                TextPosition(offset: prediction.description?.length ?? 0),
                              );
                            },
                            seperatedBuilder: Container(
                              height: 1,
                              color: const Color(0xFF4ECDC4).withOpacity(0.1),
                            ),
                            itemBuilder: (context, index, Prediction prediction) {
                              return Container(
                                color: const Color(0xFF1A1A2E).withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF4ECDC4).withOpacity(0.2),
                                            const Color(0xFF44A08D).withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: Color(0xFF4ECDC4),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            prediction.description ?? "Unknown location",
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (prediction.structuredFormatting?.secondaryText != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                prediction.structuredFormatting!.secondaryText!,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xFF4ECDC4).withOpacity(0.6),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.trending_flat_rounded,
                                      size: 18,
                                      color: const Color(0xFF4ECDC4).withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              );
                            },
                            isCrossBtnShown: false,
                          ),
                        ),
                      ),

                      // Scanning Animation when not searching
                      // if (!_hasSearchStarted)
                        // SlideTransition(
                        //   position: _slideAnimation,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(32),
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topCenter,
                        //         end: Alignment.bottomCenter,
                        //         colors: [
                        //           const Color(0xFF1A1A2E).withOpacity(0.3),
                        //           const Color(0xFF16213E).withOpacity(0.1),
                        //         ],
                        //       ),
                        //       borderRadius: BorderRadius.circular(20),
                        //       border: Border.all(
                        //         color: Colors.white.withOpacity(0.05),
                        //         width: 1,
                        //       ),
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         AnimatedBuilder(
                        //           animation: _pulseAnimation,
                        //           builder: (context, child) {
                        //             return Transform.scale(
                        //               scale: _pulseAnimation.value,
                        //               child: Container(
                        //                 width: 80,
                        //                 height: 80,
                        //                 decoration: BoxDecoration(
                        //                   gradient: LinearGradient(
                        //                     colors: [
                        //                       const Color(0xFF4ECDC4).withOpacity(0.3),
                        //                       const Color(0xFF44A08D).withOpacity(0.2),
                        //                     ],
                        //                   ),
                        //                   borderRadius: BorderRadius.circular(24),
                        //                   border: Border.all(
                        //                     color: const Color(0xFF4ECDC4).withOpacity(0.5),
                        //                     width: 2,
                        //                   ),
                        //                 ),
                        //                 child: const Icon(
                        //                   Icons.radar_rounded,
                        //                   size: 40,
                        //                   color: Color(0xFF4ECDC4),
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //         const SizedBox(height: 24),
                        //         Text(
                        //           "SCANNING MODE",
                        //           style: GoogleFonts.orbitron(
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w700,
                        //             color: const Color(0xFF4ECDC4),
                        //             letterSpacing: 2,
                        //           ),
                        //         ),
                        //         const SizedBox(height: 8),
                        //         Text(
                        //           "Ready to locate your destination",
                        //           style: GoogleFonts.inter(
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w400,
                        //             color: Colors.white.withOpacity(0.6),
                        //           ),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
}