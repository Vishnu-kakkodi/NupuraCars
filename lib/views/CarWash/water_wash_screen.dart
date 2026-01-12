// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nupura_cars/constants/api_constants.dart';
// import 'package:nupura_cars/views/CarService/New/service_card.dart';
// import 'package:nupura_cars/views/CarService/New/water_wash_detail.dart';
// import 'package:nupura_cars/views/CarService/select_brand_screen.dart';
// import 'package:nupura_cars/views/HomeScreen/current_car.dart';
// import 'package:provider/provider.dart';
// import 'package:nupura_cars/views/CarService/New/detailing_screen.dart';
// import 'package:nupura_cars/models/MyCarModel/car_models.dart';
// import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

// class WaterWashScreen extends StatefulWidget {
//   const WaterWashScreen({Key? key}) : super(key: key);

//   static const int columns = 4;
//   static const double spacing = 12.0;
//   static const double outerPadding = 12.0;

//   @override
//   State<WaterWashScreen> createState() => _WaterWashScreenState();
// }

// class _WaterWashScreenState extends State<WaterWashScreen> {
//   bool _isLoading = true;
//   String _error = '';
//   List<Map<String, dynamic>> _services = [];

//   bool _checkedCar = false; // 🔥 prevent multiple modal calls

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     /// ✅ CHECK USER CARS FIRST
//     if (!_checkedCar) {
//       _checkedCar = true;

//       final carProvider = context.read<MyCarProvider>();

//       if (carProvider.myCars.isEmpty) {
//         /// ❌ NO CAR → SHOW ADD CAR MODAL
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _showAddCarSheet(context);
//         });

//         setState(() {
//           _isLoading = false;
//         });
//       } else {
//         /// ✅ HAS CAR → CALL CAR WASH API
//         _fetchServices();
//       }
//     }
//   }

//   /// 🔥 FETCH CAR WASH LIST (ONLY WHEN USER HAS CAR)
//   Future<void> _fetchServices() async {
//     try {
//       final userId = await StorageHelper.getUserId();

//       if (userId == null) {
//         _setError('User not logged in');
//         return;
//       }

//       final res = await http.get(
//         Uri.parse(
//           '${ApiConstants.baseUrl}/users/getcarwashlist/$userId',
//         ),
//       );

//       print("lllllllllllllllllllll${res.body}");

//       if (res.statusCode == 200) {
//         final decoded = jsonDecode(res.body);

//         if (decoded['isSuccessfull'] == true) {
//           final List list = decoded['carWashes'];

//           setState(() {
//             _services = list.map((e) {
//               return {
//                 'id': e['_id'],
//                 'title': e['washName'],
//                 'image': e['image']?['url'] ?? '',
//                 'price': e['price'],
//                 'benefits': e['benefits'],
//                 'seater': e['seater'],
//               };
//             }).toList();

//             _isLoading = false;
//           });
//         } else {
//           _setError(decoded['message'] ?? 'Failed to load car washes');
//         }
//       } else {
//         _setError('Server error ${res.statusCode}');
//       }
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   void _setError(String msg) {
//     setState(() {
//       _error = msg;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final screenWidth = mq.size.width;

//     final totalSpacing = WaterWashScreen.spacing * (WaterWashScreen.columns - 1);
//     final usableWidth =
//         screenWidth - (WaterWashScreen.outerPadding * 2) - totalSpacing;

//     final itemWidth = usableWidth / WaterWashScreen.columns;
//     final itemHeight = itemWidth * 1.45;
//     final childAspectRatio = itemWidth / itemHeight;

//     final myCarProvider = Provider.of<MyCarProvider>(context);
//     final UserCar? currentCar = myCarProvider.currentCar ??
//         (myCarProvider.myCars.isNotEmpty ? myCarProvider.myCars.first : null);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Water Wash'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         actions: [
//           if (currentCar != null)
//             Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => CurrentCarScreen()),
//                   );
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.network(
//                       currentCar.car!.image,
//                       height: 28,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         currentCar.car!.name ?? 'My Car',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(WaterWashScreen.outerPadding),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _error.isNotEmpty
//                 ? Center(child: Text(_error))
//                 : GridView.builder(
//                     itemCount: _services.length,
//                     gridDelegate:
//                         SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: WaterWashScreen.columns,
//                       crossAxisSpacing: WaterWashScreen.spacing,
//                       mainAxisSpacing: WaterWashScreen.spacing,
//                       childAspectRatio: childAspectRatio,
//                     ),
//                     itemBuilder: (context, index) {
//                       final item = _services[index];

//                       return ServiceCard(
//                         title: item['title'],
//                         imageUrl: item['image'],
//                         cellWidth: itemWidth,
//                         cellHeight: itemHeight,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   CarWashDetailScreen(washId: item['id'],),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//       ),
//     );
//   }

//   /// 🔔 ADD CAR BOTTOM SHEET (UNCHANGED)
//   void _showAddCarSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false,
//       enableDrag: false,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//       ),
//       builder: (ctx) => SizedBox(
//         height: 220,
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               'No cars found',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(12),
//               child: Text(
//                 'Add a car to continue booking services',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(ctx);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => SelectBrandScreen()),
//                         );
//                       },
//                       child: const Text('Add Car'),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }










import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/views/CarService/service_card.dart';
import 'package:nupura_cars/views/CarWash/water_wash_detail.dart';

class WaterWashScreen extends StatefulWidget {
  const WaterWashScreen({Key? key}) : super(key: key);

  static const int columns = 4;
  static const double spacing = 12.0;
  static const double outerPadding = 12.0;

  @override
  State<WaterWashScreen> createState() => _WaterWashScreenState();
}

class _WaterWashScreenState extends State<WaterWashScreen> {
  bool _isLoading = true;
  String _error = '';
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  /// 🔥 FETCH CAR WASHES (ADMIN API)
  Future<void> _fetchServices() async {
    try {
      final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/admin/getcarwashes'),
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded['isSuccessfull'] == true &&
            decoded['carWashes'] is List) {
          final List list = decoded['carWashes'];

          setState(() {
            _services = list.map<Map<String, dynamic>>((e) {
              /// Normalize benefits (API sends mixed formats)
              List<String> benefits = [];
              if (e['benefits'] is List) {
                benefits = e['benefits']
                    .expand<String>((b) {
                      if (b is String && b.startsWith('[')) {
                        return List<String>.from(jsonDecode(b));
                      }
                      return [b.toString()];
                    })
                    .toList();
              }

              return {
                'id': e['_id'] ?? '',
                'title': e['washName'] ?? '',
                'image': e['image']?['url'] ?? '',
                'price': e['price'] ?? 0,
                'benefits': benefits,
                'seater': e['seater'] ?? '',
              };
            }).toList();

            _error = '';
            _isLoading = false;
          });
          return;
        }

        _setError('No car wash services available');
        return;
      }

      _setError('Unable to load car wash services');
    } catch (e) {
      _setError('Something went wrong');
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

    final totalSpacing =
        WaterWashScreen.spacing * (WaterWashScreen.columns - 1);
    final usableWidth =
        screenWidth - (WaterWashScreen.outerPadding * 2) - totalSpacing;

    final itemWidth = usableWidth / WaterWashScreen.columns;
    final itemHeight = itemWidth * 1.45;
    final childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Wash'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(WaterWashScreen.outerPadding),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text(_error))
                : GridView.builder(
                    itemCount: _services.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: WaterWashScreen.columns,
                      crossAxisSpacing: WaterWashScreen.spacing,
                      mainAxisSpacing: WaterWashScreen.spacing,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final item = _services[index];

                      return ServiceCard(
                        title: item['title'],
                        imageUrl: item['image'],
                        cellWidth: itemWidth,
                        cellHeight: itemHeight,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarWashDetailScreen(
                                serviceId: item['id'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
