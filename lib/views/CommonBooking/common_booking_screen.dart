import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class CommonBookingsScreen extends StatefulWidget {
  
  const CommonBookingsScreen({super.key});

  @override
  State<CommonBookingsScreen> createState() => _CommonBookingsScreenState();
}

class _CommonBookingsScreenState extends State<CommonBookingsScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<CommonBooking> confirmedBookings = [];
  List<CommonBooking> completedBookings = [];
  List<CommonBooking> cancelledBookings = [];
  String? errorMessage;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  Color get _secondaryColor => Theme.of(context).colorScheme.primaryContainer;
  Color get _accentColor => Theme.of(context).colorScheme.secondary;
  Color get _backgroundColor => Theme.of(context).colorScheme.background;
  Color get _cardColor => Theme.of(context).cardColor;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _surfaceColor => Theme.of(context).colorScheme.surface;
  Color get _dividerColor => Theme.of(context).dividerColor;
     String? userId;


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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _fetchBookings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
          userId = await StorageHelper.getUserId();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4072/api/users/getcommonbooking/${userId.toString()}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['bookings'] != null) {
          final List<dynamic> bookingsJson = data['bookings'];
          final allBookings = bookingsJson.map((j) => CommonBooking.fromJson(j)).toList();
          
          setState(() {
            confirmedBookings = allBookings.where((b) => 
              b.bookingStatus?.toLowerCase() == 'confirmed').toList();
            completedBookings = allBookings.where((b) => 
              b.bookingStatus?.toLowerCase() == 'completed').toList();
            cancelledBookings = allBookings.where((b) => 
              b.bookingStatus?.toLowerCase() == 'cancelled').toList();
            isLoading = false;
          });
          _animationController.forward();
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load bookings';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: RefreshIndicator(
          onRefresh: _fetchBookings,
          color: _primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_primaryColor, _secondaryColor],
                      ),
                    ),
                  ),
                ),
                title: Text("My Bookings", style: TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
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
                        onPressed: isLoading ? null : _fetchBookings,
                        icon: isLoading
                            ? SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                            : Icon(Icons.refresh_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),

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
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: TabBar(
                        padding: const EdgeInsets.all(8),
                        indicator: BoxDecoration(
                          gradient: LinearGradient(colors: [_primaryColor, _secondaryColor]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: _textSecondary,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        tabs: const [
                          Tab(text: "Confirmed"),
                          Tab(text: "Completed"),
                          Tab(text: "Cancelled"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverFillRemaining(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _primaryColor, strokeWidth: 3),
            SizedBox(height: 24),
            Text('Loading bookings...', 
              style: TextStyle(fontSize: 16, color: _textSecondary)),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: 24),
            Text('Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(errorMessage!, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: _textSecondary)),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchBookings,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: TabBarView(
          children: [
            _buildBookingList(confirmedBookings, "No confirmed bookings", Icons.schedule),
            _buildBookingList(completedBookings, "No completed bookings", Icons.check_circle),
            _buildBookingList(cancelledBookings, "No cancelled bookings", Icons.cancel),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<CommonBooking> bookings, String msg, IconData icon) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: _textSecondary),
            SizedBox(height: 32),
            Text(msg, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: _buildBookingCard(bookings[index]),
      ),
    );
  }

  Widget _buildBookingCard(CommonBooking booking) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getStatusColor(booking.bookingStatus ?? ''),
                  _getStatusColor(booking.bookingStatus ?? '').withOpacity(0.3)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getBookingTitle(booking),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildChip(booking.bookingStatus ?? 'Unknown', 
                                _getStatusColor(booking.bookingStatus ?? '')),
                              _buildChip(booking.bookingType ?? 'Type', Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_getBookingImage(booking) != null)
                      Container(
                        width: 90, height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: _surfaceColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _getBookingImage(booking)!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              _getBookingIcon(booking.bookingType), size: 36)),
                        ),
                      ),
                  ],
                ),

                if (booking.bookingDate != null || booking.modeOfService != null)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        if (booking.bookingDate != null)
                          _buildInfoRow(Icons.calendar_today, "Booking Date",
                            _formatDate(booking.bookingDate!)),
                        if (booking.modeOfService != null) ...[
                          SizedBox(height: 12),
                          _buildInfoRow(Icons.delivery_dining, "Service Mode",
                            booking.modeOfService!.toUpperCase()),
                        ],
                        if (booking.pickupDate != null && booking.pickupTime != null) ...[
                          SizedBox(height: 12),
                          _buildInfoRow(Icons.schedule, "Pickup",
                            "${_formatDate(booking.pickupDate!)} at ${booking.pickupTime}"),
                        ],
                      ],
                    ),
                  ),

                if (booking.total != null || booking.advancePaid != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Payment", style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 12),
                        if (booking.total != null)
                          _buildPayRow("Total", "₹${booking.total}"),
                        if (booking.advancePaid != null) ...[
                          SizedBox(height: 8),
                          _buildPayRow("Advance", "₹${booking.advancePaid}"),
                        ],
                        if (booking.paymentStatus != null) ...[
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(booking.paymentStatus == 'paid' 
                                ? Icons.check_circle : Icons.pending,
                                size: 16, color: booking.paymentStatus == 'paid' 
                                ? Colors.green : Colors.orange),
                              SizedBox(width: 8),
                              Text(booking.paymentStatus!.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold,
                                  color: booking.paymentStatus == 'paid' 
                                  ? Colors.green : Colors.orange)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                if (booking.location?.address != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(child: Text(booking.location!.address!)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _primaryColor),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: _textSecondary)),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: _textSecondary)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getBookingTitle(CommonBooking b) {
    return b.carWashName ?? b.productName ?? b.categoryName ?? 'Booking';
  }

  String? _getBookingImage(CommonBooking b) {
    return b.carWashImage ?? b.productImage ?? b.categoryImage;
  }

  IconData _getBookingIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'car wash': return Icons.local_car_wash;
      case 'car rental': return Icons.directions_car;
      case 'car decor': return Icons.style;
      default: return Icons.bookmark;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed': return Colors.blue;
      case 'completed': return Colors.purple;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _widget;
  _SliverTabBarDelegate(this._widget);

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => _widget;
  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}

// Models
class CommonBooking {
  final String? bookingType, bookingId, carWashName, carWashImage;
  final String? productName, productImage, categoryName, categoryImage;
  final String? vehicleType, modeOfService, pickupTime, transactionId;
  final String? paymentStatus, bookingStatus, type;
  final BookingLocation? location;
  final DateTime? bookingDate, startDate, endDate, pickupDate;
  final int? total, advancePaid;

  CommonBooking({
    this.bookingType, this.bookingId, this.carWashName, this.carWashImage,
    this.productName, this.productImage, this.categoryName, this.categoryImage,
    this.vehicleType, this.modeOfService, this.pickupTime, this.transactionId,
    this.paymentStatus, this.bookingStatus, this.type, this.location,
    this.bookingDate, this.startDate, this.endDate, this.pickupDate,
    this.total, this.advancePaid,
  });

  factory CommonBooking.fromJson(Map<String, dynamic> json) {
    return CommonBooking(
      bookingType: json['bookingType'] as String?,
      bookingId: json['bookingId'] as String?,
      carWashName: json['carWashName'] as String?,
      carWashImage: json['carWashImage'] as String?,
      productName: json['productName'] as String?,
      productImage: json['productImage'] as String?,
      categoryName: json['categoryName'] as String?,
      categoryImage: json['categoryImage'] as String?,
      vehicleType: json['vehicleType'] as String?,
      modeOfService: json['modeOfService'] as String?,
      pickupTime: json['pickupTime'] as String?,
      transactionId: json['transactionId'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      bookingStatus: json['bookingStatus'] as String?,
      type: json['type'] as String?,
      location: json['location'] != null 
        ? BookingLocation.fromJson(json['location']) : null,
      bookingDate: json['bookingDate'] != null 
        ? DateTime.parse(json['bookingDate']) : null,
      startDate: json['startDate'] != null 
        ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null 
        ? DateTime.parse(json['endDate']) : null,
      pickupDate: json['pickupDate'] != null 
        ? DateTime.parse(json['pickupDate']) : null,
      total: json['total'] as int?,
      advancePaid: json['advancePaid'] as int?,
    );
  }
}

class BookingLocation {
  final String? address;
  final double? lat, lng;

  BookingLocation({this.address, this.lat, this.lng});

  factory BookingLocation.fromJson(Map<String, dynamic> json) {
    return BookingLocation(
      address: json['address'] as String?,
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }
}