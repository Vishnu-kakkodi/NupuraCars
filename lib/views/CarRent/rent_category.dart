
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/CarRent/car_rent_screen.dart';
import 'package:nupura_cars/views/CarService/service_booking_list_screen.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RentCategory extends StatefulWidget {
  const RentCategory({Key? key}) : super(key: key);

  static const int columns = 2;
  static const double spacing = 12.0;
  static const double outerPadding = 12.0;

  @override
  State<RentCategory> createState() => _RentCategoryState();
}

class _RentCategoryState extends State<RentCategory> {
  bool _loading = true;
  String? _error;
  List<CarRentCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await http.get(
        Uri.parse('http://31.97.206.144:4072/api/admin/allcarrentalcats'),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List list = body['data'];

        setState(() {
          _categories =
              list.map((e) => CarRentCategory.fromJson(e)).toList();
          _loading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final totalSpacing = RentCategory.spacing * (RentCategory.columns - 1);
    final usableWidth =
        mq.size.width - (RentCategory.outerPadding * 2) - totalSpacing;
    final itemWidth = usableWidth / RentCategory.columns;
    final itemHeight = itemWidth * 1.25;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Ride '),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(RentCategory.outerPadding),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : GridView.builder(
                    itemCount: _categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: RentCategory.columns,
                      crossAxisSpacing: RentCategory.spacing,
                      mainAxisSpacing: RentCategory.spacing,
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemBuilder: (_, index) {
                      final item = _categories[index];
                      return _ImageRentCard(
                        title: item.name,
                        imageUrl: item.image,
                        isActive: item.isActive,
                        onTap: () {
                          if (item.isActive) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CarRentScreen(),
                              ),
                            );
                          } else {
                            _showBookingEnquiry(context, item.name, item.id);
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }

  void _showBookingEnquiry(BuildContext context, String title, String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _BookingEnquiryModal(serviceTitle: title,carRentalCategoryId: id,),
    );
  }
}

/// ================= CATEGORY MODEL =================

class CarRentCategory {
  final String id;
  final String name;
  final String image;

  /// You can control this from backend later
  bool get isActive => name.toLowerCase() == 'self-drive cars';

  CarRentCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CarRentCategory.fromJson(Map<String, dynamic> json) {
    return CarRentCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

/// ================= IMAGE CARD =================

class _ImageRentCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isActive;
  final VoidCallback onTap;

  const _ImageRentCard({
    required this.title,
    required this.imageUrl,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.directions_car, size: 40),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // if (!isActive)
                  //   const Text(
                  //     'Enquiry Only',
                  //     style: TextStyle(
                  //       color: Colors.orangeAccent,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class _BookingEnquiryModal extends StatefulWidget {
  final String serviceTitle;
    final String carRentalCategoryId; // ✅ ADD THIS

  const _BookingEnquiryModal({required this.serviceTitle,    required this.carRentalCategoryId,
});

  @override
  State<_BookingEnquiryModal> createState() => _BookingEnquiryModalState();
}

class _BookingEnquiryModalState extends State<_BookingEnquiryModal> {
  String? _selectedSeats;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isProcessingPayment = false;

  final String _adminWhatsAppNumber = '919133905401';
  final String _adminCallNumber = '9133905401';
  final int _advanceAmount = 500;

  Razorpay? _razorpay;

  bool get _canProceed =>
      _selectedSeats != null && _startDate != null && _endDate != null;

  @override
  void initState() {
    super.initState();
    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
  }

  @override
  void dispose() {
    try {
      _razorpay?.clear();
    } catch (e) {}
    super.dispose();
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) {
    setState(() {
      _isProcessingPayment = false;
    });
    _showErrorDialog(
      'Payment Failed',
      'Code: ${response.code}\nDescription: ${response.message}',
    );
  }


Future<void> _createBooking({
  String? transactionId,
  int advancePaid = 0,
}) async {
  final userId = await StorageHelper.getUserId();

  if (userId == null || userId.isEmpty) {
    _showErrorDialog(
      'User Error',
      'User not logged in. Please login again.',
    );
    return;
  }

  final url = Uri.parse(
    'http://31.97.206.144:4072/api/users/commonbooking/$userId',
  );

  final payload = {
    'carRentalCategoryId': widget.carRentalCategoryId,
    'vehicleType': _selectedSeats,
    'startDate': DateFormat('yyyy-MM-dd').format(_startDate!),
    'endDate': DateFormat('yyyy-MM-dd').format(_endDate!),
    'advancePaid': advancePaid,
    if (transactionId != null) 'transactionId': transactionId,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (!mounted) return;

      _showSuccessDialog(
        advancePaid > 0
            ? 'Payment successful!\nOur team will contact you shortly.'
            : 'Booking enquiry submitted successfully.\nOur team will contact you.',
      );
    } else {
      _showErrorDialog('Booking Failed', response.body);
    }
  } catch (e) {
    _showErrorDialog('Error', e.toString());
  }
}



void _handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
  setState(() => _isProcessingPayment = true);

  await _createBooking(
    transactionId: response.paymentId,
    advancePaid: _advanceAmount,
  );

  setState(() => _isProcessingPayment = false);
}


  void _handleExternalWalletSelected(ExternalWalletResponse response) {
    _showErrorDialog(
      'External Wallet Selected',
      '${response.walletName}',
    );
  }

  Future<void> _proceedWithPayment() async {
    if (!_canProceed) {
      _showErrorDialog(
        'Incomplete Information',
        'Please select vehicle type, start date, and end date',
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      var options = {
        'key': 'rzp_test_RgqXPvDLbgEIVv', // Replace with your Razorpay key
        'amount': (_advanceAmount * 100), // Amount in paise
        'name': 'Car Service App.',
        'description': 'Booking Advance Payment - ${widget.serviceTitle}',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {
          'contact': '', // Add user mobile if available
          'email': '', // Add user email if available
        },
        'external': {
          'wallets': ['paytm'],
        },
      };

      _razorpay?.open(options);
    } catch (e) {
      setState(() {
        _isProcessingPayment = false;
      });
      _showErrorDialog('Payment Error', 'Error initiating payment: $e');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text(
              'Success',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigationScreen(initialIndex: 2,))),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isProcessingPayment,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        const Icon(Icons.directions_car, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.serviceTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _isProcessingPayment
                              ? null
                              : () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
if(widget.serviceTitle.toLowerCase().contains('airport'))
                    Center(
                      child: ElevatedButton(
                        onPressed: (){
                      _callNow();
                      }, child: Text("Immediate Call")),
                    ),
                    const SizedBox(height: 14),

                    /// SEATS
                    const Text(
                      'Select Vehicle Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SeatOptionCard(
                            seats: '5 Seats',
                            icon: Icons.airline_seat_recline_normal,
                            isSelected: _selectedSeats == '5 Seats',
                            onTap: () =>
                                setState(() => _selectedSeats = '5 Seats'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SeatOptionCard(
                            seats: '7 Seats',
                            icon: Icons.airline_seat_recline_extra,
                            isSelected: _selectedSeats == '7 Seats',
                            onTap: () =>
                                setState(() => _selectedSeats = '7 Seats'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// START DATE
                    const Text(
                      'Journey Start Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickStartDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 12),
                            Text(
                              _startDate == null
                                  ? 'Select start date'
                                  : DateFormat('MMM dd, yyyy')
                                      .format(_startDate!),
                              style: TextStyle(
                                fontSize: 15,
                                color: _startDate == null
                                    ? Colors.grey.shade600
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// END DATE
                    const Text(
                      'Journey End Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickEndDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 12),
                            Text(
                              _endDate == null
                                  ? 'Select end date'
                                  : DateFormat('MMM dd, yyyy').format(_endDate!),
                              style: TextStyle(
                                fontSize: 15,
                                color: _endDate == null
                                    ? Colors.grey.shade600
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// INFO BOX
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue.shade700, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Before paying ₹$_advanceAmount advance, connect us through call or WhatsApp',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _canProceed ? _callNow : null,
                            icon: const Icon(Icons.call, size: 18),
                            label: const Text('Call Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _canProceed ? _openWhatsApp : null,
                            icon: const Icon(Icons.chat, size: 18),
                            label: const Text('WhatsApp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// PROCEED BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _canProceed ? _proceedWithPayment : null,
                        icon: const Icon(Icons.payment, size: 20),
                        label: Text(
                          'Proceed - Pay ₹$_advanceAmount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Processing Overlay
          if (_isProcessingPayment)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Processing Payment...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please wait while we confirm your booking',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Reset end date if it's before start date
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      _showErrorDialog(
        'Select Start Date',
        'Please select journey start date first',
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _callNow() async {
    final uri = Uri.parse('tel:$_adminCallNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp() async {
    final dateRange = _startDate != null && _endDate != null
        ? 'from ${DateFormat('MMM dd').format(_startDate!)} to ${DateFormat('MMM dd, yyyy').format(_endDate!)}'
        : '';

    final msg = Uri.encodeComponent(
        'Hello, I want ${widget.serviceTitle} ($_selectedSeats) $dateRange');
    final uri = Uri.parse('https://wa.me/$_adminWhatsAppNumber?text=$msg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// ================= SEAT OPTION CARD =================

class _SeatOptionCard extends StatelessWidget {
  final String seats;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeatOptionCard({
    required this.seats,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
            const SizedBox(height: 8),
            Text(
              seats,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
