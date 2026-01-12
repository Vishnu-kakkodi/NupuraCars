// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:nupura_cars/views/CarService/service_booking_details_screen.dart';

// class ServiceBookingListScreen extends StatefulWidget {
//   const ServiceBookingListScreen({super.key,});

//   @override
//   State<ServiceBookingListScreen> createState() =>
//       _ServiceBookingListScreenState();
// }

// class _ServiceBookingListScreenState extends State<ServiceBookingListScreen> {
//   List bookings = [];
//   List filtered = [];

//   bool loading = true;
//   String search = '';
//   String statusFilter = 'all';
//   DateTime? selectedDate;
//     String? userId;


//   @override
//   void initState() {
//     super.initState();
//         _loadUserData();

//   }


//       Future<void> _loadUserData() async {
//     try {
//       userId = await StorageHelper.getUserId();

//       if (userId != null && mounted) {
//             setState(() {
//               userId = userId.toString();
//             });
        
//       }

//           _loadBookings();

//     } catch (e) {
//       if (mounted) {
//         _showError('Failed to load user data: ${e.toString()}');
//       }
//     }
//   }

//     void _showError(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(context).colorScheme.secondary,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   Future<void> _loadBookings() async {
//     setState(() => loading = true);

//     final res = await http.get(
//       Uri.parse(
//         'http://31.97.206.144:4072/api/users/allservicebooking/6937e191e514d9179b1c9f87',
//       ),
//     );

//     final data = jsonDecode(res.body);
//     bookings = data['bookings'];
//     filtered = bookings;

//     setState(() => loading = false);
//   }

//   void _applyFilters() {
//     filtered = bookings.where((b) {
//       final matchesSearch = search.isEmpty ||
//           b['packages']
//               .any((p) => p['packageName']
//                   .toString()
//                   .toLowerCase()
//                   .contains(search.toLowerCase()));

//       final matchesStatus = statusFilter == 'all' ||
//           b['bookingStatus'] == statusFilter;

//       final matchesDate = selectedDate == null ||
//           DateFormat('yyyy-MM-dd')
//                   .format(DateTime.parse(b['bookingDate'])) ==
//               DateFormat('yyyy-MM-dd').format(selectedDate!);

//       return matchesSearch && matchesStatus && matchesDate;
//     }).toList();

//     setState(() {});
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2030),
//       initialDate: DateTime.now(),
//     );

//     if (picked != null) {
//       selectedDate = picked;
//       _applyFilters();
//     }
//   }

//   Color _statusColor(String status) {
//     switch (status) {
//       case 'confirmed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Service Bookings'),
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // 🔍 Search
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search service / package',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onChanged: (v) {
//                       search = v;
//                       _applyFilters();
//                     },
//                   ),
//                 ),

//                 // 🎛 Filters
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Row(
//                     children: [
//                       DropdownButton<String>(
//                         value: statusFilter,
//                         items: const [
//                           DropdownMenuItem(value: 'all', child: Text('All')),
//                           DropdownMenuItem(
//                               value: 'confirmed', child: Text('Confirmed')),
//                           DropdownMenuItem(
//                               value: 'pending', child: Text('Pending')),
//                           DropdownMenuItem(
//                               value: 'cancelled', child: Text('Cancelled')),
//                         ],
//                         onChanged: (v) {
//                           statusFilter = v!;
//                           _applyFilters();
//                         },
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: _pickDate,
//                       ),
//                       if (selectedDate != null)
//                         IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () {
//                             selectedDate = null;
//                             _applyFilters();
//                           },
//                         ),
//                     ],
//                   ),
//                 ),

//                 const Divider(),

//                 // 📋 List
//                 Expanded(
//                   child: filtered.isEmpty
//                       ? const Center(child: Text('No bookings found'))
//                       : ListView.builder(
//                           itemCount: filtered.length,
//                           itemBuilder: (_, i) {
//                             final b = filtered[i];
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         ServiceBookingDetailsScreen(
//                                       booking: b,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 8),
//                                 padding: const EdgeInsets.all(14),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(14),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 8,
//                                     )
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       b['packages'][0]['packageName'],
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Text(
//                                       '₹${b['total']} • ${b['modeOfService']}',
//                                       style:
//                                           TextStyle(color: Colors.grey[700]),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           DateFormat('dd MMM yyyy').format(
//                                             DateTime.parse(b['bookingDate']),
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 4),
//                                           decoration: BoxDecoration(
//                                             color: _statusColor(
//                                                     b['bookingStatus'])
//                                                 .withOpacity(0.15),
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: Text(
//                                             b['bookingStatus'],
//                                             style: TextStyle(
//                                               color: _statusColor(
//                                                   b['bookingStatus']),
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 )
//               ],
//             ),
//     );
//   }
// }


















import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/CarService/service_booking_details_screen.dart';
import 'package:nupura_cars/widgects/BackControl/back_confirm_dialog.dart';

class ServiceBookingListScreen extends StatefulWidget {
  const ServiceBookingListScreen({super.key});

  @override
  State<ServiceBookingListScreen> createState() =>
      _ServiceBookingListScreenState();
}

class _ServiceBookingListScreenState extends State<ServiceBookingListScreen> {
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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      userId = await StorageHelper.getUserId();

      if (userId != null && mounted) {
        setState(() {
          userId = userId.toString();
        });
      }

      _loadBookings();
    } catch (e) {
      if (mounted) {
        _showError('Failed to load user data: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: cs.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _loadBookings() async {
    setState(() => loading = true);

    final res = await http.get(
      Uri.parse(
        'http://31.97.206.144:4072/api/users/allservicebooking/6937e191e514d9179b1c9f87',
      ),
    );

    final data = jsonDecode(res.body);
    bookings = data['bookings'];
    filtered = bookings;

    setState(() => loading = false);
  }

  void _applyFilters() {
    filtered = bookings.where((b) {
      final matchesSearch = search.isEmpty ||
          b['packages'].any(
            (p) => p['packageName']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase()),
          );

      final matchesStatus =
          statusFilter == 'all' || b['bookingStatus'] == statusFilter;

      final matchesDate = selectedDate == null ||
          DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(b['bookingDate'])) ==
              DateFormat('yyyy-MM-dd').format(selectedDate!);

      return matchesSearch && matchesStatus && matchesDate;
    }).toList();

    setState(() {});
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

  Color _statusColor(String status) {
    final cs = Theme.of(context).colorScheme;

    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return cs.error;
      default:
        return cs.outline;
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
        if (shouldExit) {
          Navigator.of(context).pop(); // exits app / screen
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Service Bookings'),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // 🔍 Search
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search service / package',
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
      
                  // 🎛 Filters
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
      
                  // 📋 List
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No bookings found'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final b = filtered[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ServiceBookingDetailsScreen(
                                        booking: b,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b['packages'][0]['packageName'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '₹${b['total']} • ${b['modeOfService']}',
                                        style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('dd MMM yyyy').format(
                                              DateTime.parse(b['bookingDate']),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _statusColor(
                                                      b['bookingStatus'])
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              b['bookingStatus'],
                                              style: TextStyle(
                                                color: _statusColor(
                                                    b['bookingStatus']),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
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
}
