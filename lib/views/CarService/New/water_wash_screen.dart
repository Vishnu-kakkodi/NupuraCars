
// services_screen_with_car_flow.dart
import 'package:flutter/material.dart';
import 'package:nupura_cars/views/CarService/New/service_card.dart';
import 'package:nupura_cars/views/CarService/select_brand_screen.dart';
import 'package:nupura_cars/views/HomeScreen/current_car.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/views/CarService/New/detailing_screen.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';

final List<Map<String, String>> services = [
  {"title": "Detailing Services", "icon": "https://cdn-icons-png.flaticon.com/512/3097/3097089.png"},
  {"title": "Tyres & Wheel Care", "icon": "https://cdn-icons-png.flaticon.com/512/3155/3155478.png"},
  {"title": "Batteries", "icon": "https://cdn-icons-png.flaticon.com/512/2917/2917995.png"},
  {"title": "Car Inspections", "icon": "https://cdn-icons-png.flaticon.com/512/2642/2642960.png"},
  {"title": "Clutch & Body Parts", "icon": "https://cdn-icons-png.flaticon.com/512/4564/4564892.png"},
  {"title": "Windshield & Lights", "icon": "https://cdn-icons-png.flaticon.com/512/2927/2927285.png"},
  {"title": "Suspension & Fitments", "icon": "https://cdn-icons-png.flaticon.com/512/4295/4295458.png"},
  {"title": "Insurance Claims", "icon": "https://cdn-icons-png.flaticon.com/512/3774/3774336.png"},
];

class WaterWashScreen extends StatefulWidget {
  const WaterWashScreen({Key? key}) : super(key: key);

  static const int columns = 4;
  static const double spacing = 12.0;
  static const double outerPadding = 12.0;
  static const double cardRadius = 12.0;

  @override
  State<WaterWashScreen> createState() => _WaterWashScreenState();
}

class _WaterWashScreenState extends State<WaterWashScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;

    // compute item width based on screen width and paddings
    final totalHorizontalPadding = WaterWashScreen.outerPadding * 2;
    final totalSpacing = WaterWashScreen.spacing * (WaterWashScreen.columns - 1);
    final usableWidth = screenWidth - totalHorizontalPadding - totalSpacing;
    final itemWidth = usableWidth / WaterWashScreen.columns;

    // Choose an item height that comfortably fits image + title.
    final itemHeight = itemWidth * 1.45;
    final childAspectRatio = itemWidth / itemHeight;

    // Access provider
    final myCarProvider = Provider.of<MyCarProvider>(context);
    final UserCar? currentCar = myCarProvider.currentCar ??
        (myCarProvider.myCars.isNotEmpty ? myCarProvider.myCars.first : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wash Section'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Show current car image + name when available
          if (currentCar != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  // Open screen when tapping current car
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CurrentCarScreen()),
                  );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: (currentCar.car?.image != null && currentCar.car!.image.isNotEmpty)
                          ? NetworkImage(currentCar.car!.image)
                          : null,
                      child: (currentCar.car?.image == null || currentCar.car!.image.isEmpty)
                          ? const Icon(Icons.directions_car, size: 18, color: Colors.black54)
                          : null,
                    ),
                    // const SizedBox(width: 8),
                    // ConstrainedBox(
                    //   constraints: const BoxConstraints(maxWidth: 120),
                    //   child: Text(
                    //     currentCar.brandName.isNotEmpty ? currentCar.brandName : currentCar.registrationNumber,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(WaterWashScreen.outerPadding),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: WaterWashScreen.columns,
            crossAxisSpacing: WaterWashScreen.spacing,
            mainAxisSpacing: WaterWashScreen.spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            return ServiceCard(
              title: item['title'] ?? '',
              imageUrl: item['icon'] ?? '',
              cellWidth: itemWidth,
              cellHeight: itemHeight,
              onTap: () async {
                // BEFORE navigating to detailing screen, check if user has cars
                final hasCars = (myCarProvider.myCars.isNotEmpty);
                if (!hasCars) {
                  // Show modal bottom sheet prompting to add car
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    builder: (ctx) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: SizedBox(
                        height: 220,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'No cars found',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'You need to add a car before booking services. Add a car now to continue.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        // Navigate to AddCarScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => SelectBrandScreen()),
                                        );
                                      },
                                      child: const Text('Add Car'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // proceed to service details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServiceDetailSinglePageScreen()),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
