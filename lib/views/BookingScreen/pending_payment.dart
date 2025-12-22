// pending_payment_screen.dart
import 'dart:convert';
import 'package:nupura_cars/models/BookingModel/booking_model.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/booking_screen.dart';
import 'package:nupura_cars/views/BookingScreen/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PendingPayment extends StatefulWidget {
  final Booking booking;

  const PendingPayment({Key? key, required this.booking}) : super(key: key);

  @override
  State<PendingPayment> createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> {
  Razorpay? _razorpay;
  bool _isProcessing = false;

  // API base - change if needed
  final String baseUrl = 'http://31.97.206.144:4072/api';

  @override
  void initState() {
    super.initState();
    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    try {
      _razorpay?.clear();
    } catch (_) {}
    super.dispose();
  }

  int get rentalCost => widget.booking.amount;
  int get carWashAmount => widget.booking.carWashAmount ?? 0;
  int get depositAmount => widget.booking.depositAmount ?? 0;
  int get advancePayment => widget.booking.advancePayment ?? 0;
  int get remainingAmount {
    // prefer explicit remainingAmount if API supplies it
    if (widget.booking.remainingAmount != null) return widget.booking.remainingAmount!;
    // fallback compute
    final int computed = (rentalCost + carWashAmount + depositAmount) - advancePayment;
    return computed >= 0 ? computed : 0;
  }

  bool get paymentCompleted =>
      widget.booking.completePayment == true ||
      (widget.booking.paymentStatus?.toLowerCase() == 'completed');

  Future<void> _startRazorpayPayment() async {
    if (paymentCompleted) return;

    setState(() => _isProcessing = true);

    try {
      final int amountToPay = remainingAmount; // currency units (INR)
      final options = {
        'key': 'rzp_live_R7WEc7UNXkN075', // replace if required
        'amount': amountToPay * 100, // paise
        'name': widget.booking.car.name,
        'description': 'Remaining booking payment',
        'prefill': {
          'contact': widget.booking.car != null ? '' : '', // you can prefill from profile
          'email': ''
        },
        'currency': 'INR'
      };

      _razorpay?.open(options);
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnack('Error initiating payment: $e');
    }
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) async {
    // response.paymentId
    try {
      setState(() => _isProcessing = true);

      // userId: prefer StorageHelper, fallback to booking.userId
      String? userId = await StorageHelper.getUserId();
      if (userId == null || userId.isEmpty) {
        userId = widget.booking.userId;
      }

      final String url =
          '$baseUrl/users/complete-payment/${userId}/${widget.booking.id}';

      final payload = {
        "transactionId": response.paymentId ?? '',
        "totalRemainingPayment": remainingAmount,
      };

      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      setState(() => _isProcessing = false);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // success - navigate to PaymentSuccess and BookingScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => PaymentSuccessScreen()),
          (route) => false,
        );
      } else {
        final body = res.body;
        _showSnack('Payment succeeded but API returned ${res.statusCode}: $body');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnack('Failed to complete payment: $e');
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    setState(() => _isProcessing = false);
    _showSnack('Payment failed: ${response.code} - ${response.message}');
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    _showSnack('External wallet selected: ${response.walletName}');
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
          Text(value,
              style: TextStyle(
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
                  fontSize: highlight ? 16 : 14,
                  color: highlight ? Colors.teal : Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Payment'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.booking.car.name,
                        style:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.teal, Colors.blue]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '₹${widget.booking.amount}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Dates
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pickup: ${_formatDate(widget.booking.rentalStartDate)}  •  ${widget.booking.from}'),
                        const SizedBox(height: 8),
                        Text('Return: ${_formatDate(widget.booking.rentalEndDate)}  •  ${widget.booking.to}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Price summary
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildPriceRow('Rental', '₹$rentalCost'),
                        if (carWashAmount > 0) _buildPriceRow('Car wash', '₹$carWashAmount'),
                        _buildPriceRow(
                          'Security deposit',
                          depositAmount > 0 ? '₹$depositAmount' : (widget.booking.deposit ?? '—'),
                        ),
                        _buildPriceRow('Advance paid', '₹$advancePayment'),
                        const Divider(),
                        _buildPriceRow('Remaining', '₹$remainingAmount', highlight: true),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Car wash / payment status badges
                Row(
                  children: [
                    if (widget.booking.isCarWash == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Car wash added'),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: paymentCompleted ? Colors.green[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(paymentCompleted ? 'Payment completed' : 'Payment pending'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Pay button (only if not completed)
                if (!paymentCompleted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _startRazorpayPayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          : Text('Pay ₹$remainingAmount',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }
}
