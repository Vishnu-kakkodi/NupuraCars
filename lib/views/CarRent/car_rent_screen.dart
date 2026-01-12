import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/models/CarModel/car_model.dart';
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/checkout_screen.dart';
import 'package:nupura_cars/views/CarList/car_list_screen.dart';
import 'package:nupura_cars/views/LocationScreen/location_search_screen.dart';
import 'package:nupura_cars/views/guest_modal.dart';

class CarRentScreen extends StatefulWidget {
  const CarRentScreen({super.key});

  @override
  State<CarRentScreen> createState() => _CarRentScreenState();
}

class _CarRentScreenState extends State<CarRentScreen> {
  String? userId;
  bool _isLoadingCurrentLocation = false;
  bool guest = false;

  // Theme colors
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
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

  Future<void> _loadUserData() async {
    try {
      userId = await StorageHelper.getUserId();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to load user data: ${e.toString()}');
      }
    }
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

  Future<void> _handleRefresh() async {
    try {
      await _handleCurrentLocation(guest);
      _loadCarsWithFilters(guest);

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

  Widget _buildFloatingGlassCarCard(Car car, BuildContext context) {
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

  Widget _buildLocationHeader() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getResponsiveValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LocationSearchScreen(userId: userId.toString()),
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
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: _cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Car Rentals',
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: _primaryColor,
        backgroundColor: _cardColor,
        strokeWidth: 3,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            
            // Location Header
            SliverToBoxAdapter(child: _buildLocationHeader()),
            
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            
            // Date Time Selector
            SliverToBoxAdapter(
              child: Consumer<DateTimeProvider>(
                builder: (context, dateTimeProvider, _) {
                  return _buildDateTimeSelector(context, dateTimeProvider);
                },
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            
            // Available Cars Header
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Cars',
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
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModernCarListScreen(guest: guest),
                          ),
                        );
                      },
                      icon: Text(
                        'View All',
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      label: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            
            // Cars List
            SliverToBoxAdapter(
              child: Container(
                height: getResponsiveValue(
                  context,
                  mobile: 380,
                  tablet: 380,
                  desktop: 400,
                ),
                child: Consumer<CarProvider>(
                  builder: (context, carProvider, child) {
                    final cars = carProvider.cars;

                    if (carProvider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: _primaryColor),
                            SizedBox(height: 16),
                            Text(
                              'Loading cars...',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (carProvider.hasError) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.all(24),
                          padding: EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Failed to load cars',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => _loadCarsWithFilters(guest),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (cars.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_outlined,
                              size: 64,
                              color: _textSecondary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No cars available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final validCars = cars.where((car) {
                      return car != null &&
                          car.name != null &&
                          car.name.isNotEmpty;
                    }).toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: validCars.length,
                      itemBuilder: (context, index) {
                        return _buildFloatingGlassCarCard(
                          validCars[index],
                          context,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}