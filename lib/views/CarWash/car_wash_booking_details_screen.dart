// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class CarWashBookingDetailsScreen extends StatelessWidget {
//   final Map booking;
//   const CarWashBookingDetailsScreen({super.key, required this.booking});

//   @override
//   Widget build(BuildContext context) {
//     final car = booking['car'] as Map?;
//     final wash = booking['carWash'] as Map?;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Car Wash Booking Details')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// ================= WASH =================
//             _section(
//               'Car Wash',
//               [
//                 _row(
//                   'Wash Name',
//                   _value(wash?['name'] ?? wash?['washName']),
//                 ),
//                 _row(
//                   'Price',
//                   '₹${_value(wash?['price'] ?? booking['total'])}',
//                 ),
//                 if (wash?['seater'] != null)
//                   _row('Seater', _value(wash?['seater'])),
//               ],
//             ),

//             /// ================= CAR =================
//             if (car != null)
//               _section(
//                 'Car Details',
//                 [
//                   _row('Car Name', _value(car['name'])),
//                   _row('Brand', _value(car['brandName'])),
//                   _row('Fuel Type', _value(car['fuelType'])),
//                   _row('Variant', _value(car['variant'])),
//                   _row(
//                     'Registration No.',
//                     _value(car['registrationNumber']),
//                   ),
//                 ],
//               ),

//             /// ================= BOOKING =================
//             _section(
//               'Booking Information',
//               [
//                 _row(
//                   'Booking Date',
//                   _formatDate(booking['bookingDate']),
//                 ),
//                 _row(
//                   'Mode of Service',
//                   _value(booking['modeOfService']),
//                 ),
//                 _row(
//                   'Booking Status',
//                   _value(booking['bookingStatus']),
//                 ),
//                 _row(
//                   'Payment Mode',
//                   _value(booking['modeOfPayment']),
//                 ),
//                 _row(
//                   'Payment Status',
//                   _value(booking['paymentStatus']),
//                 ),
//               ],
//             ),

//             /// ================= PICKUP =================
//             if (booking['modeOfService'] == 'pickup')
//               _section(
//                 'Pickup Details',
//                 [
//                   _row(
//                     'Pickup Date',
//                     _formatDate(booking['pickupDate']),
//                   ),
//                   _row(
//                     'Pickup Time',
//                     _value(booking['pickupTime']),
//                   ),
//                   _row(
//                     'Address',
//                     _value(booking['location']?['address']),
//                   ),
//                   _row(
//                     'Pickup Status',
//                     _value(booking['pickupStatus']),
//                   ),
//                 ],
//               ),

//             /// ================= TOTAL =================
//             _section(
//               'Amount',
//               [
//                 _row(
//                   'Total Amount',
//                   '₹${_value(booking['total'])}',
//                 ),
//               ],
//             ),

//             /// ================= NOTE =================
//             if ((booking['note'] ?? '').toString().trim().isNotEmpty)
//               _section(
//                 'Note',
//                 [
//                   Text(
//                     booking['note'].toString(),
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --------------------------------------------------
//   // UI HELPERS
//   // --------------------------------------------------

//   /// Safely format any value
//   String _value(dynamic v) {
//     if (v == null) return '--';
//     if (v.toString().trim().isEmpty) return '--';
//     return v.toString();
//   }

//   /// Safely format date
//   String _formatDate(dynamic date) {
//     if (date == null) return '--';
//     try {
//       return DateFormat('dd MMM yyyy')
//           .format(DateTime.parse(date.toString()));
//     } catch (_) {
//       return '--';
//     }
//   }

//   Widget _section(String title, List<Widget> children) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           const Divider(),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _row(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(color: Colors.grey.shade700),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



















import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarWashBookingDetailsScreen extends StatelessWidget {
  final Map booking;
  const CarWashBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final car = booking['car'] as Map?;
    final wash = booking['carWash'] as Map?;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Wash Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= WASH =================
            _section(
              context,
              'Car Wash',
              [
                _row(
                  context,
                  'Wash Name',
                  _value(wash?['name'] ?? wash?['washName']),
                ),
                _row(
                  context,
                  'Price',
                  '₹${_value(wash?['price'] ?? booking['total'])}',
                ),
                if (wash?['seater'] != null)
                  _row(context, 'Seater', _value(wash?['seater'])),
              ],
            ),

            /// ================= CAR =================
            if (car != null)
              _section(
                context,
                'Car Details',
                [
                  _row(context, 'Car Name', _value(car['name'])),
                  _row(context, 'Brand', _value(car['brandName'])),
                  _row(context, 'Fuel Type', _value(car['fuelType'])),
                  _row(context, 'Variant', _value(car['variant'])),
                  _row(
                    context,
                    'Registration No.',
                    _value(car['registrationNumber']),
                  ),
                ],
              ),

            /// ================= BOOKING =================
            _section(
              context,
              'Booking Information',
              [
                _row(
                  context,
                  'Booking Date',
                  _formatDate(booking['bookingDate']),
                ),
                _row(
                  context,
                  'Mode of Service',
                  _value(booking['modeOfService']),
                ),
                _row(
                  context,
                  'Booking Status',
                  _value(booking['bookingStatus']),
                ),
                _row(
                  context,
                  'Payment Mode',
                  _value(booking['modeOfPayment']),
                ),
                _row(
                  context,
                  'Payment Status',
                  _value(booking['paymentStatus']),
                ),
              ],
            ),

            /// ================= PICKUP =================
            if (booking['modeOfService'] == 'pickup')
              _section(
                context,
                'Pickup Details',
                [
                  _row(
                    context,
                    'Pickup Date',
                    _formatDate(booking['pickupDate']),
                  ),
                  _row(
                    context,
                    'Pickup Time',
                    _value(booking['pickupTime']),
                  ),
                  _row(
                    context,
                    'Address',
                    _value(booking['location']?['address']),
                  ),
                  _row(
                    context,
                    'Pickup Status',
                    _value(booking['pickupStatus']),
                  ),
                ],
              ),

            /// ================= TOTAL =================
            _section(
              context,
              'Amount',
              [
                _row(
                  context,
                  'Total Amount',
                  '₹${_value(booking['total'])}',
                ),
              ],
            ),

            /// ================= NOTE =================
            if ((booking['note'] ?? '').toString().trim().isNotEmpty)
              _section(
                context,
                'Note',
                [
                  Text(
                    booking['note'].toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // UI HELPERS (THEME ENABLED)
  // --------------------------------------------------

  /// Safely format any value
  String _value(dynamic v) {
    if (v == null) return '--';
    if (v.toString().trim().isEmpty) return '--';
    return v.toString();
  }

  /// Safely format date
  String _formatDate(dynamic date) {
    if (date == null) return '--';
    try {
      return DateFormat('dd MMM yyyy')
          .format(DateTime.parse(date.toString()));
    } catch (_) {
      return '--';
    }
  }

  Widget _section(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: cs.onSurface,
            ),
          ),
          Divider(color: cs.outlineVariant),
          ...children,
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
