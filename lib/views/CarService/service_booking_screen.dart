import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/views/Location/location_picker.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class ServiceBookingScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String imageUrl;
  final String carBrand;
  final String carModel;
  final String carYear;
  final String carModification;
  

  const ServiceBookingScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
    required this.imageUrl,
    required this.carBrand,
    required this.carModel,
    required this.carYear,
    required this.carModification,
  }) : super(key: key);

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final String userId = '692468a7eef8da08eede6712';
  final int advanceAmount = 500; // Fixed advance amount

  String _mode = 'Pickup';
  String _notes = '';
  String _paymentMode = 'online'; // Default to online for advance payment

  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  DateTime? _bookingDate;

  bool isProcessingPayment = false;
  Razorpay? _razorpay;

  String name = '';
  String email = '';
  String mobile = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initRazorpay();
  }

  @override
  void dispose() {
    try {
      _razorpay?.clear();
    } catch (e) {}
    super.dispose();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _loadUserData() async {
    final userName = await StorageHelper.getUserName();
    final userEmail = await StorageHelper.getEmail();
    final userMobile = await StorageHelper.getMobile();

    setState(() {
      name = userName ?? '';
      email = userEmail ?? '';
      mobile = userMobile ?? '';
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isProcessingPayment = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _callBookingAPI(transactionId: response.paymentId);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  // Future<void> _callBookingAPI({String? transactionId}) async {
  //   final provider = context.read<LocationProvider>();

  //   final bool isPickup = _mode == 'Pickup';

  //   Map<String, dynamic> payload = {
  //     'userId': userId,
  //     'serviceId': widget.serviceId,
  //     'bookingDate': _bookingDate != null
  //         ? DateFormat('yyyy-MM-dd').format(_bookingDate!)
  //         : DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //     'note': _notes.isEmpty ? 'No special requirements' : _notes,
  //     'modeOfService': isPickup ? 'pickup' : 'walk-in',
  //     'modeOfPayment': _paymentMode,
  //     'isPickup': isPickup,
  //     'advanceAmount': advanceAmount,
  //     'carDetails': {
  //       'brand': widget.carBrand,
  //       'model': widget.carModel,
  //       'year': widget.carYear,
  //       'modification': widget.carModification,
  //     },
  //   };

  //   if (isPickup) {
  //     if (_pickupDate == null || _pickupTime == null) {
  //       _showError('Please select pickup date and time');
  //       return;
  //     }

  //     if (provider.address.isEmpty || provider.coordinates == null) {
  //       _showError('Please set pickup location');
  //       return;
  //     }

  //     payload.addAll({
  //       'pickupDate': DateFormat('yyyy-MM-dd').format(_pickupDate!),
  //       'pickupTime': _pickupTime!.format(context),
  //       'location': {
  //         'address': provider.address,
  //         'lat': provider.coordinates![0],
  //         'lng': provider.coordinates![1],
  //       },
  //     });
  //   }

  //   if (_paymentMode == 'online' && transactionId != null) {
  //     payload['transactionId'] = transactionId;
  //   }

  //   print('FINAL PAYLOAD 👉 ${jsonEncode(payload)}');

  //   try {
  //     final response = await http.post(
  //       Uri.parse('${ApiConstants.baseUrl}/users/carservicebooking/$userId'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(payload),
  //     );

  //     setState(() => isProcessingPayment = false);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Service booking created successfully!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );

  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (_) => MainNavigationScreen(initialIndex: 2),
  //         ),
  //         (_) => false,
  //       );
  //     } else {
  //       _showError(response.body);
  //     }
  //   } catch (e) {
  //     _showError(e.toString());
  //   }
  // }



  Future<void> _callBookingAPI({String? transactionId}) async {
  final provider = context.read<LocationProvider>();
  final bool isPickup = _mode == 'Pickup';

  if (isPickup) {
    if (_pickupDate == null || _pickupTime == null) {
      _showError('Please select pickup date and time');
      return;
    }

    if (provider.address.isEmpty || provider.coordinates == null) {
      _showError('Please set pickup location');
      return;
    }
  }

  try {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/users/carservicebooking/$userId',
    );

        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${widget.serviceId}");


    final request = http.MultipartRequest('POST', uri);

    /// ================= BASIC FIELDS =================
    request.fields['bookingDate'] = _bookingDate != null
        ? DateFormat('yyyy-MM-dd').format(_bookingDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    request.fields['note'] =
        _notes.isEmpty ? 'No special requirements' : _notes;

    request.fields['modeOfService'] = isPickup ? 'pickup' : 'walk-in';
    request.fields['modeOfPayment'] = _paymentMode;

    /// ================= SERVICE & CAR =================
    request.fields['carServiceId'] = widget.serviceId;
    request.fields['carBrand'] = widget.carBrand;
    request.fields['carName'] = widget.carModel; // backend uses carName
    request.fields['model'] = widget.carYear;   // backend uses model as year
    request.fields['modification'] = widget.carModification;

    /// ================= PICKUP DATA =================
    if (isPickup) {
      request.fields['pickupDate'] =
          DateFormat('yyyy-MM-dd').format(_pickupDate!);

      request.fields['pickupTime'] = _pickupTime!.format(context);

      request.fields['address'] = provider.address;
      request.fields['lat'] = provider.coordinates![0].toString();
      request.fields['lng'] = provider.coordinates![1].toString();
    }

    /// ================= ONLINE PAYMENT =================
    if (_paymentMode == 'online' && transactionId != null) {
      request.fields['transactionId'] = transactionId;
    }

    /// ================= DEBUG =================
    debugPrint('FINAL FORM DATA 👉');
    request.fields.forEach((k, v) => debugPrint('$k : $v'));

    setState(() => isProcessingPayment = true);

    final streamedResponse = await request.send();
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${widget.serviceId}");
    final responseBody =
        await streamedResponse.stream.bytesToString();

    setState(() => isProcessingPayment = false);

    print('STATUS CODE 👉 ${streamedResponse.statusCode}');
print('RESPONSE BODY 👉 $responseBody');

    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(initialIndex: 2),
        ),
        (_) => false,
      );
    } else {
      _showError(responseBody);
    }
  } catch (e) {
    setState(() => isProcessingPayment = false);
    _showError(e.toString());
  }
}





  void _showError(String message) {
    if (!mounted) return;
    setState(() => isProcessingPayment = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _selectPickupDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _pickupDate = picked);
    }
  }

  Future<void> _selectPickupTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _pickupTime = picked);
    }
  }

  Future<void> _selectBookingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _bookingDate = picked);
    }
  }

  Widget _pickupLocationSection() {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LocationPickerScreen(isEditing: false, userId: userId),
              ),
            );
          },
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: provider.isLoading
                      ? const Text('Fetching location...')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.address.isNotEmpty
                                  ? provider.address
                                  : 'Set pickup location',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (provider.coordinates != null)
                              Text(
                                'Lat: ${provider.coordinates![0]}, Lng: ${provider.coordinates![1]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bookingDateTimeSection() {
    return GestureDetector(
      onTap: _selectBookingDate,
      child: _whiteCard(
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _bookingDate == null
                    ? 'Select booking date'
                    : '${_bookingDate!.day}/${_bookingDate!.month}/${_bookingDate!.year}',
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _pickupDateTimeSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectPickupDate,
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupDate == null
                        ? 'Select pickup date'
                        : '${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}',
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectPickupTime,
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupTime == null
                        ? 'Select pickup time'
                        : _pickupTime!.format(context),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showNotesModal() {
    final ctrl = TextEditingController(text: _notes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Any other requirements',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write instructions for service team...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() => _notes = ctrl.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout() {
    // Validate booking date
    if (_bookingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select booking date')),
      );
      return;
    }

    // Validate pickup fields if pickup mode
    if (_mode == 'Pickup') {
      if (_pickupDate == null || _pickupTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select pickup date and time')),
        );
        return;
      }

      final provider = context.read<LocationProvider>();
      if (provider.address.isEmpty || provider.coordinates == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set pickup location')),
        );
        return;
      }
    }

    setState(() {
      isProcessingPayment = true;
    });

    // Always use online payment for advance amount
    var options = {
      'key': 'rzp_test_RgqXPvDLbgEIVv',
      'amount': (advanceAmount * 100), // Fixed ₹500 advance
      'name': 'Car Service',
      'description': '${widget.serviceName} - Advance Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      setState(() {
        isProcessingPayment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initiating payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isProcessingPayment,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          title: const Text(
            'Book Service',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed:
                isProcessingPayment ? null : () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  /// SERVICE ITEM
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.car_repair),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${widget.carBrand} ${widget.carModel}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '${widget.carYear} • ${widget.carModification}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// NOTES
                  GestureDetector(
                    onTap: _showNotesModal,
                    child: _whiteCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _notes.isEmpty
                                  ? 'Any other requirements…'
                                  : _notes,
                              style: TextStyle(
                                color: _notes.isEmpty
                                    ? (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade400
                                        : Colors.grey)
                                    : null,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _bookingDateTimeSection(),

                  const SizedBox(height: 14),

                  /// MODE OF SERVICE
                  _whiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mode of Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Pickup',
                              groupValue: _mode,
                              onChanged: (v) => setState(() => _mode = v!),
                            ),
                            const Text('Pickup'),
                            Radio<String>(
                              value: 'Walk In',
                              groupValue: _mode,
                              onChanged: (v) => setState(() => _mode = v!),
                            ),
                            const Text('Walk In'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (_mode == 'Pickup') ...[
                    const SizedBox(height: 14),
                    _pickupDateTimeSection(),
                    const SizedBox(height: 14),
                    _pickupLocationSection(),
                  ],

                  const SizedBox(height: 14),

                  /// ADVANCE PAYMENT INFO
                  _whiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Advance Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pay ₹$advanceAmount now to confirm your booking. Remaining amount will be collected after service completion.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// BILL SUMMARY
                  _whiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _billRow('Advance Amount', advanceAmount),
                        const SizedBox(height: 4),
                        Text(
                          'Balance amount to be paid after service',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        const Divider(height: 20),
                        _billRow('Pay Now', advanceAmount, bold: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            /// CHECKOUT BAR
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advance Payment',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.black54,
                            ),
                          ),
                          Text(
                            '₹ $advanceAmount',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isProcessingPayment ? null : _checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isProcessingPayment
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Pay & Confirm',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            /// PROCESSING OVERLAY
            if (isProcessingPayment)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Processing Payment...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please wait while we confirm your booking',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _billRow(String title, int value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
        ),
        Text(
          '₹ $value',
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : null,
            fontSize: bold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}