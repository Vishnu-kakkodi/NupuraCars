import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceBookingDetailsScreen extends StatelessWidget {
  final Map booking;
  const ServiceBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final user = booking['userId'];
    final car = booking['carId'];
    final packages = booking['packages'] as List;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= SERVICE =================
            _section(
              context,
              'Service Details',
              packages.map<Widget>((p) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      p['image']['url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.build, color: cs.primary),
                    ),
                  ),
                  title: Text(
                    p['packageName'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '₹${p['offerPrice']} • ${p['serviceId']['serviceName']}',
                  ),
                );
              }).toList(),
            ),

            /// ================= CAR INFO =================
            if (car != null)
              _section(
                context,
                'Car Information',
                [
                  _row(context, 'Car Name', car['name'] ?? '--'),
                  _row(context, 'Brand', car['brandName'] ?? '--'),
                  _row(context, 'Variant', car['variant'] ?? '--'),
                  _row(context, 'Fuel Type', car['fuelType'] ?? '--'),
                  _row(
                    context,
                    'Registration No.',
                    car['registrationNumber'] ?? '--',
                  ),
                ],
              ),

            /// ================= USER INFO =================
            if (user != null)
              _section(
                context,
                'Customer Information',
                [
                  _row(context, 'Name', user['name'] ?? '--'),
                  _row(context, 'Email', user['email'] ?? '--'),
                  _row(context, 'Mobile', user['mobile'] ?? '--'),
                ],
              ),

            /// ================= BOOKING INFO =================
            _section(
              context,
              'Booking Information',
              [
                _row(
                  context,
                  'Booking Date',
                  DateFormat('dd MMM yyyy').format(
                    DateTime.parse(booking['bookingDate']),
                  ),
                ),
                _row(
                  context,
                  'Mode of Service',
                  booking['modeOfService'].toString().toUpperCase(),
                ),
                _row(
                  context,
                  'Booking Status',
                  booking['bookingStatus'],
                ),
                _row(
                  context,
                  'Payment Mode',
                  booking['modeOfPayment'],
                ),
                _row(
                  context,
                  'Payment Status',
                  booking['paymentStatus'],
                ),
              ],
            ),

            /// ================= PICKUP =================
            if (booking['isPickup'] == true)
              _section(
                context,
                'Pickup Details',
                [
                  _row(
                    context,
                    'Pickup Date',
                    DateFormat('dd MMM yyyy').format(
                      DateTime.parse(booking['pickupDate']),
                    ),
                  ),
                  _row(context, 'Pickup Time', booking['pickupTime']),
                  _row(
                    context,
                    'Address',
                    booking['location']?['address'] ?? '--',
                  ),
                  _row(
                    context,
                    'Pickup Status',
                    booking['pickupStatus'],
                  ),
                ],
              ),

            /// ================= AMOUNT =================
            _section(
              context,
              'Amount Details',
              [
                _row(context, 'Subtotal', '₹${booking['subTotal']}'),
                _row(
                  context,
                  'Total Amount',
                  '₹${booking['total']}',
                ),
              ],
            ),

            /// ================= NOTE =================
            if (booking['note'] != null &&
                booking['note'].toString().isNotEmpty)
              _section(
                context,
                'Note',
                [
                  Text(
                    booking['note'],
                    style: const TextStyle(fontSize: 14),
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
              style: TextStyle(color: cs.onSurfaceVariant),
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
