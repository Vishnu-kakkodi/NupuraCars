import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/views/CarService/New/service_card.dart';
import 'package:nupura_cars/views/CarService/select_brand_screen.dart';
import 'package:nupura_cars/views/HomeScreen/current_car.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/views/CarService/New/detailing_screen.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  static const int columns = 4;
  static const double spacing = 12.0;
  static const double outerPadding = 12.0;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _isLoading = true;
  String _error = '';
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final res = await http.get(
        Uri.parse('http://31.97.206.144:4072/api/admin/allservicenames'),
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded['success'] == true) {
          final List list = decoded['services'];

          setState(() {
            _services = list.map((e) {
              return {
                'id': e['_id'],
                'title': e['serviceName'],
                'image': e['image']?['url'] ?? '',
              };
            }).toList();
            _isLoading = false;
          });
        } else {
          _setError('Failed to load services');
        }
      } else {
        _setError('Server error ${res.statusCode}');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setError(String msg) {
    setState(() {
      _error = msg;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;

    final totalSpacing = ServicesScreen.spacing * (ServicesScreen.columns - 1);
    final usableWidth =
        screenWidth - (ServicesScreen.outerPadding * 2) - totalSpacing;

    final itemWidth = usableWidth / ServicesScreen.columns;
    final itemHeight = itemWidth * 1.45;
    final childAspectRatio = itemWidth / itemHeight;

    final myCarProvider = Provider.of<MyCarProvider>(context);
    final UserCar? currentCar = myCarProvider.currentCar ??
        (myCarProvider.myCars.isNotEmpty ? myCarProvider.myCars.first : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
actions: [
  if (currentCar != null)
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CurrentCarScreen()),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// CAR IMAGE
            Image.network(
              currentCar.car!.image,
              height: 28,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 4),

            /// CAR NAME LABEL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                currentCar.car!.name ?? 'My Car', // or brandName / model
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
],

      ),
      body: Padding(
        padding: const EdgeInsets.all(ServicesScreen.outerPadding),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text(_error))
                : GridView.builder(
                    itemCount: _services.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ServicesScreen.columns,
                      crossAxisSpacing: ServicesScreen.spacing,
                      mainAxisSpacing: ServicesScreen.spacing,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final item = _services[index];

                      return ServiceCard(
                        title: item['title'],
                        imageUrl: item['image'],
                        cellWidth: itemWidth,
                        cellHeight: itemHeight,
                        onTap: () async {
                          final hasCars =
                              myCarProvider.myCars.isNotEmpty;

                          if (!hasCars) {
                            _showAddCarSheet(context);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ServiceDetailSinglePageScreen(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }

  void _showAddCarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => SizedBox(
        height: 220,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'No cars found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Add a car to continue booking services',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SelectBrandScreen()),
                        );
                      },
                      child: const Text('Add Car'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
