import 'package:nupura_cars/models/BookingModel/booking_model.dart';
import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/pending_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nupura_cars/widgects/BackControl/back_confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  late String userId;
  bool isLoading = true;
  bool _isModalOpen = false;
  bool _isRefreshing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _currentDate = "";

  // Theme colors
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    DateTime now = DateTime.now();
    _currentDate = DateFormat('yyyy-MM-dd').format(now);
    print("📅 Current date: $_currentDate");

    _getUserIdAndFetchDocuments();

    Future.delayed(Duration.zero, () {
      _loadBookings();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _restartUI() async {
    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });

      try {
        _animationController.reset();
        await Future.wait([_getUserIdAndFetchDocuments(), _loadBookings()]);
        await _animationController.forward();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Bookings refreshed successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } catch (e) {
        print('Error refreshing UI: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Failed to refresh bookings'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isRefreshing = false;
          });
        }
      }
    }
  }

  Future<void> _onRefresh() async {
    await _restartUI();
  }

  Future<void> _getUserIdAndFetchDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';

      if (userId.isNotEmpty) {
        await Provider.of<DocumentProvider>(
          context,
          listen: false,
        ).fetchDocuments(userId);
      } else {
        print('User ID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error getting user ID: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadBookings() async {
    try {
      String? userId = await StorageHelper.getUserId();
      if (userId != null) {
        await Provider.of<BookingProvider>(
          context,
          listen: false,
        ).loadBookings(userId);
        print('Bookings loaded successfully');
      } else {
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print('Error loading bookings: $e');
    }
  }

  Future<void> _openGoogleMaps(coordinates) async {
    print('Opening Google Maps with coordinates: ${coordinates[0]}');
    try {
      if (coordinates.length >= 2) {
        final double longitude = coordinates[0].toDouble();
        final double latitude = coordinates[1].toDouble();
        print('Latitude: $latitude');
        print('Longitude: $longitude');

        final String googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

        final String googleMapsAppUrl =
            'google.navigation:q=$latitude,$longitude';

        bool launched = false;

        try {
          launched = await launchUrl(
            Uri.parse(googleMapsAppUrl),
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          print('Could not launch Google Maps app: $e');
        }

        if (!launched) {
          launched = await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        }

        if (!launched) {
          _showErrorDialog(
            'Could not open Google Maps. Please check if you have Google Maps installed.',
          );
        }
      } else {
        _showErrorDialog('Location coordinates are not available.');
      }
    } catch (e) {
      print('Error opening Google Maps: $e');
      _showErrorDialog('Failed to open Google Maps: $e');
    }
  }

  void _handlePayRemaining(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendingPayment(booking: booking),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _cardColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_amber, color: Colors.red, size: 24),
            ),
            SizedBox(width: 12),
            Text("Alert", style: TextStyle(fontWeight: FontWeight.bold, color: _textPrimary)),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 16, color: _textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: _primaryColor.withOpacity(0.1),
              foregroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("OK", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showDocumentsModal(Booking booking) {
    setState(() {
      _isModalOpen = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            // Modern handle bar
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: _textSecondary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Enhanced header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor.withOpacity(0.05), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primaryColor, _secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Car Documents',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _textPrimary,
                          ),
                        ),
                        Text(
                          'View all car documentation',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _dividerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.close, size: 20, color: _textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(child: _buildDocumentsList(booking)),
          ],
        ),
      ),
    ).whenComplete(() {
      setState(() {
        _isModalOpen = false;
      });
    });
  }

  Widget _buildDocumentsList(Booking booking) {
    final List<String> carDocs = booking.car.carDocs ?? [];

    print("Car documents URLs: $carDocs");

    if (carDocs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _dividerColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                size: 80,
                color: _textSecondary,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No documents uploaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Documents will appear here once uploaded',
              style: TextStyle(
                fontSize: 16,
                color: _textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: carDocs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildDocumentCard(carDocs[index], index + 1),
        );
      },
    );
  }

  Widget _buildDocumentCard(String url, int documentNumber) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _surfaceColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _dividerColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 32,
                        color: _textSecondary,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: _primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document $documentNumber',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to view full size',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _accentColor],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _showFullScreenImage(url),
                icon: Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Document',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: _backgroundColor,
            body: PopScope(
              canPop: false,
                   onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await showBackConfirmDialog(context);
        if (shouldExit) {
          Navigator.of(context).pop(); // exits app / screen
        }
      },
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: _primaryColor,
                child: CustomScrollView(
                  slivers: [
                    // Enhanced App Bar with new design
                    SliverAppBar(
                      expandedHeight: 140,
                      floating: false,
                      pinned: false,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _primaryColor,
                                _secondaryColor,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
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
                                bottom: -30,
                                left: -30,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Text(
                        "My Bookings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _isRefreshing ? null : _restartUI,
                              icon: _isRefreshing
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
              
                    // Enhanced Tab Bar
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverTabBarDelegate(
                        Container(
                          color: _backgroundColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TabBar(
                              isScrollable: true,
                              padding: const EdgeInsets.all(8),
                              tabAlignment: TabAlignment.start,
                              indicator: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [_primaryColor, _secondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: _textSecondary,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              tabs: const [
                                Tab(text: "Confirmed"),
                                Tab(text: "Active"),
                                Tab(text: "Completed"),
                                Tab(text: "Cancelled"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              
                    // Content with enhanced animations
                    SliverFillRemaining(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Consumer<BookingProvider>(
                            builder: (context, bookingProvider, child) {
                              if (bookingProvider.isLoading || _isRefreshing) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: _cardColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: _primaryColor.withOpacity(0.2),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: CircularProgressIndicator(
                                          color: _primaryColor,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      Text(
                                        'Loading bookings...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: _textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
              
                              final confirmedBookings = bookingProvider.bookings
                                  .where((booking) => booking.status == "confirmed")
                                  .toList();
              
                              final activeBookings = bookingProvider.bookings
                                  .where((booking) => booking.status == "active")
                                  .toList();
              
                              final completedBookings = bookingProvider.bookings
                                  .where((booking) => booking.status == "completed")
                                  .toList();
              
                              final cancelledBookings = bookingProvider.bookings
                                  .where((booking) => booking.status == "cancelled")
                                  .toList();
              
                              return TabBarView(
                                physics: const ClampingScrollPhysics(),
                                children: [
                                  _buildBookingList(
                                    confirmedBookings,
                                    "No confirmed bookings yet",
                                    Icons.schedule,
                                  ),
                                  _buildBookingList(
                                    activeBookings,
                                    "No active bookings",
                                    Icons.directions_car,
                                  ),
                                  _buildBookingList(
                                    completedBookings,
                                    "No completed bookings",
                                    Icons.check_circle,
                                  ),
                                  _buildBookingList(
                                    cancelledBookings,
                                    "No cancelled bookings",
                                    Icons.cancel,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (_isModalOpen)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const SizedBox.expand(),
          ),
      ],
    );
  }

  Widget _buildBookingList(List<Booking> bookings, String emptyMessage, IconData emptyIcon) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                emptyIcon,
                size: 80,
                color: _textSecondary,
              ),
            ),
            SizedBox(height: 32),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your bookings will appear here',
              style: TextStyle(
                fontSize: 16,
                color: _textSecondary,
              ),
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isRefreshing ? null : _restartUI,
                icon: _isRefreshing
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.refresh, size: 20),
                label: Text(
                  _isRefreshing ? 'Refreshing...' : 'Refresh',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildModernBookingCard(bookings[index]),
        );
      },
    );
  }

  Widget _buildModernBookingCard(Booking booking) {
    final int rentalCost = booking.amount ?? 0;
    final int carWashAmt = (booking.carWashAmount ?? 0);
    final int depositAmt = (booking.depositAmount ?? 0);
    final int advanceAmt = (booking.advancePayment ?? booking.advancePaymentAmount ?? 0);
    final int remainingAmt = (booking.remainingAmount ??
        (rentalCost + carWashAmt + depositAmt - advanceAmt));
    final bool paymentCompleted = (booking.completePayment == true) ||
        ((booking.paymentStatus ?? '').toString().toLowerCase() == 'completed');

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top gradient bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(booking.status),
                  _getStatusColor(booking.status).withOpacity(0.3),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: name, otp chip (if applicable), id chip
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.car.name ?? booking.car.name ?? 'Car',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              // _buildStatusChip(booking.status),
                              // SizedBox(width: 8),
                              if (booking.isPending || booking.isActive) ...[
                                Builder(builder: (context) {
                                  try {
                                    final now = DateTime.now();
                                    final dateOnly = booking.rentalStartDate;
                                    final timeOnly = booking.from ?? '';
                                    final timeFormat = DateFormat("hh:mm a");
                                    final parsedTime = timeFormat.parse(timeOnly);
                                    final pickupTime = DateTime(
                                      dateOnly.year,
                                      dateOnly.month,
                                      dateOnly.day,
                                      parsedTime.hour,
                                      parsedTime.minute,
                                    );

                                    final showOtp = now.isAfter(
                                      pickupTime.subtract(const Duration(hours: 1)),
                                    );

                                    if (showOtp) {
                                      final otpValue = booking.isPending
                                          ? (booking.otp?.toString() ?? "N/A")
                                          : (booking.returnOTP?.toString() ?? "N/A");
                                      if(otpValue != '0'){
                                        return _buildOtpChip(otpValue);
                                      }
                                    }
                                  } catch (_) {
                                    // parsing failed — silently ignore OTP chip
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ],
                              if (!booking.isCancelled && !booking.isCompleted) ...[
                                SizedBox(width: 8),
                                _buildInfoChip(
                                  "ID: ${booking.id != null && booking.id.length >= 4 ? booking.id.substring(booking.id.length - 4) : booking.id}",
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Car image
                    Container(
                      width: 90,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            _dividerColor,
                            _surfaceColor,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: (booking.car.image != null && booking.car.image.isNotEmpty)
                            ? Image.network(
                                booking.car.image[0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, _, __) {
                                  return Icon(Icons.directions_car, size: 36, color: _textSecondary);
                                },
                              )
                            : Icon(Icons.directions_car, size: 36, color: _textSecondary),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Car details (type/seats)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildCarDetail(
                        Icons.settings,
                        (booking.car.type ?? booking.car.carType)?.toString().toLowerCase() == 'automatic'
                            ? "Automatic"
                            : "Manual",
                        _accentColor,
                      ),
                      SizedBox(width: 32),
                      _buildCarDetail(
                        Icons.people,
                        "${booking.car.seats ?? 0} Seats",
                        Colors.green,
                      ),
                      // SizedBox(width: 32),
                      // _buildCarDetail(
                      //   Icons.local_gas_station,
                      //   booking.car.fuel ?? "Petrol",
                      //   Colors.orange,
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Date info (pickup / return / extended)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _dividerColor, width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildDateInfo(
                        "Pickup",
                        booking.rentalStartDate,
                        booking.from ?? '',
                        Icons.flight_takeoff,
                        _primaryColor,
                      ),
                      SizedBox(height: 12),
                      Divider(color: _dividerColor, height: 1),
                      SizedBox(height: 12),
                      _buildDateInfo(
                        "Return",
                        booking.isCompleted ? booking.rentalEndDate : booking.deliveryDate,
                        booking.isCompleted ? booking.to ?? '' : booking.deliveryTime ?? '',
                        Icons.flight_land,
                        _secondaryColor,
                      ),
                      if (booking.extensions.isNotEmpty) ...[
                        SizedBox(height: 12),
                        Divider(color: _dividerColor, height: 1),
                        SizedBox(height: 12),
                        _buildDateInfo(
                          "Extended",
                          booking.rentalEndDate,
                          booking.to ?? '',
                          Icons.update,
                          Colors.orange,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // PRICE SUMMARY
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _dividerColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textPrimary)),
                      SizedBox(height: 12),

                      // rental
                      _buildPriceRow("Car Rental", "₹${rentalCost-carWashAmt-depositAmt}"),
                      SizedBox(height: 8),

                      // car wash
                      if (booking.isCarWash == true) ...[
                        _buildPriceRow("Car Wash", "₹$carWashAmt"),
                        SizedBox(height: 8),
                      ],

                      // deposit
                      _buildPriceRow("Security Deposit", depositAmt > 0 ? "₹$depositAmt" : (booking.deposit ?? "—")),
                      SizedBox(height: 8),

                      // advance
                      _buildPriceRow("Advance Paid", "₹$advanceAmt"),
                      SizedBox(height: 12),

                      Divider(height: 1, color: _dividerColor),
                      SizedBox(height: 12),

                      // total
                      _buildPriceRow("Total Amount", "₹${(rentalCost + carWashAmt + depositAmt)}", isTotal: true),
                      SizedBox(height: 8),

                      // remaining
                      if (!paymentCompleted)
                        _buildPriceRow("Remaining Amount", "₹$remainingAmt", isRemaining: true),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // ACTIONS: Documents / Location / Pay Remaining (if applicable)
                if (booking.isActive || !booking.isCancelled) ...[
                  Row(
                    children: [
                      if (booking.isActive && booking.car.carDocs != null && booking.car.carDocs!.isNotEmpty)
                        Expanded(
                          child: _buildModernActionButton(
                            Icons.description,
                            "Documents",
                            _primaryColor,
                            () => _showDocumentsModal(booking),
                          ),
                        ),

                      if (booking.isActive && booking.car.carDocs != null && booking.car.carDocs!.isNotEmpty)
                        SizedBox(width: 12),

                      if (!booking.isCancelled)
                        Expanded(
                          child: _buildModernActionButton(
                            Icons.location_on,
                            "Location",
                            _accentColor,
                            () => _openGoogleMaps(booking.branch.coordinates),
                          ),
                        ),

                      if (!paymentCompleted && !booking.isCancelled) ...[
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _handlePayRemaining(booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: Text("Pay Remaining", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Cancelled overlay
          if (booking.isCancelled)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8), 
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16), 
                        decoration: BoxDecoration(
                          color: Colors.red, 
                          shape: BoxShape.circle
                        ), 
                        child: Icon(Icons.cancel, color: Colors.white, size: 32)
                      ),
                      SizedBox(height: 12),
                      Text("CANCELLED", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool isRemaining = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isRemaining ? Colors.red : (isTotal ? _primaryColor : _textPrimary),
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor = _getStatusColor(status).withOpacity(0.1);
    Color textColor = _getStatusColor(status);
    IconData icon;

    switch (status.toLowerCase()) {
      case 'confirmed':
        icon = Icons.schedule;
        break;
      case 'active':
        icon = Icons.directions_car;
        break;
      case 'completed':
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        icon = Icons.cancel;
        break;
      default:
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpChip(String otp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.orange.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.key, size: 14, color: Colors.white),
          SizedBox(width: 6),
          Text(
            "OTP: $otp",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _dividerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _dividerColor, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCarDetail(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: _textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, DateTime date, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "${_formatDate(date)}, $time",
                style: TextStyle(
                  fontSize: 14,
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernActionButton(IconData icon, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }
}

// Enhanced SliverPersistentHeaderDelegate
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _widget;

  _SliverTabBarDelegate(this._widget);

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}