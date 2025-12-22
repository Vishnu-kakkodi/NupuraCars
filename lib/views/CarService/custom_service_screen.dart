import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/service_booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllServiceBookingScreen extends StatefulWidget {
  const AllServiceBookingScreen({super.key});

  @override
  State<AllServiceBookingScreen> createState() =>
      _AllServiceBookingScreenState();
}

class _AllServiceBookingScreenState extends State<AllServiceBookingScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _init();

  }


  Future<void> _init() async {
    await _loadUserDataa();

    if (userId != null && userId!.isNotEmpty) {
      if (!mounted) return;
      context.read<ServiceBookingProvider>().loadBookings(userId!);
    }
  }

    Future<void> _loadUserDataa() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId');
    } catch (e) {
      debugPrint('Error getting user ID: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Service Bookings")),
      body: Consumer<ServiceBookingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bookings.isEmpty) {
            return const Center(child: Text("No service bookings found"));
          }

          return ListView.builder(
            itemCount: provider.bookings.length,
            itemBuilder: (context, index) {
              final booking = provider.bookings[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Image.network(
                    booking.currentCar.image,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    booking.currentCar.modelName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${booking.plan.serviceName}"),
                      Text(
                        "${booking.plan.fuelType} • ${booking.plan.variant}",
                      ),
                      Text("Pickup: ${booking.pickupTime}"),
                      Text("Status: ${booking.status}"),
                                            Text("Status: ${booking.registrationNumber}"),

                    ],
                  ),
                  trailing: Text(
                    "₹${booking.total}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
