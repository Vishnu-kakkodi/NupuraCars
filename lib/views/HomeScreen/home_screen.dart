import 'package:nupura_cars/models/CarModel/car_model.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/providers/BannerProvider/banner_provider.dart';
import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/service_name_provider.dart';
import 'package:nupura_cars/providers/WalletProvider/wallet_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/checkout_screen.dart';
import 'package:nupura_cars/views/CarDecor/car_decor_screen.dart';
import 'package:nupura_cars/views/CarList/car_list_screen.dart';
import 'package:nupura_cars/views/CarRent/car_rent_screen.dart';
import 'package:nupura_cars/views/CarRent/rent_category.dart';
import 'package:nupura_cars/views/CarWash/water_wash_screen.dart';
import 'package:nupura_cars/views/MyCar/select_brand_screen.dart';
import 'package:nupura_cars/views/CarService/services_screen.dart';
import 'package:nupura_cars/views/LocationScreen/location_search_screen.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/edit_profile_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/refer_screen.dart';
import 'package:nupura_cars/views/guest_modal.dart';
import 'package:nupura_cars/widgects/BackControl/back_confirm_dialog.dart';
import 'package:nupura_cars/widgects/HomeCarousel/brands_we_trust_widget.dart';
import 'package:nupura_cars/widgects/HomeCarousel/home_carousel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupura_cars/widgects/HomeCarousel/why_choose_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  String? name;
  String? _localImageUrl;
  String _address = 'Fetching location...';
  final String type = "";
  final String fuel = "";
  bool _isLoadingCurrentLocation = false;
  bool guest = false;
  int _selectedCategoryIndex = 0;

  /// service tab slot selections (for future use)
  final Map<String, String?> _selectedSlots = {};

  /// custom service state
  List<String> _selectedCustomItems = [];
  String? _selectedCustomSlot;
  final TextEditingController _customNoteController = TextEditingController();

  /// currently selected user-car id in Services tab
  String? _selectedServiceCarId;

  // Theme colors from AppTheme
  Color get _seedColor => const Color(0xFF00BFA5);
  Color get _scaffoldBackgroundColor =>
      Theme.of(context).scaffoldBackgroundColor;
  Color get _cardColor => Theme.of(context).cardColor;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  Color get _secondaryColor => Theme.of(context).colorScheme.primaryContainer;
  Color get _accentColor => Theme.of(context).colorScheme.secondary;
  Color get _backgroundColor => Theme.of(context).colorScheme.background;
  Color get _surfaceColor => Theme.of(context).colorScheme.surface;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Cars Rent', 'icon': Icons.directions_car, 'available': true},
    {
      'name': 'Services',
      'icon': Icons.miscellaneous_services,
      'available': true
    },
    {'name': 'Water Wash', 'icon': Icons.local_car_wash, 'available': false},
        {'name': 'Decors', 'icon': Icons.construction, 'available': false},

  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchBanners();
      context.read<ServiceNameProvider>().getServiceNames();


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dateTimeProvider = Provider.of<DateTimeProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final DateTime now = DateTime.now();
      final DateTime tomorrowSameTime = now.add(const Duration(days: 1));

      // Set start & end dates
      dateTimeProvider.setStartDate(now);
      dateTimeProvider.setEndDate(tomorrowSameTime);

      // Set start & end times
      dateTimeProvider.setStartTime(
        TimeOfDay(hour: now.hour, minute: now.minute),
      );
      dateTimeProvider.setEndTime(
        TimeOfDay(hour: tomorrowSameTime.hour, minute: tomorrowSameTime.minute),
      );

      guest = authProvider.isGuest;
      await _handleCurrentLocation(authProvider.isGuest);
      _loadCarsWithFilters(authProvider.isGuest);
    });
  }

  // Responsive helpers
  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleCurrentLocation(bool isGuest) async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      await locationProvider.initLocation(userId.toString(), isGuest);

      if (mounted && locationProvider.hasError) {
        _showError(locationProvider.errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showError("Failed to get current location: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCurrentLocation = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.user?.profileImage != null) {
      _updateProfileImage(authProvider);
    }
  }

  @override
  void dispose() {
    _customNoteController.dispose();
    super.dispose();
  }

  Future<void> _fetchBanners() async {
    try {
      await Provider.of<BannerProvider>(context, listen: false).fetchBanners();
    } catch (e) {
      debugPrint('Error fetching banners: $e');
    }
  }

  void _loadCarsWithFilters(bool isGuest) {
    final dateTimeProvider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );
    final carProvider = Provider.of<CarProvider>(context, listen: false);

    String? startDateStr;
    String? endDateStr;
    String? startTimeStr;
    String? endTimeStr;

    if (dateTimeProvider.startDate != null) {
      final startDate = dateTimeProvider.startDate!;
      startDateStr =
          '${startDate.year}/${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.endDate != null) {
      final endDate = dateTimeProvider.endDate!;
      endDateStr =
          '${endDate.year}/${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.startTime != null) {
      final startTime = dateTimeProvider.startTime!;
      startTimeStr =
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.endTime != null) {
      final endTime = dateTimeProvider.endTime!;
      endTimeStr =
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    }

    if (userId != null) {
      carProvider.loadCars(
        userId: userId,
        startDate: startDateStr,
        endDate: endDateStr,
        startTime: startTimeStr,
        endTime: endTimeStr,
      );
    } else if (isGuest) {
      carProvider.loadCars(
        lat: "17.4920832",
        lng: "78.3989487",
        startDate: startDateStr,
        endDate: endDateStr,
        startTime: startTimeStr,
        endTime: endTimeStr,
      );
    } else {
      _showError('Failed to load user data');
    }
  }

  void _updateProfileImage(AuthProvider authProvider) {
    if (authProvider.user?.profileImage != null) {
      setState(() {
        _localImageUrl = authProvider.user!.profileImage;
      });
    }
  }

  // Future<void> _loadUserData() async {
  //   try {
  //     userId = await StorageHelper.getUserId();
  //     name = await StorageHelper.getUserName();

  //     if (userId != null && mounted) {
  //       // recent booking
  //       await Provider.of<BookingProvider>(
  //         context,
  //         listen: false,
  //       ).getRecentBooking(userId.toString());

  //       // load my cars from MyCarProvider (NEW)
  //       await Provider.of<MyCarProvider>(
  //         context,
  //         listen: false,
  //       ).loadMyCars(userId!);

  //       final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //       StorageHelper.getProfileImage().then((storedImage) {
  //         final profileImage = authProvider.user?.profileImage ?? storedImage;
  //         if (profileImage != null && profileImage.startsWith("http")) {
  //           _localImageUrl = profileImage;
  //         } else {
  //           _localImageUrl =
  //               'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg';
  //         }

  //         if (mounted) {
  //           setState(() {
  //             userId = userId.toString();
  //             name = name.toString();
  //           });
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       _showError('Failed to load user data: ${e.toString()}');
  //     }
  //   }
  // }


    Future<void> _loadUserData() async {
    try {
      userId = await StorageHelper.getUserId();
      name = await StorageHelper.getUserName();

      if (userId != null && mounted) {
        // recent booking
        await Provider.of<BookingProvider>(
          context,
          listen: false,
        ).getRecentBooking(userId.toString());

        // 🔹 load my cars + my current car
        final myCarProvider = Provider.of<MyCarProvider>(
          context,
          listen: false,
        );
        await myCarProvider.loadMyCars(userId!);
        await myCarProvider.loadMyCurrentCar(userId!);

        // 🔹 optional: keep local selection in sync with backend
        _selectedServiceCarId = myCarProvider.currentCarId;

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        StorageHelper.getProfileImage().then((storedImage) {
          final profileImage = authProvider.user?.profileImage ?? storedImage;
          if (profileImage != null && profileImage.startsWith("http")) {
            _localImageUrl = profileImage;
          } else {
            _localImageUrl =
                'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg';
          }

          if (mounted) {
            setState(() {
              userId = userId.toString();
              name = name.toString();
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to load user data: ${e.toString()}');
      }
    }
  }


  Future<void> _selectFromCalendar({required bool isStartDate}) async {
    final DateTimeProvider provider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );
    final DateTime today = DateTime.now();

    bool pickingStartDate;
    if (provider.startDate == null) {
      pickingStartDate = true;
    } else if (provider.endDate == null) {
      pickingStartDate = false;
    } else {
      pickingStartDate = true;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickingStartDate
          ? (provider.startDate ?? today)
          : (provider.endDate ?? provider.startDate ?? today),
      firstDate: pickingStartDate ? today : (provider.startDate ?? today),
      lastDate: DateTime(today.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: _primaryColor,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (pickingStartDate) {
        provider.setStartDate(picked);
      } else {
        if (picked.isBefore(provider.startDate!)) {
          provider.setStartDate(picked);
          provider.setEndDate(provider.startDate!);
        } else {
          provider.setEndDate(picked);
        }
      }
      _loadCarsWithFilters(guest);
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  bool isSameDate(DateTime? d1, DateTime? d2) {
    if (d1 == null || d2 == null) return false;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  bool isEndAfterStart(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  Future<void> _pickTime({required bool isStart}) async {
    final DateTimeProvider provider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );
    final TimeOfDay initial = isStart
        ? (provider.startTime ?? TimeOfDay.now())
        : (provider.endTime ?? TimeOfDay.now());

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: _primaryColor,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      if (isStart) {
        provider.setStartTime(picked);
      } else {
        if (isSameDate(provider.startDate, provider.endDate) &&
            provider.startTime != null &&
            !isEndAfterStart(provider.startTime!, picked)) {
          _showError("End time must be after start time");
          return;
        }
        provider.setEndTime(picked);
      }
      _loadCarsWithFilters(guest);
    }
  }

  // -------------------- CATEGORY UI --------------------

  Widget _buildCategorySection() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getResponsiveValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: TextStyle(
              fontSize: getResponsiveValue(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              _categories.length,
              (index) => Expanded(
                child: GestureDetector(
  onTap: () {
  setState(() {
    _selectedCategoryIndex = index;
  });

  // If this tab requires navigation, do it here (outside build)
  if (index == 0) {
    // Services tab
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RentCategory()),
    );
  } else if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServicesScreen()),
    );
  } 
  else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WaterWashScreen()),
    );
  } else if (index == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarDecorScreen()),
    );
  }

},

                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < _categories.length - 1 ? 12 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: _selectedCategoryIndex == index
                          ? LinearGradient(
                              colors: [_primaryColor, _secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _selectedCategoryIndex == index
                          ? null
                          : _cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedCategoryIndex == index
                            ? Colors.transparent
                            : Theme.of(context).dividerColor,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedCategoryIndex == index
                              ? _primaryColor.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: _selectedCategoryIndex == index ? 12 : 8,
                          offset: Offset(
                            0,
                            _selectedCategoryIndex == index ? 4 : 2,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _categories[index]['icon'],
                          size: 28,
                          color: _selectedCategoryIndex == index
                              ? Colors.white
                              : _primaryColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _categories[index]['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedCategoryIndex == index
                                ? Colors.white
                                : _textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor.withOpacity(0.1),
                      _secondaryColor.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rocket_launch,
                  color: _primaryColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$categoryName service will be available soon. Stay tuned!',
                style: TextStyle(
                  fontSize: 15,
                  color: _textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

Widget _buildCategoryContent(DateTimeProvider dateTimeProvider) {
  // 🚀 Handle navigation for tabs 1, 2, 3
  // if (_selectedCategoryIndex != 0) {
  //   return const SizedBox.shrink();
  // }

  // ---------------------------------------------------------
  // 🟦 INDEX 0 → SHOW YOUR EXISTING CARS TAB UI
  // ---------------------------------------------------------
  // if (_selectedCategoryIndex == 0) {
  //     return Column(
  //       children: [
  //         SizedBox(height: 24),
  //         _buildDateTimeSelector(context, dateTimeProvider),
  //         SizedBox(height: 32),

  //         // Available Cars Section Header
  //         Container(
  //           margin: EdgeInsets.symmetric(
  //             horizontal: getResponsiveValue(
  //               context,
  //               mobile: 16,
  //               tablet: 24,
  //               desktop: 32,
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Available Cars',
  //                 style: TextStyle(
  //                   fontSize: getResponsiveValue(
  //                     context,
  //                     mobile: 20,
  //                     tablet: 22,
  //                     desktop: 24,
  //                   ),
  //                   fontWeight: FontWeight.bold,
  //                   color: _textPrimary,
  //                 ),
  //               ),
  //               TextButton.icon(
  //                 onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => ModernCarListScreen(guest: guest),
  //                     ),
  //                   );
  //                 },
  //                 icon: Text(
  //                   'View All',
  //                   style: TextStyle(
  //                     color: _primaryColor,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //                 label: Icon(
  //                   Icons.arrow_forward_ios,
  //                   size: 16,
  //                   color: _primaryColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 16),

  //         // Cars List
  //         Container(
  //           height: getResponsiveValue(
  //             context,
  //             mobile: 380,
  //             tablet: 380,
  //             desktop: 400,
  //           ),
  //           child: Consumer<CarProvider>(
  //             builder: (context, carProvider, child) {
  //               final cars = carProvider.cars;

  //               if (carProvider.isLoading) {
  //                 return Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CircularProgressIndicator(color: _primaryColor),
  //                       SizedBox(height: 16),
  //                       Text(
  //                         'Loading cars...',
  //                         style: TextStyle(
  //                           color: _textSecondary,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }

  //               if (carProvider.hasError) {
  //                 return Center(
  //                   child: Container(
  //                     margin: EdgeInsets.all(24),
  //                     padding: EdgeInsets.all(28),
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).colorScheme.errorContainer,
  //                       borderRadius: BorderRadius.circular(24),
  //                       border: Border.all(
  //                         color: Theme.of(context).colorScheme.error,
  //                       ),
  //                     ),
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Icon(
  //                           Icons.error_outline,
  //                           color: Theme.of(context).colorScheme.error,
  //                           size: 48,
  //                         ),
  //                         SizedBox(height: 16),
  //                         Text(
  //                           'Failed to load cars',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                             color: Theme.of(context).colorScheme.error,
  //                           ),
  //                         ),
  //                         SizedBox(height: 20),
  //                         ElevatedButton(
  //                           onPressed: () => _loadCarsWithFilters(guest),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Theme.of(
  //                               context,
  //                             ).colorScheme.error,
  //                           ),
  //                           child: Text('Retry'),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               }

  //               if (cars.isEmpty) {
  //                 return Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         Icons.directions_car_outlined,
  //                         size: 64,
  //                         color: _textSecondary,
  //                       ),
  //                       SizedBox(height: 16),
  //                       Text(
  //                         'No cars available',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w600,
  //                           color: _textPrimary,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }

  //               final validCars = cars.where((car) {
  //                 return car != null && car.name != null && car.name.isNotEmpty;
  //               }).toList();

  //               return ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 padding: EdgeInsets.symmetric(horizontal: 20),
  //                 itemCount: validCars.length,
  //                 itemBuilder: (context, index) {
  //                   return _buildFloatingGlassCarCard(
  //                     validCars[index],
  //                     context,
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     );
  // }

  return SizedBox();
}



    Widget _buildFloatingGlassCarCard(Car car, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _handleCarTap(car),
      child: Container(
        width: 280,
        margin: EdgeInsets.only(right: 20, bottom: 12, top: 12),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image with Overlay
            Stack(
              children: [
                // Main Car Image
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Image.network(
                      car.image.isNotEmpty ? car.image[0] : '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_backgroundColor, _surfaceColor],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: _primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_surfaceColor, _backgroundColor],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_car_outlined,
                                  size: 48,
                                  color: _textSecondary,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Car Image',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Gradient Overlay
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),

                // Car Type Badge - Top Left
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      car.type ?? 'Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Price Badge - Top Right
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '₹${car.pricePerDay}/day',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Features Badge - Bottom Left
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_gas_station,
                          size: 14,
                          color: _textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          car.fuel ?? 'Petrol',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.people_outline,
                          size: 14,
                          color: _textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${car.seats ?? 4}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Car Details Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Name and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: _textSecondary,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    car.location,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Rent Now Button
                  Container(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () => _handleCarTap(car),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Rent Now',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


    void _handleCarTap(Car car) {
    final dateTimeProvider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );
    if (!guest) {
      if (dateTimeProvider.allFieldsComplete) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              carImages: car.image,
              carId: car.id,
              carName: car.name,
              fuel: car.fuel,
              carType: car.carType,
              seats: car.seats,
              location: car.location,
              pricePerDay: car.pricePerDay,
              pricePerHour: car.pricePerHour,
              branch: car.branch.name ?? "Unknown",
              cordinates: car.branch.coordinates,
            ),
          ),
        );
      } else {
        _showDateSelectionDialog();
      }
    } else {
      GuestLoginBottomSheet.show(context);
    }
  }

  void _showDateSelectionDialog() {
    final dateTimeProvider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );

    List<String> missingFields = [];
    if (dateTimeProvider.startDate == null) missingFields.add("Start Date");
    if (dateTimeProvider.endDate == null) missingFields.add("End Date");
    if (dateTimeProvider.startTime == null) missingFields.add("Start Time");
    if (dateTimeProvider.endTime == null) missingFields.add("End Time");

    String message = missingFields.length == 4
        ? "Please select rental dates and times to continue with booking."
        : "Missing: ${missingFields.join(', ')}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Set Booking Time',
          style: TextStyle(fontWeight: FontWeight.w600, color: _textPrimary),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 14, color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to date/time selection or show date picker
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Set Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // -------------------- SERVICE TAB HELPERS --------------------
  // NOTE: These helpers still use CarServiceProvider ONLY for package logic,
  // not for listing / holding "my cars".

  // current car card now uses UserCar from MyCarProvider
Widget _buildCurrentCarCard(UserCar car) {
  // From your UserCar model
  final reg = car.registrationNumber;
  final fuel = car.fuelType;
  final name = car.car?.name ?? 'My Car';
  final carImage = car.car?.image; // usually String? or List<String>?

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(
        color: _primaryColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: (carImage != null && carImage.toString().isNotEmpty)
              ? Image.network(
                  carImage.toString(),
                  width: 70,
                  height: 45,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 45,
                    color: _backgroundColor,
                    child: const Icon(Icons.directions_car),
                  ),
                )
              : Container(
                  width: 70,
                  height: 45,
                  color: _backgroundColor,
                  child: const Icon(Icons.directions_car),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fuel,
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
              ),
              if (reg.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  reg,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),

        /// 👉 Right-side actions: EDIT + CHANGE
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // EDIT ICON
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'Edit car',
              onPressed: () {
                // Go through Brand → Model → AddCar for EDIT flow
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectBrandScreen(
                      // you need to add this optional param in SelectBrandScreen
                      editingCar: car,
                    ),
                  ),
                );
              },
            ),

            // CHANGE (open garage bottom sheet)
            TextButton.icon(
              onPressed: _showGarageBottomSheet,
              icon: const Icon(Icons.directions_car_outlined, size: 16),
              label: const Text('Change'),
            ),
          ],
        ),
      ],
    ),
  );
}

  void _showNoCarsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                'No cars in your garage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your car once and use it for all your services and bookings.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectBrandScreen(),
                      ),
                    );
                  },
                  child: const Text('Add New Car'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGarageBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer<MyCarProvider>(
          builder: (_, myCarProvider, __) {
            final cars = myCarProvider.myCars;

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text(
                    'My Garage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cars.length,
                      itemBuilder: (_, index) {
                        final UserCar car = cars[index];
                        final isCurrent = car.id == myCarProvider.currentCarId;

                        return GestureDetector(
                          onTap: () async {
                            if (userId == null) return;
                            try {
                              await myCarProvider.setCurrentCarForUser(
                                userId!,
                                car.id,
                              );
                              if (mounted) {
                                setState(() {
                                  _selectedServiceCarId = car.id;
                                });
                              }
                              Navigator.pop(ctx);
                            } catch (e) {
                              Navigator.pop(ctx);
                              _showError(
                                'Failed to set current car: ${e.toString()}',
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrent
                                    ? _primaryColor
                                    : Colors.grey.shade300,
                                width: isCurrent ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: buildCarImage(car),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        car.car?.name ??
                                            'My Car ${index + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        car.fuelType,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        car.registrationNumber,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isCurrent) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Current',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                IconButton(
                                  onPressed: () async {
                                    if (userId == null) return;
                                    try {
                                      await myCarProvider.removeUserCar(
                                        userId!,
                                        car.id,
                                      );
                                    } catch (e) {
                                      _showError(
                                        'Failed to delete car: ${e.toString()}',
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SelectBrandScreen(),
                          ),
                        );
                      },
                      child: const Text('Add New Car +', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCarImage(UserCar car) {
  final imageUrl = car.car?.image;

  if (imageUrl == null || imageUrl.isEmpty) {
    return const Icon(Icons.directions_car);
  }

  return Image.network(
    imageUrl,
    fit: BoxFit.fill,
    errorBuilder: (_, __, ___) => const Icon(Icons.directions_car),
  );
}



  // -------------------- DATE/TIME SELECTOR --------------------

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateTimeSelector(
    BuildContext context,
    DateTimeProvider dateTimeProvider,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getResponsiveValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose your rental period",
            style: TextStyle(
              fontSize: getResponsiveValue(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildStepItem(
            context,
            step: "1",
            title: "Start Date",
            value: dateTimeProvider.startDate != null
                ? DateFormat('EEE, MMM dd').format(dateTimeProvider.startDate!)
                : "Tap to select",
            icon: Icons.calendar_today_outlined,
            onTap: () => _selectFromCalendar(isStartDate: true),
          ),
          Divider(color: Theme.of(context).dividerColor, height: 28),
          _buildStepItem(
            context,
            step: "2",
            title: "Start Time",
            value: formatTime(dateTimeProvider.startTime),
            icon: Icons.access_time,
            onTap: () => _pickTime(isStart: true),
          ),
          Divider(color: Theme.of(context).dividerColor, height: 28),
          _buildStepItem(
            context,
            step: "3",
            title: "End Date",
            value: dateTimeProvider.endDate != null
                ? DateFormat('EEE, MMM dd').format(dateTimeProvider.endDate!)
                : "Tap to select",
            icon: Icons.calendar_today_outlined,
            onTap: () => _selectFromCalendar(isStartDate: false),
          ),
          Divider(color: Theme.of(context).dividerColor, height: 28),
          _buildStepItem(
            context,
            step: "4",
            title: "End Time",
            value: formatTime(dateTimeProvider.endTime),
            icon: Icons.access_time,
            onTap: () => _pickTime(isStart: false),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required String step,
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = value != "Tap to select" && value != "--:--";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color:
                  isSelected ? _primaryColor : Theme.of(context).dividerColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: TextStyle(
                color: isSelected ? Colors.white : _textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            size: 20,
            color: isSelected ? _primaryColor : _textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? _primaryColor : _textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: _textSecondary),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      setState(() {});

      final List<Future> refreshTasks = [];
      refreshTasks.add(_loadUserData());
      refreshTasks.add(_fetchBanners());
      refreshTasks.add(_handleCurrentLocation(AuthProvider().isGuest));
      refreshTasks.add(Future(() => _loadCarsWithFilters(guest)));

      if (userId != null) {
        refreshTasks.add(
          Provider.of<WalletProvider>(
            context,
            listen: false,
          ).fetchWalletDetails(userId!),
        );
        refreshTasks.add(
          Provider.of<DocumentProvider>(
            context,
            listen: false,
          ).fetchDocuments(userId!),
        );
      }

      await Future.wait(refreshTasks);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Updated successfully!'),
              ],
            ),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError('Refresh failed: ${e.toString()}');
      }
    }
  }

  // -------------------- MAIN BUILD --------------------

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context);
    final List<String> carouselImages = bannerProvider.getAllImages();
    final bookingProvider = Provider.of<BookingProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);

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
        backgroundColor: _scaffoldBackgroundColor,
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: _primaryColor,
            backgroundColor: _cardColor,
            strokeWidth: 3,
            displacement: 60,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildModernAppBar(context, walletProvider),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: getResponsiveValue(
                        context,
                        mobile: 16,
                        tablet: 24,
                        desktop: 32,
                      ),
                    ),
                    child: _buildHeroBanner(context, carouselImages),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
                // SliverToBoxAdapter(
                //   child: Consumer<BookingProvider>(
                //     builder: (context, bookingProvider, _) {
                //       final booking = bookingProvider.recentBooking;
                //       if (bookingProvider.isLoading) {
                //         return Center(
                //           child: Padding(
                //             padding: const EdgeInsets.all(20.0),
                //             child: CircularProgressIndicator(
                //               color: _primaryColor,
                //             ),
                //           ),
                //         );
                //       }
                //       if (booking == null) return const SizedBox.shrink();
      
                //       return Container(
                //         margin: const EdgeInsets.symmetric(
                //           horizontal: 16,
                //           vertical: 12,
                //         ),
                //         padding: const EdgeInsets.all(16),
                //         decoration: BoxDecoration(
                //           color: _cardColor,
                //           borderRadius: BorderRadius.circular(16),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black12,
                //               blurRadius: 10,
                //               offset: const Offset(0, 4),
                //             ),
                //           ],
                //         ),
                //         child: Row(
                //           children: [
                //             ClipRRect(
                //               borderRadius: BorderRadius.circular(12),
                //               child: Image.network(
                //                 booking.car.image.isNotEmpty
                //                     ? booking.car.image.first
                //                     : 'https://via.placeholder.com/100',
                //                 width: 100,
                //                 height: 70,
                //                 fit: BoxFit.fill,
                //               ),
                //             ),
                //             const SizedBox(width: 16),
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     booking.car.name,
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 16,
                //                       color: _textPrimary,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 4),
                //                   Text(
                //                     'From: ${booking.from}  →  To: ${booking.to}',
                //                     style: TextStyle(
                //                       fontSize: 13,
                //                       color: _textSecondary,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 4),
                //                   Text(
                //                     'Status: ${booking.status}',
                //                     style: TextStyle(
                //                       fontSize: 13,
                //                       color: booking.status.toLowerCase() ==
                //                               'active'
                //                           ? Colors.green
                //                           : Colors.orange,
                //                       fontWeight: FontWeight.w600,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (_) =>
                //                         MainNavigationScreen(initialIndex: 1),
                //                   ),
                //                 );
                //               },
                //               child: Text(
                //                 'View',
                //                 style: TextStyle(
                //                   color: _primaryColor,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
SliverToBoxAdapter(child: _buildCategorySection()),

const SliverToBoxAdapter(
  child: SizedBox(height: 24),
),

const SliverToBoxAdapter(
  child: BrandsWeTrustWidget(),
),

const SliverToBoxAdapter(
  child: SizedBox(height: 32),
),

const SliverToBoxAdapter(
  child: WhyChooseWidget(),
),

const SliverToBoxAdapter(
  child: SizedBox(height: 32),
),

                SliverToBoxAdapter(
                  child: Consumer<DateTimeProvider>(
                    builder: (context, dateTimeProvider, _) {
                      return _buildCategoryContent(dateTimeProvider);
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- APP BAR & HERO --------------------

  Widget _buildModernAppBar(
    BuildContext context,
    WalletProvider walletProvider,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 20,
        left: getResponsiveValue(context, mobile: 20, tablet: 28, desktop: 36),
        right:
            getResponsiveValue(context, mobile: 20, tablet: 28, desktop: 36),
      ),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, value, child) {
                      String? userName = value.user?.name ?? name;

                      return Text(
                        'Welcome ${(userName?.split(' ')[0] ?? '').length > 12 ? (userName?.split(' ')[0] ?? '').substring(0, 12) : userName?.split(' ')[0]}! 👋',
                        style: TextStyle(
                          fontSize: getResponsiveValue(
                            context,
                            mobile: 20,
                            tablet: 24,
                            desktop: 28,
                          ),
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find your perfect ride',
                    style: TextStyle(
                      fontSize: getResponsiveValue(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Right Section: Action Icons
              Row(
                children: [
                  _buildActionIcon(
                    icon: Icons.card_giftcard,
                    onTap: () {
                      if (!guest) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReferScreen(),
                          ),
                        );
                      } else {
                        GuestLoginBottomSheet.show(context);
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildActionIcon(
                    iconWidget: _localImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _localImageUrl!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.person, color: _primaryColor),
                    onTap: () {
                      if (!guest) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfile(),
                          ),
                        );
                      } else {
                        GuestLoginBottomSheet.show(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Location Section
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LocationSearchScreen(userId: userId.toString()),
                ),
              );
              if (result == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Updating cars for new location..."),
                    backgroundColor: _primaryColor,
                  ),
                );
                await _handleRefresh();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: _primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                        final addrParts =
                            (locationProvider.address ?? 'Fetching location...')
                                .split(',')
                                .map((e) => e.trim())
                                .toList();
                        final primary = addrParts.isNotEmpty
                            ? addrParts[0]
                            : 'Fetching location...';
                        final secondary = addrParts.length > 1
                            ? addrParts.sublist(1).join(', ')
                            : 'Tap to select location';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              primary,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (secondary.isNotEmpty &&
                                secondary != 'Tap to select location')
                              Text(
                                secondary,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: _textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon({
    IconData? icon,
    Widget? iconWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: iconWidget ?? Icon(icon, color: _primaryColor, size: 20),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, List<String> carouselImages) {
    final bannerHeight = getResponsiveValue(
      context,
      mobile: 200,
      tablet: 250,
      desktop: 240,
    );

    return SizedBox(
      height: bannerHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: carouselImages.isNotEmpty
            ? ResponsiveCarousel(
                imageAssets: carouselImages,
                autoPlayDuration: const Duration(seconds: 4),
                enableAutoPlay: true,
                showIndicators: true,
                enableInfiniteScroll: true,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _secondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 48,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Drive Forward',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your Premium Car Rental',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // --- My Car Services helpers (unused card, adjusted to UserCar for consistency) ---

  Widget _buildMyCarServiceCard(UserCar car) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Car',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reg: ${car.registrationNumber}',
            style: TextStyle(color: _textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Fuel: ${car.fuelType}',
            style: TextStyle(color: _textSecondary),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                // future: open service options for this car
              },
              child: const Text('View Services'),
            ),
          ),
        ],
      ),
    );
  }
}
