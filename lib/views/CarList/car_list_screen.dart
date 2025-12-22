// import 'package:nupura_cars/models/CarModel/car_model.dart';
// import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
// import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
// import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:nupura_cars/views/BookingScreen/checkout_screen.dart';
// import 'package:nupura_cars/views/LocationScreen/location_search_screen.dart';
// import 'package:nupura_cars/views/guest_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class ModernCarListScreen extends StatefulWidget {
//   final bool guest;
//   const ModernCarListScreen({super.key, required this.guest});

//   @override
//   State<ModernCarListScreen> createState() => _ModernCarListScreenState();
// }

// class _ModernCarListScreenState extends State<ModernCarListScreen> 
//     with TickerProviderStateMixin {
//   String? userId;
//   final TextEditingController _searchController = TextEditingController();
//   late AnimationController _headerAnimationController;
//   late AnimationController _listAnimationController;
//   late Animation<double> _headerAnimation;
//   late Animation<double> _listAnimation;
  
//   String _selectedCarType = 'All';
//   String _selectedType = 'All';
//   String _selectedFuelType = 'All';

//   List<String> get _Types {
//     final provider = Provider.of<CarProvider>(context, listen: false);
//     final Set<String> uniqueTypes = {'All'};
    
//     final allCars = provider.allCars ?? provider.cars;
    
//     for (final car in allCars) {
//       if (car.type != null && car.type!.isNotEmpty) {
//         uniqueTypes.add(car.type!);
//       }
//     }
    
//     return uniqueTypes.toList();
//   }

//   List<String> get _carTypes {
//     final provider = Provider.of<CarProvider>(context, listen: false);
//     final Set<String> uniqueTypes = {'All'};
    
//     final allCars = provider.allCars ?? provider.cars;
    
//     for (final car in allCars) {
//       if (car.type != null && car.type!.isNotEmpty) {
//         uniqueTypes.add(car.type!);
//       }
//       if (car.carType != null && car.carType!.isNotEmpty) {
//         uniqueTypes.add(car.carType!);
//       }
//     }
    
//     return uniqueTypes.toList();
//   }

//   final List<String> _fuelTypes = ['All', 'Petrol', 'Diesel', 'Electric', 'Hybrid'];

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadUserDataAndCars();
//   }

//   void _initializeAnimations() {
//     _headerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _listAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOut),
//     );
//     _listAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _listAnimationController, curve: Curves.easeOut),
//     );

//     _headerAnimationController.forward();
//   }

//   Future<void> _loadUserDataAndCars() async {
//     try {
//       userId = await StorageHelper.getUserId();
//       if (mounted) {
//         await _loadCarsWithFilters();
//         _listAnimationController.forward();
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Failed to load user data: ${e.toString()}');
//       }
//     }
//   }

//   Future<void> _loadCarsWithFilters() async {
//     final provider = Provider.of<CarProvider>(context, listen: false);
//     final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);

//     String? startDateStr;
//     String? endDateStr;
//     String? startTimeStr;
//     String? endTimeStr;

//     if (dateTimeProvider.startDate != null) {
//       final startDate = dateTimeProvider.startDate!;
//       startDateStr = '${startDate.year}/${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')}';
//     }

//     if (dateTimeProvider.endDate != null) {
//       final endDate = dateTimeProvider.endDate!;
//       endDateStr = '${endDate.year}/${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}';
//     }

//     if (dateTimeProvider.startTime != null) {
//       final startTime = dateTimeProvider.startTime!;
//       startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
//     }

//     if (dateTimeProvider.endTime != null) {
//       final endTime = dateTimeProvider.endTime!;
//       endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
//     }

//     await provider.initCars(
//       userId: userId,
//       startDate: startDateStr,
//       endDate: endDateStr,
//       startTime: startTimeStr,
//       endTime: endTimeStr,
//       carType: _selectedCarType == 'All' ? null : _selectedCarType,
//       type: _selectedType == 'All' ? null : _selectedType,
//       fuel: _selectedFuelType == 'All' ? null : _selectedFuelType,
//     );
//   }

//   Future<void> _applyFilters() async {
//     final provider = Provider.of<CarProvider>(context, listen: false);
//     final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);

//     String? startDateStr;
//     String? endDateStr;
//     String? startTimeStr;
//     String? endTimeStr;

//     if (dateTimeProvider.startDate != null) {
//       final startDate = dateTimeProvider.startDate!;
//       startDateStr = '${startDate.year}/${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')}';
//     }

//     if (dateTimeProvider.endDate != null) {
//       final endDate = dateTimeProvider.endDate!;
//       endDateStr = '${endDate.year}/${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}';
//     }

//     if (dateTimeProvider.startTime != null) {
//       final startTime = dateTimeProvider.startTime!;
//       startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
//     }

//     if (dateTimeProvider.endTime != null) {
//       final endTime = dateTimeProvider.endTime!;
//       endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
//     }

//     await provider.applyFilters(
//       userId: userId,
//       carType: _selectedCarType == 'All' ? null : _selectedCarType,
//       type: _selectedType == 'All' ? null : _selectedType,
//       fuel: _selectedFuelType == 'All' ? null : _selectedFuelType,
//       startDate: startDateStr,
//       endDate: endDateStr,
//       startTime: startTimeStr,
//       endTime: endTimeStr,
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange[700],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _headerAnimationController.dispose();
//     _listAnimationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<CarProvider>();
//     final locationProvider = context.watch<LocationProvider>();
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       body: CustomScrollView(
//         slivers: [
//           _buildMinimalAppBar(context, locationProvider, isDark),
//           _buildCompactSearch(context, isDark),
//           _buildCarGrid(context, provider, isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildMinimalAppBar(BuildContext context, LocationProvider locationProvider, bool isDark) {
//     return SliverAppBar(
//       expandedHeight: 100,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       surfaceTintColor: Colors.transparent,
//       leading: AnimatedBuilder(
//         animation: _headerAnimation,
//         builder: (context, child) {
//           return Opacity(
//             opacity: _headerAnimation.value,
//             child: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: isDark ? Colors.white : const Color(0xFF2D3748),
//                   size: 18,
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           );
//         },
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         background: AnimatedBuilder(
//           animation: _headerAnimation,
//           builder: (context, child) {
//             return Opacity(
//               opacity: _headerAnimation.value,
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(60, 15, 20, 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Browse Cars',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w700,
//                           color: isDark ? Colors.white : const Color(0xFF2D3748),
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: () => _navigateToLocationSearch(),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.orange[100],
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.location_pin,
//                                 color: Colors.orange[700],
//                                 size: 14,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 locationProvider.isLoading
//                                     ? "Locating..."
//                                     : locationProvider.hasError
//                                         ? "Add location"
//                                         : _truncateLocation(locationProvider.address),
//                                 style: TextStyle(
//                                   color: Colors.orange[700],
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCompactSearch(BuildContext context, bool isDark) {
//     return SliverToBoxAdapter(
//       child: AnimatedBuilder(
//         animation: _headerAnimation,
//         builder: (context, child) {
//           return Opacity(
//             opacity: _headerAnimation.value,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: isDark ? const Color(0xFF404040) : const Color(0xFFE2E8F0),
//                           width: 1,
//                         ),
//                       ),
//                       child: TextField(
//                         controller: _searchController,
//                         onChanged: (value) {
//                           final provider = Provider.of<CarProvider>(context, listen: false);
//                           provider.searchCars(value);
//                         },
//                         style: TextStyle(
//                           color: isDark ? Colors.white : const Color(0xFF2D3748),
//                           fontSize: 14,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Find your perfect car...',
//                           hintStyle: TextStyle(
//                             color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                             fontSize: 14,
//                           ),
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                             size: 20,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Container(
//                     height: 45,
//                     width: 45,
//                     decoration: BoxDecoration(
//                       color: Colors.orange[600],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: IconButton(
//                       onPressed: () => _showCompactFilters(context, isDark),
//                       icon: const Icon(
//                         Icons.filter_list,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCarGrid(BuildContext context, CarProvider provider, bool isDark) {
//     return SliverPadding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
//       sliver: AnimatedBuilder(
//         animation: _listAnimation,
//         builder: (context, child) {
//           if (provider.isLoading) {
//             return SliverToBoxAdapter(
//               child: Center(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),
//                     CircularProgressIndicator(
//                       color: Colors.orange[600],
//                       strokeWidth: 2,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Loading vehicles...',
//                       style: TextStyle(
//                         color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           if (provider.hasError) {
//             return SliverToBoxAdapter(
//               child: _buildCompactErrorState(provider.errorMessage, isDark),
//             );
//           }

//           if (provider.cars.isEmpty) {
//             return SliverToBoxAdapter(
//               child: _buildCompactEmptyState(isDark),
//             );
//           }

//           return SliverGrid(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.75,
//             ),
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 final car = provider.cars[index];
//                 return Opacity(
//                   opacity: _listAnimation.value,
//                   child: _buildCompactCarCard(context, car, isDark, index),
//                 );
//               },
//               childCount: provider.cars.length,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCompactCarCard(BuildContext context, Car car, bool isDark, int index) {
//     return GestureDetector(
//       onTap: () => _handleCarTap(car),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isDark ? const Color(0xFF404040) : const Color(0xFFE2E8F0),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Car Image
//             Expanded(
//               flex: 3,
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
//                 ),
//                 child: Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
//                       child: Image.network(
//                         car.image.isNotEmpty ? car.image[0] : '',
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         height: double.infinity,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Container(
//                             color: const Color(0xFFF7FAFC),
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded / 
//                                       loadingProgress.expectedTotalBytes!
//                                     : null,
//                                 color: Colors.orange[600],
//                                 strokeWidth: 2,
//                               ),
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: const Color(0xFFF7FAFC),
//                             child: Center(
//                               child: Icon(
//                                 Icons.directions_car,
//                                 size: 40,
//                                 color: Colors.grey[400],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
                    
//                     // Type Badge
//                     if (car.type != null)
//                       Positioned(
//                         top: 8,
//                         left: 8,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                           decoration: BoxDecoration(
//                             color: Colors.blue[600],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             car.type!,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
                    
//                     // Price Tag
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: Colors.green[600],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           '₹${car.pricePerDay}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             // Car Details
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           car.name,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: isDark ? Colors.white : const Color(0xFF2D3748),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               size: 12,
//                               color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                             ),
//                             const SizedBox(width: 2),
//                             Expanded(
//                               child: Text(
//                                 car.location,
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
                    
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (car.seats != null)
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.person,
//                                 size: 12,
//                                 color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                               ),
//                               const SizedBox(width: 2),
//                               Text(
//                                 '${car.seats}',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w500,
//                                   color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                                 ),
//                               ),
//                             ],
//                           ),
                        
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.orange[600],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Text(
//                             'Book',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCompactEmptyState(bool isDark) {
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isDark ? const Color(0xFF404040) : const Color(0xFFE2E8F0),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.search_off,
//                   size: 40,
//                   color: Colors.orange[600],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "No Cars Found",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: isDark ? Colors.white : const Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "Try different search terms",
//                   style: TextStyle(
//                     color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _selectedCarType = 'All';
//                       _selectedType = 'All';
//                       _selectedFuelType = 'All';
//                     });
//                     final provider = Provider.of<CarProvider>(context, listen: false);
//                     provider.clearFilters();
//                     _searchController.clear();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange[600],
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   ),
//                   child: const Text('Reset Filters'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompactErrorState(String errorMessage, bool isDark) {
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isDark ? const Color(0xFF404040) : const Color(0xFFE2E8F0),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 40,
//                   color: Colors.red[600],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Oops! Something went wrong",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: isDark ? Colors.white : const Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   errorMessage,
//                   style: TextStyle(
//                     color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _loadCarsWithFilters,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange[600],
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showCompactFilters(BuildContext context, bool isDark) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => StatefulBuilder(
//         builder: (BuildContext context, StateSetter setModalState) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.85,
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 8, bottom: 16),
//                   width: 35,
//                   height: 3,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
                
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Filter Options',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: isDark ? Colors.white : const Color(0xFF2D3748),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
                      
//                       // Car Type Filter
//                       Text(
//                         'Vehicle Type',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: isDark ? Colors.white : const Color(0xFF2D3748),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _carTypes.map((type) {
//                           final isSelected = _selectedCarType == type;
//                           return GestureDetector(
//                             onTap: () {
//                               setModalState(() {
//                                 _selectedCarType = type;
//                               });
//                               setState(() {
//                                 _selectedCarType = type;
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: isSelected ? Colors.orange[600] : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: isSelected ? Colors.orange[600]! : Colors.grey[400]!,
//                                 ),
//                               ),
//                               child: Text(
//                                 type,
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF2D3748)),
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
                      
//                       const SizedBox(height: 24),
                      
//                       // Fuel Type Filter
//                       Text(
//                         'Fuel Type',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: isDark ? Colors.white : const Color(0xFF2D3748),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _fuelTypes.map((fuel) {
//                           final isSelected = _selectedFuelType == fuel;
//                           return GestureDetector(
//                             onTap: () {
//                               setModalState(() {
//                                 _selectedFuelType = fuel;
//                               });
//                               setState(() {
//                                 _selectedFuelType = fuel;
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: isSelected ? Colors.orange[600] : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: isSelected ? Colors.orange[600]! : Colors.grey[400]!,
//                                 ),
//                               ),
//                               child: Text(
//                                 fuel,
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF2D3748)),
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
                      
//                       const SizedBox(height: 30),
                      
//                       // Date & Time Section
//                       _buildCompactDateTimeSection(context, isDark),
//                     ],
//                   ),
//                 ),
                
//                 const Spacer(),
                
//                 // Apply Filters Button
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             setModalState(() {
//                               _selectedCarType = 'All';
//                               _selectedFuelType = 'All';
//                             });
//                             setState(() {
//                               _selectedCarType = 'All';
//                               _selectedFuelType = 'All';
//                             });
//                             final provider = Provider.of<CarProvider>(context, listen: false);
//                             provider.clearFilters();
//                           },
//                           style: OutlinedButton.styleFrom(
//                             side: BorderSide(color: Colors.orange[600]!),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: Text(
//                             'Clear All',
//                             style: TextStyle(
//                               color: Colors.orange[600],
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         flex: 2,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             _applyFilters();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange[600],
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: const Text(
//                             'Apply Filters',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCompactDateTimeSection(BuildContext context, bool isDark) {
//     final dateTimeProvider = context.watch<DateTimeProvider>();
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Booking Period',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: isDark ? Colors.white : const Color(0xFF2D3748),
//           ),
//         ),
//         const SizedBox(height: 12),
        
//         // Date & Time Cards
//         Row(
//           children: [
//             Expanded(
//               child: _buildCompactDateTimeCard(
//                 'From',
//                 dateTimeProvider.startDate != null
//                     ? DateFormat('dd MMM').format(dateTimeProvider.startDate!)
//                     : 'Start Date',
//                 dateTimeProvider.startTime?.format(context) ?? 'Time',
//                 () => _showSimpleDateTimePicker(context, true),
//                 isDark,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: _buildCompactDateTimeCard(
//                 'To',
//                 dateTimeProvider.endDate != null
//                     ? DateFormat('dd MMM').format(dateTimeProvider.endDate!)
//                     : 'End Date',
//                 dateTimeProvider.endTime?.format(context) ?? 'Time',
//                 () => _showSimpleDateTimePicker(context, false),
//                 isDark,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactDateTimeCard(String label, String date, String time, VoidCallback onTap, bool isDark) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF404040) : const Color(0xFFF7FAFC),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isDark ? const Color(0xFF525252) : const Color(0xFFE2E8F0),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.orange[600],
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               date,
//               style: TextStyle(
//                 color: isDark ? Colors.white : const Color(0xFF2D3748),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               time,
//               style: TextStyle(
//                 color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF718096),
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSimpleDateTimePicker(BuildContext context, bool isStart) {
//     final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);
    
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: 320,
//         decoration: BoxDecoration(
//           color: Theme.of(context).brightness == Brightness.dark 
//             ? const Color(0xFF2A2A2A) 
//             : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 8, bottom: 16),
//               width: 35,
//               height: 3,
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             Text(
//               isStart ? 'Select Start Date & Time' : 'Select End Date & Time',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final date = await showDatePicker(
//                             context: context,
//                             initialDate: isStart 
//                               ? (dateTimeProvider.startDate ?? DateTime.now())
//                               : (dateTimeProvider.endDate ?? dateTimeProvider.startDate ?? DateTime.now()),
//                             firstDate: isStart 
//                               ? DateTime.now() 
//                               : (dateTimeProvider.startDate ?? DateTime.now()),
//                             lastDate: DateTime.now().add(const Duration(days: 365)),
//                           );
//                           if (date != null) {
//                             if (isStart) {
//                               dateTimeProvider.setStartDate(date);
//                             } else {
//                               dateTimeProvider.setEndDate(date);
//                             }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange[600],
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(isStart ? 'Choose Start Date' : 'Choose End Date'),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final time = await showTimePicker(
//                             context: context,
//                             initialTime: isStart 
//                               ? (dateTimeProvider.startTime ?? TimeOfDay.now())
//                               : (dateTimeProvider.endTime ?? TimeOfDay.now()),
//                           );
//                           if (time != null) {
//                             if (isStart) {
//                               dateTimeProvider.setStartTime(time);
//                             } else {
//                               dateTimeProvider.setEndTime(time);
//                             }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[600],
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(isStart ? 'Choose Start Time' : 'Choose End Time'),
//                       ),
//                     ),
//                     const Spacer(),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey[600],
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text('Done'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _truncateLocation(String location) {
//     if (location.length <= 20) return location;
//     return '${location.substring(0, 17)}...';
//   }

//   void _navigateToLocationSearch() async {
//     try {
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LocationSearchScreen(userId: userId ?? ''),
//         ),
//       );
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Row(
//               children: [
//                 SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Text('Refreshing cars...'),
//               ],
//             ),
//             backgroundColor: Colors.orange[700],
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
        
//         await _loadCarsWithFilters();
        
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('Location updated!'),
//               backgroundColor: Colors.green[600],
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               margin: const EdgeInsets.all(16),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Error updating location: $e');
//       }
//     }
//   }

//   void _handleCarTap(Car car) {
//     final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);

//     if(!widget.guest){
//       if (dateTimeProvider.allFieldsComplete) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CheckoutScreen(
//             carImages: car.image,
//             carId: car.id,
//             carName: car.name,
//             fuel: car.fuel,
//             carType: car.carType,
//             seats: car.seats,
//             location: car.location,
//             pricePerDay: car.pricePerDay,
//             pricePerHour: car.pricePerHour,
//             branch: car.branch.name ?? "Unknown",
//             cordinates: car.branch.coordinates,
//           ),
//         ),
//       );
//     } else {
//       _showSimpleDateSelectionDialog();
//     }
//     }else{
//                           GuestLoginBottomSheet.show(context);

//     }
//   }

//   void _showSimpleDateSelectionDialog() {
//     final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);
    
//     List<String> missingFields = [];
//     if (dateTimeProvider.startDate == null) missingFields.add("Start Date");
//     if (dateTimeProvider.endDate == null) missingFields.add("End Date");
//     if (dateTimeProvider.startTime == null) missingFields.add("Start Time");
//     if (dateTimeProvider.endTime == null) missingFields.add("End Time");

//     String message = missingFields.length == 4
//         ? "Please select rental dates and times to continue with booking."
//         : "Missing: ${missingFields.join(', ')}";

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Set Booking Time',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//         content: Text(
//           message,
//           style: const TextStyle(fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Later',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showCompactFilters(context, Theme.of(context).brightness == Brightness.dark);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange[600],
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             child: const Text('Set Now'),
//           ),
//         ],
//       ),
//     );
//   }
// }



















import 'package:nupura_cars/models/CarModel/car_model.dart';
import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/checkout_screen.dart';
import 'package:nupura_cars/views/LocationScreen/location_search_screen.dart';
import 'package:nupura_cars/views/guest_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ModernCarListScreen extends StatefulWidget {
  final bool guest;
  const ModernCarListScreen({super.key, required this.guest});

  @override
  State<ModernCarListScreen> createState() => _ModernCarListScreenState();
}

class _ModernCarListScreenState extends State<ModernCarListScreen> 
    with TickerProviderStateMixin {
  String? userId;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _listAnimation;
  
  String _selectedCarType = 'All';
  String _selectedType = 'All';
  String _selectedFuelType = 'All';

  // Theme colors
  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  Color get _secondaryColor => Theme.of(context).colorScheme.primaryContainer;
  Color get _accentColor => Theme.of(context).colorScheme.secondary;
  Color get _backgroundColor => Theme.of(context).colorScheme.background;
  Color get _cardColor => Theme.of(context).cardColor;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _surfaceColor => Theme.of(context).colorScheme.surface;
  Color get _scaffoldBackgroundColor => Theme.of(context).scaffoldBackgroundColor;
  Color get _dividerColor => Theme.of(context).dividerColor;

  List<String> get _Types {
    final provider = Provider.of<CarProvider>(context, listen: false);
    final Set<String> uniqueTypes = {'All'};
    
    final allCars = provider.allCars ?? provider.cars;
    
    for (final car in allCars) {
      if (car.type != null && car.type!.isNotEmpty) {
        uniqueTypes.add(car.type!);
      }
    }
    
    return uniqueTypes.toList();
  }

  List<String> get _carTypes {
    final provider = Provider.of<CarProvider>(context, listen: false);
    final Set<String> uniqueTypes = {'All'};
    
    final allCars = provider.allCars ?? provider.cars;
    
    for (final car in allCars) {
      if (car.type != null && car.type!.isNotEmpty) {
        uniqueTypes.add(car.type!);
      }
      if (car.carType != null && car.carType!.isNotEmpty) {
        uniqueTypes.add(car.carType!);
      }
    }
    
    return uniqueTypes.toList();
  }

  final List<String> _fuelTypes = ['All', 'Petrol', 'Diesel', 'Electric', 'Hybrid'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserDataAndCars();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOut),
    );
    _listAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listAnimationController, curve: Curves.easeOut),
    );

    _headerAnimationController.forward();
  }

  Future<void> _loadUserDataAndCars() async {
    try {
      userId = await StorageHelper.getUserId();
      if (mounted) {
        await _loadCarsWithFilters();
        _listAnimationController.forward();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to load user data: ${e.toString()}');
      }
    }
  }

  Future<void> _loadCarsWithFilters() async {
    final provider = Provider.of<CarProvider>(context, listen: false);
    final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);

    String? startDateStr;
    String? endDateStr;
    String? startTimeStr;
    String? endTimeStr;

    if (dateTimeProvider.startDate != null) {
      final startDate = dateTimeProvider.startDate!;
      startDateStr = '${startDate.year}/${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.endDate != null) {
      final endDate = dateTimeProvider.endDate!;
      endDateStr = '${endDate.year}/${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.startTime != null) {
      final startTime = dateTimeProvider.startTime!;
      startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.endTime != null) {
      final endTime = dateTimeProvider.endTime!;
      endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    }

    await provider.initCars(
      userId: userId,
      startDate: startDateStr,
      endDate: endDateStr,
      startTime: startTimeStr,
      endTime: endTimeStr,
      carType: _selectedCarType == 'All' ? null : _selectedCarType,
      type: _selectedType == 'All' ? null : _selectedType,
      fuel: _selectedFuelType == 'All' ? null : _selectedFuelType,
    );
  }

  Future<void> _applyFilters() async {
    final provider = Provider.of<CarProvider>(context, listen: false);
    final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);

    String? startDateStr;
    String? endDateStr;
    String? startTimeStr;
    String? endTimeStr;

    if (dateTimeProvider.startDate != null) {
      final startDate = dateTimeProvider.startDate!;
      startDateStr = '${startDate.year}/${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.endDate != null) {
      final endDate = dateTimeProvider.endDate!;
      endDateStr = '${endDate.year}/${endDate.month.toString().padLeft(2, '0')}/${endDate.day.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.startTime != null) {
      final startTime = dateTimeProvider.startTime!;
      startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    }

    if (dateTimeProvider.endTime != null) {
      final endTime = dateTimeProvider.endTime!;
      endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    }

    await provider.applyFilters(
      userId: userId,
      carType: _selectedCarType == 'All' ? null : _selectedCarType,
      type: _selectedType == 'All' ? null : _selectedType,
      fuel: _selectedFuelType == 'All' ? null : _selectedFuelType,
      startDate: startDateStr,
      endDate: endDateStr,
      startTime: startTimeStr,
      endTime: endTimeStr,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(context, locationProvider, isDark),
          _buildSearchSection(context, isDark),
          _buildFilterChips(context, isDark),
          _buildCarGrid(context, provider, isDark),
        ],
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context, LocationProvider locationProvider, bool isDark) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: _backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: _textPrimary,
            size: 18,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(60, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Cars',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _navigateToLocationSearch(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: _primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          locationProvider.isLoading
                              ? "Locating..."
                              : locationProvider.hasError
                                  ? "Add location"
                                  : _truncateLocation(locationProvider.address),
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: _primaryColor,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    final provider = Provider.of<CarProvider>(context, listen: false);
                    provider.searchCars(value);
                  },
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search cars...',
                    hintStyle: TextStyle(
                      color: _textSecondary,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: _textSecondary,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _showModernFilters(context, isDark),
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, bool isDark) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildFilterChip('All Types', _selectedCarType == 'All', () {
              setState(() {
                _selectedCarType = 'All';
                _selectedType = 'All';
                _selectedFuelType = 'All';
              });
              _applyFilters();
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Petrol', _selectedFuelType == 'Petrol', () {
              setState(() {
                _selectedFuelType = 'Petrol';
              });
              _applyFilters();
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Diesel', _selectedFuelType == 'Diesel', () {
              setState(() {
                _selectedFuelType = 'Diesel';
              });
              _applyFilters();
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Electric', _selectedFuelType == 'Electric', () {
              setState(() {
                _selectedFuelType = 'Electric';
              });
              _applyFilters();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryColor : _dividerColor,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: _primaryColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCarGrid(BuildContext context, CarProvider provider, bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      sliver: AnimatedBuilder(
        animation: _listAnimation,
        builder: (context, child) {
          if (provider.isLoading) {
            return SliverToBoxAdapter(
              child: _buildLoadingState(isDark),
            );
          }

          if (provider.hasError) {
            return SliverToBoxAdapter(
              child: _buildErrorState(provider.errorMessage, isDark),
            );
          }

          if (provider.cars.isEmpty) {
            return SliverToBoxAdapter(
              child: _buildEmptyState(isDark),
            );
          }

          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final car = provider.cars[index];
                return Opacity(
                  opacity: _listAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - _listAnimation.value) * 20),
                    child: _buildModernCarCard(context, car, isDark, index),
                  ),
                );
              },
              childCount: provider.cars.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernCarCard(BuildContext context, Car car, bool isDark, int index) {
    return GestureDetector(
      onTap: () => _handleCarTap(car),
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image with Gradient Overlay
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        car.image.isNotEmpty ? car.image[0] : '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: _backgroundColor,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / 
                                      loadingProgress.expectedTotalBytes!
                                    : null,
                                color: _primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: _backgroundColor,
                            child: Center(
                              child: Icon(
                                Icons.directions_car_rounded,
                                size: 40,
                                color: _textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Price Tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '₹${car.pricePerDay}/day',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    
                    // Car Type Badge
                    if (car.type != null)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            car.type!,
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Car Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: _textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                car.location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.local_gas_station_rounded,
                                size: 12,
                                color: _primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              car.fuel,
                              style: TextStyle(
                                fontSize: 11,
                                color: _textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.people_rounded,
                                size: 12,
                                color: _primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${car.seats} seats',
                              style: TextStyle(
                                fontSize: 11,
                                color: _textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    Container(
                      width: double.infinity,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_primaryColor, _secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          CircularProgressIndicator(
            color: _primaryColor,
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading vehicles...',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: _primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "No Cars Found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Try adjusting your filters or search terms",
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCarType = 'All';
                      _selectedType = 'All';
                      _selectedFuelType = 'All';
                    });
                    final provider = Provider.of<CarProvider>(context, listen: false);
                    provider.clearFilters();
                    _searchController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Reset Filters'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, bool isDark) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: _accentColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "Something Went Wrong",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadCarsWithFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showModernFilters(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter Cars',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Vehicle Type Filter
                      Text(
                        'Vehicle Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _carTypes.map((type) {
                          final isSelected = _selectedCarType == type;
                          return FilterChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedCarType = selected ? type : 'All';
                              });
                              setState(() {
                                _selectedCarType = selected ? type : 'All';
                              });
                            },
                            backgroundColor: _cardColor,
                            selectedColor: _primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : _textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? _primaryColor : _dividerColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Fuel Type Filter
                      Text(
                        'Fuel Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _fuelTypes.map((fuel) {
                          final isSelected = _selectedFuelType == fuel;
                          return FilterChip(
                            label: Text(fuel),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedFuelType = selected ? fuel : 'All';
                              });
                              setState(() {
                                _selectedFuelType = selected ? fuel : 'All';
                              });
                            },
                            backgroundColor: _cardColor,
                            selectedColor: _primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : _textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? _primaryColor : _dividerColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Date & Time Section
                      _buildDateTimeSection(context, isDark),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Apply Filters Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedCarType = 'All';
                              _selectedFuelType = 'All';
                            });
                            setState(() {
                              _selectedCarType = 'All';
                              _selectedFuelType = 'All';
                            });
                            final provider = Provider.of<CarProvider>(context, listen: false);
                            provider.clearFilters();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _applyFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeSection(BuildContext context, bool isDark) {
    final dateTimeProvider = context.watch<DateTimeProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Period',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildDateTimeCard(
                'Start',
                dateTimeProvider.startDate != null
                    ? DateFormat('dd MMM').format(dateTimeProvider.startDate!)
                    : 'Select Date',
                dateTimeProvider.startTime?.format(context) ?? 'Time',
                () => _showDateTimePicker(context, true),
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateTimeCard(
                'End',
                dateTimeProvider.endDate != null
                    ? DateFormat('dd MMM').format(dateTimeProvider.endDate!)
                    : 'Select Date',
                dateTimeProvider.endTime?.format(context) ?? 'Time',
                () => _showDateTimePicker(context, false),
                isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeCard(String label, String date, String time, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: _primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: _textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateTimePicker(BuildContext context, bool isStart) {
    final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 320,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              isStart ? 'Select Start Time' : 'Select End Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: isStart 
                              ? (dateTimeProvider.startDate ?? DateTime.now())
                              : (dateTimeProvider.endDate ?? dateTimeProvider.startDate ?? DateTime.now()),
                            firstDate: isStart 
                              ? DateTime.now() 
                              : (dateTimeProvider.startDate ?? DateTime.now()),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            if (isStart) {
                              dateTimeProvider.setStartDate(date);
                            } else {
                              dateTimeProvider.setEndDate(date);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isStart ? 'Choose Start Date' : 'Choose End Date'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: isStart 
                              ? (dateTimeProvider.startTime ?? TimeOfDay.now())
                              : (dateTimeProvider.endTime ?? TimeOfDay.now()),
                          );
                          if (time != null) {
                            if (isStart) {
                              dateTimeProvider.setStartTime(time);
                            } else {
                              dateTimeProvider.setEndTime(time);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _secondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isStart ? 'Choose Start Time' : 'Choose End Time'),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _textSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _truncateLocation(String location) {
    if (location.length <= 25) return location;
    return '${location.substring(0, 22)}...';
  }

  void _navigateToLocationSearch() async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSearchScreen(userId: userId ?? ''),
        ),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Refreshing cars...'),
              ],
            ),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
        
        await _loadCarsWithFilters();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location updated!'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error updating location: $e');
      }
    }
  }

  void _handleCarTap(Car car) {
    final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);

    if(!widget.guest){
      if (dateTimeProvider.allFieldsComplete) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              carImages: car.image,
              carId: car.id,
              carName: car.name,
              fuel: car.fuel,
              carType: car.carType,
              seats: car.seats,
              location: car.location,
              pricePerDay: car.pricePerDay,
              pricePerHour: car.pricePerHour,
              branch: car.branch.name ?? "Unknown",
              cordinates: car.branch.coordinates,
            ),
          ),
        );
      } else {
        _showDateSelectionDialog();
      }
    } else {
      GuestLoginBottomSheet.show(context);
    }
  }

  void _showDateSelectionDialog() {
    final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);
    
    List<String> missingFields = [];
    if (dateTimeProvider.startDate == null) missingFields.add("Start Date");
    if (dateTimeProvider.endDate == null) missingFields.add("End Date");
    if (dateTimeProvider.startTime == null) missingFields.add("Start Time");
    if (dateTimeProvider.endTime == null) missingFields.add("End Time");

    String message = missingFields.length == 4
        ? "Please select rental dates and times to continue with booking."
        : "Missing: ${missingFields.join(', ')}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Set Booking Time',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 14, color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Later',
              style: TextStyle(color: _textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showModernFilters(context, Theme.of(context).brightness == Brightness.dark);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Set Now'),
          ),
        ],
      ),
    );
  }
}