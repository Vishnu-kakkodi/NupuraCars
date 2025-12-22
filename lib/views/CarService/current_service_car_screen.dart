import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupura_cars/models/ServiceModel/current_service_car_model.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/current_service_car_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// TODO: update this import & widget name to your actual main screen
// import 'package:nupura_cars/views/main_screen.dart';

class CurrentServiceCarScreen extends StatefulWidget {
  final String userId;
  final String serviceId;

  const CurrentServiceCarScreen({
    super.key,
    required this.userId,
    required this.serviceId,
  });

  @override
  State<CurrentServiceCarScreen> createState() =>
      _CurrentServiceCarScreenState();
}

class _CurrentServiceCarScreenState extends State<CurrentServiceCarScreen> {
  DateTime? _serviceDate;
  bool _isPickup = false;
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    // 🔥 Call API once when screen opens
    Future.microtask(() {
      context.read<CurrentServiceCarProvider>().loadCurrentServiceCar(
            userId: widget.userId,
            serviceId: widget.serviceId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: Consumer<CurrentServiceCarProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (provider.data == null) {
            return const Center(
              child: Text('No data found'),
            );
          }

          final CurrentServiceCar currentCar = provider.data!.currentCar;
          final List<ServicePlan> plans = provider.data!.plans;
          final ServicePlan? plan = plans.isNotEmpty ? plans.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Current Car',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCarCard(currentCar),

                const SizedBox(height: 24),
                Text(
                  'Selected Service',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (plan != null) ...[
                  _buildPlanCard(plan),
                  const SizedBox(height: 20),
                  _buildBookingSection(plan),
                ] else
                  _buildNoPlanCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- CAR CARD ----------------

  Widget _buildCarCard(CurrentServiceCar car) {
    final carInfo = car.carId;
    final imageUrl = carInfo.image ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 90,
                    height: 60,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => _carPlaceholder(),
                  )
                : _carPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carInfo.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${car.brandName} • ${car.fuelType}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  car.registrationNumber,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Variant: ${car.variant}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _carPlaceholder() {
    return Container(
      width: 90,
      height: 60,
      color: Colors.grey.shade200,
      child: const Icon(Icons.directions_car),
    );
  }

  // ---------------- PLAN / NO PLAN ----------------

  Widget _buildNoPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.orange,
            size: 22,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Not Available',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Service for your car is currently unavailable. '
                  'Please try another service or contact support for assistance.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(ServicePlan plan) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build_circle),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Service Price: ₹${plan.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            plan.description,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          // If you want fuel/variant:
          // const SizedBox(height: 8),
          // Text(
          //   'Fuel: ${plan.fuelType} • Variant: ${plan.variant}',
          //   style: TextStyle(
          //     fontSize: 12,
          //     color: Colors.grey.shade700,
          //   ),
          // ),
        ],
      ),
    );
  }

  // ---------------- BOOKING SECTION ----------------

  Widget _buildBookingSection(ServicePlan plan) {
    final theme = Theme.of(context);

    final bool hasValidPickupDates = !_isPickup ||
        (_pickupDate != null &&
            _pickupTime != null &&
            _serviceDate != null &&
            !_pickupDate!.isAfter(_serviceDate!));

    final bool isButtonEnabled =
        _serviceDate != null && hasValidPickupDates && !_isBooking;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Service',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Service Date
        GestureDetector(
          onTap: _pickServiceDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _serviceDate == null
                        ? 'Select service date'
                        : 'Service date: ${_formatDate(_serviceDate!)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: _serviceDate == null
                          ? Colors.grey.shade600
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Pickup toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pickup required?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: _isPickup,
              onChanged: (value) {
                setState(() {
                  _isPickup = value;
                  if (!_isPickup) {
                    _pickupDate = null;
                    _pickupTime = null;
                  }
                });
              },
            ),
          ],
        ),

        if (_isPickup) ...[
          const SizedBox(height: 12),

          // Pickup Date
          GestureDetector(
            onTap: _pickPickupDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pickupDate == null
                          ? 'Select pickup date'
                          : 'Pickup date: ${_formatDate(_pickupDate!)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _pickupDate == null
                            ? Colors.grey.shade600
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Pickup Time
          GestureDetector(
            onTap: _pickPickupTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pickupTime == null
                          ? 'Select pickup time'
                          : 'Pickup time: ${_formatTime(_pickupTime!)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _pickupTime == null
                            ? Colors.grey.shade600
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (!hasValidPickupDates)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Pickup date must be on or before the service date.',
                style: TextStyle(fontSize: 11, color: Colors.red.shade600),
              ),
            ),
        ],

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isButtonEnabled ? () => _bookService(plan) : null,
            child: _isBooking
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Book Service'),
          ),
        ),
      ],
    );
  }

  // ---------------- DATE/TIME PICKERS ----------------

  Future<void> _pickServiceDate() async {
    final now = DateTime.now();
    final initial = _serviceDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _serviceDate = DateTime(picked.year, picked.month, picked.day);

        // if pickup date is after new service date, reset pickup
        if (_pickupDate != null && _pickupDate!.isAfter(_serviceDate!)) {
          _pickupDate = null;
          _pickupTime = null;
        }
      });
    }
  }

  Future<void> _pickPickupDate() async {
    final now = DateTime.now();
    final initial = _pickupDate ?? _serviceDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      final selected = DateTime(picked.year, picked.month, picked.day);
      if (_serviceDate != null && selected.isAfter(_serviceDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pickup date cannot be after service date'),
          ),
        );
        return;
      }
      setState(() {
        _pickupDate = selected;
      });
    }
  }

  Future<void> _pickPickupTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _pickupTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  String _formatDateForApi(DateTime date) {
    // Backend example: "2025-12-15"
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // ---------------- API CALL ----------------

  Future<void> _bookService(ServicePlan plan) async {
    if (_serviceDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select service date')),
      );
      return;
    }

    if (_isPickup) {
      if (_pickupDate == null || _pickupTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select pickup date and time'),
          ),
        );
        return;
      }
      if (_pickupDate!.isAfter(_serviceDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pickup date cannot be after service date'),
          ),
        );
        return;
      }
    }

    setState(() {
      _isBooking = true;
    });

    try {
      // Make sure your ServicePlan model exposes Mongo `_id` as `id`.
      // If it's something like `sId`, update this line accordingly.
      final String planId = plan.id;

      final uri = Uri.parse(
          'http://31.97.206.144:4072/api/users/carservicebooking/${widget.userId}');

      final body = {
        "planId": planId,
        "serviceDate": _formatDateForApi(_serviceDate!),
        "isPickup": _isPickup,
        "pickupDate":
            _isPickup && _pickupDate != null ? _formatDateForApi(_pickupDate!) : null,
        "pickupTime":
            _isPickup && _pickupTime != null ? _formatTime(_pickupTime!) : null,
      };

      // Remove nulls from body
      body.removeWhere((key, value) => value == null);
      print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj$body");

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Add your auth headers if needed (e.g. Authorization)
        },
        body: jsonEncode(body),
      );

      print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj${response.body}");

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final bool isSuccess = data['isSuccessfull'] == true;

        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service booking created successfully'),
            ),
          );

          // Navigate to main screen
          // TODO: Replace with your main screen navigation
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (_) => const MainScreen()),
          //   (route) => false,
          // );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to book service'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to book service (Error: ${response.statusCode})'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }
}
