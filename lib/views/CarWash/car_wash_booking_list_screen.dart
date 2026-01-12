import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/widgects/BackControl/back_confirm_dialog.dart';
import 'car_wash_booking_details_screen.dart';

class CarWashBookingListScreen extends StatefulWidget {
  const CarWashBookingListScreen({super.key});

  @override
  State<CarWashBookingListScreen> createState() =>
      _CarWashBookingListScreenState();
}

class _CarWashBookingListScreenState extends State<CarWashBookingListScreen> {
  List bookings = [];
  List filtered = [];

  bool loading = true;
  String search = '';
  String statusFilter = 'all';
  DateTime? selectedDate;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userId = await StorageHelper.getUserId();
    if (userId != null) {
      _loadBookings();
    }
  }

  Future<void> _loadBookings() async {
    setState(() => loading = true);

    final res = await http.get(
      Uri.parse(
        'http://31.97.206.144:4072/api/users/allcarwashbooking/$userId',
      ),
    );

    final data = jsonDecode(res.body);
    bookings = data['carWashBookings'] ?? [];
    filtered = bookings;

    setState(() => loading = false);
  }

  void _applyFilters() {
    filtered = bookings.where((b) {
      final washName = b['carWash']?['name'] ?? '';

      final matchesSearch = search.isEmpty ||
          washName.toLowerCase().contains(search.toLowerCase());

      final matchesStatus = statusFilter == 'all' ||
          b['pickupStatus'] == statusFilter;

      final matchesDate = selectedDate == null ||
          DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(b['bookingDate'])) ==
              DateFormat('yyyy-MM-dd').format(selectedDate!);

      return matchesSearch && matchesStatus && matchesDate;
    }).toList();

    setState(() {});
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate = picked;
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await showBackConfirmDialog(context);
        if (shouldExit) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('My Car Wash Bookings')),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  /// 🔍 Search
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search wash',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (v) {
                        search = v;
                        _applyFilters();
                      },
                    ),
                  ),

                  /// 🎛 Filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          value: statusFilter,
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All')),
                            DropdownMenuItem(
                                value: 'confirmed', child: Text('Confirmed')),
                            DropdownMenuItem(
                                value: 'pending', child: Text('Pending')),
                            DropdownMenuItem(
                                value: 'cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (v) {
                            statusFilter = v!;
                            _applyFilters();
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                        if (selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              selectedDate = null;
                              _applyFilters();
                            },
                          ),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// 📋 List
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No bookings found'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final b = filtered[i];
                              final wash = b['carWash'];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CarWashBookingDetailsScreen(
                                        booking: b,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: cs.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      /// Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          wash?['image'] ?? '',
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.local_car_wash),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      /// Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              wash?['name'] ?? 'Car Wash',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${b['total']} • ${b['type']} • ${b['modeOfService']}',
                                              style: TextStyle(
                                                color:
                                                    cs.onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              DateFormat('dd MMM yyyy').format(
                                                DateTime.parse(
                                                    b['bookingDate']),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// Status
                                      Column(
                                        children: [
                                          _statusChip(
                                            b['pickupStatus'],
                                            _statusColor(
                                                b['pickupStatus']),
                                          ),
                                          const SizedBox(height: 6),
                                          _statusChip(
                                            b['paymentStatus'],
                                            Colors.green,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
