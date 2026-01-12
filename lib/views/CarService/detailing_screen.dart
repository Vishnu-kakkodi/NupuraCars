// import 'package:flutter/material.dart';
// import 'package:nupura_cars/views/CarService/service_booking_screen.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ServiceDetailScreen extends StatefulWidget {
//   final String serviceTitle;
//   final String serviceId;

//   const ServiceDetailScreen({
//     Key? key,
//     required this.serviceTitle,
//     required this.serviceId,
//   }) : super(key: key);

//   @override
//   State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
// }

// class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
//   String? selectedBrand;
//   String? selectedModel;
//   String? selectedYear;
//   String? selectedModification;

//   final String _adminWhatsAppNumber = '919133905401';

//   // Static data
//   final Map<String, dynamic> _serviceDetails = {
//     'title': 'Premium Car Service',
//     'description': 'Complete car maintenance and servicing package with expert technicians',
//     'image': 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3',
//     'features': [
//       'Engine Oil Change',
//       'Oil Filter Replacement',
//       'Air Filter Cleaning',
//       'Brake Inspection',
//       'Suspension Check',
//       'Battery Health Check',
//       'Tire Pressure Check',
//       'Coolant Top-up',
//       'Wiper Fluid Refill',
//       'Complete Car Wash',
//     ],
//     'benefits': [
//       'Expert Certified Technicians',
//       'Genuine Spare Parts',
//       'Free Pickup & Drop',
//       '1 Month Service Warranty',
//       'Transparent Pricing',
//       'Real-time Service Updates',
//     ],
//     'duration': '2-3 hours',
//     'warranty': '1 Month',
//   };

//   // Car selection data
// final Map<String, List<String>> _carBrands = {
//   // ================= MARUTI SUZUKI =================
//   'Maruti Suzuki': [
//     'Alto 800',
//     'Alto K10',
//     'S-Presso',
//     'Celerio',
//     'WagonR',
//     'Swift',
//     'Dzire',
//     'Baleno',
//     'Fronx',
//     'Ignis',
//     'Ertiga',
//     'XL6',
//     'Brezza',
//     'Grand Vitara',
//     'Jimny',
//     'Ciaz',
//   ],

//   // ================= HYUNDAI =================
//   'Hyundai': [
//     'Grand i10 Nios',
//     'i20',
//     'i20 N Line',
//     'Aura',
//     'Verna',
//     'Exter',
//     'Venue',
//     'Venue N Line',
//     'Creta',
//     'Alcazar',
//     'Tucson',
//     'Kona Electric',
//   ],

//   // ================= TATA =================
//   'Tata': [
//     'Tiago',
//     'Tiago EV',
//     'Tigor',
//     'Tigor EV',
//     'Altroz',
//     'Altroz Racer',
//     'Punch',
//     'Punch EV',
//     'Nexon',
//     'Nexon EV',
//     'Harrier',
//     'Safari',
//   ],

//   // ================= MAHINDRA =================
//   'Mahindra': [
//     'Bolero',
//     'Bolero Neo',
//     'Scorpio Classic',
//     'Scorpio N',
//     'XUV300',
//     'XUV400 EV',
//     'XUV700',
//     'Thar',
//     'Thar 5-Door',
//     'Marazzo',
//   ],

//   // ================= HONDA =================
//   'Honda': [
//     'Amaze',
//     'City',
//     'City Hybrid',
//     'Elevate',
//   ],

//   // ================= TOYOTA =================
//   'Toyota': [
//     'Glanza',
//     'Urban Cruiser Taisor',
//     'Urban Cruiser Hyryder',
//     'Innova Crysta',
//     'Innova Hycross',
//     'Fortuner',
//     'Fortuner Legender',
//     'Camry',
//     'Vellfire',
//   ],

//   // ================= KIA =================
//   'Kia': [
//     'Sonet',
//     'Sonet Facelift',
//     'Seltos',
//     'Seltos Facelift',
//     'Carens',
//     'EV6',
//   ],

//   // ================= SKODA =================
//   'Skoda': [
//     'Slavia',
//     'Kushaq',
//     'Kodiaq',
//   ],

//   // ================= VOLKSWAGEN =================
//   'Volkswagen': [
//     'Virtus',
//     'Taigun',
//     'Tiguan',
//   ],

//   // ================= RENAULT =================
//   'Renault': [
//     'Kwid',
//     'Triber',
//     'Kiger',
//   ],

//   // ================= NISSAN =================
//   'Nissan': [
//     'Magnite',
//   ],

//   // ================= MG MOTOR =================
//   'MG Motor': [
//     'Comet EV',
//     'Astor',
//     'Hector',
//     'Hector Plus',
//     'ZS EV',
//     'Gloster',
//   ],

//   // ================= JEEP =================
//   'Jeep': [
//     'Compass',
//     'Meridian',
//   ],

//   // ================= CITROËN =================
//   'Citroen': [
//     'C3',
//     'C3 Aircross',
//     'eC3',
//   ],

//   // ================= BMW =================
//   'BMW': [
//     '2 Series',
//     '3 Series',
//     '5 Series',
//     '7 Series',
//     'X1',
//     'X3',
//     'X5',
//     'X7',
//     'i4',
//     'iX',
//   ],

//   // ================= MERCEDES-BENZ =================
//   'Mercedes-Benz': [
//     'A-Class',
//     'C-Class',
//     'E-Class',
//     'S-Class',
//     'GLA',
//     'GLC',
//     'GLE',
//     'GLS',
//     'EQB',
//     'EQE',
//     'EQS',
//   ],

//   // ================= AUDI =================
//   'Audi': [
//     'A4',
//     'A6',
//     'Q3',
//     'Q5',
//     'Q7',
//     'Q8',
//     'e-tron',
//   ],

//   // ================= VOLVO =================
//   'Volvo': [
//     'XC40',
//     'XC60',
//     'XC90',
//     'C40 Recharge',
//   ],

//   // ================= BYD =================
//   'BYD': [
//     'Atto 3',
//     'Seal',
//   ],
// };


//   final List<String> _years = ['2025',
//     '2024', '2023', '2022', '2021', '2020', 
//     '2019', '2018', '2017', '2016', '2015',    '2014', '2013', '2012', '2011', '2010', 
//     '2009', '2008', '2007', '2006', '2005',  '2004', '2003', '2002', '2001', '2000'
//   ];

//   final List<String> _modifications = [
//     'Petrol Manual',
//     'Petrol Automatic',
//     'Diesel Manual',
//     'Diesel Automatic',
//     'CNG Manual',
//     'Electric',
//   ];

//   bool get _canProceed =>
//       selectedBrand != null &&
//       selectedModel != null &&
//       selectedYear != null &&
//       selectedModification != null;

//   void _showCarSelectionBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _CarSelectionSheet(
//         brands: _carBrands,
//         years: _years,
//         modifications: _modifications,
//         selectedBrand: selectedBrand,
//         selectedModel: selectedModel,
//         selectedYear: selectedYear,
//         selectedModification: selectedModification,
//         onConfirm: (brand, model, year, modification) {
//           setState(() {
//             selectedBrand = brand;
//             selectedModel = model;
//             selectedYear = year;
//             selectedModification = modification;
//           });
//         },
//       ),
//     );
//   }

//   Future<void> _openWhatsApp() async {
//     if (!_canProceed) return;

//     final message = '''
// Hello, I'm interested in ${widget.serviceTitle}

// Car Details:
// Brand: $selectedBrand
// Model: $selectedModel
// Year: $selectedYear
// Modification: $selectedModification

// Please provide more information.
// ''';

//     final uri = Uri.parse(
//       'https://wa.me/$_adminWhatsAppNumber?text=${Uri.encodeComponent(message)}',
//     );

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   Future<void> _callNow() async {
//     final uri = Uri.parse('tel:9133905401');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }

//   void _proceedToBooking() {
//     if (!_canProceed) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select your car details first'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ServiceBookingScreen(
//           serviceId: widget.serviceId,
//           serviceName: widget.serviceTitle,
//           imageUrl: _serviceDetails['image'],
//           carBrand: selectedBrand!,
//           carModel: selectedModel!,
//           carYear: selectedYear!,
//           carModification: selectedModification!,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: colorScheme.surface,
//         foregroundColor: colorScheme.onSurface,
//         title: Text(
//           widget.serviceTitle,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, size: 18),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Service Image
//             Container(
//               width: double.infinity,
//               height: 240,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(_serviceDetails['image']),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   const SizedBox(height: 24),

//                   // Features Section
//                   Text(
//                     'What\'s Included',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: colorScheme.surface,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: colorScheme.outlineVariant),
//                     ),
//                     child: Column(
//                       children: _serviceDetails['features']
//                           .map<Widget>((feature) => Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 6),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.check_circle,
//                                       color: colorScheme.primary,
//                                       size: 20,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         feature,
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           color: colorScheme.onSurface,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ))
//                           .toList(),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Car Selection Card
//                   GestureDetector(
//                     onTap: _showCarSelectionBottomSheet,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             colorScheme.primary.withOpacity(0.1),
//                             colorScheme.secondary.withOpacity(0.1),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: colorScheme.primary.withOpacity(0.3),
//                           width: 2,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: colorScheme.primary,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.directions_car,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _canProceed
//                                       ? 'Selected Car'
//                                       : 'Select Your Car',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: colorScheme.onSurface,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   _canProceed
//                                       ? '$selectedBrand $selectedModel ($selectedYear)'
//                                       : 'Tap to choose your car details',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: colorScheme.onSurfaceVariant,
//                                   ),
//                                 ),
//                                 if (_canProceed && selectedModification != null)
//                                   Text(
//                                     selectedModification!,
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: colorScheme.primary,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             color: colorScheme.primary,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   if (_canProceed) ...[
//                     const SizedBox(height: 20),

//                     // Action Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: _callNow,
//                             icon: const Icon(Icons.call, size: 18),
//                             label: const Text('Call Now'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.green,
//                               side: const BorderSide(color: Colors.green, width: 2),
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: _openWhatsApp,
//                             icon: const Icon(Icons.chat, size: 18),
//                             label: const Text('WhatsApp'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.blue,
//                               side: const BorderSide(color: Colors.blue, width: 2),
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 12),

//                     // Proceed Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _proceedToBooking,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: colorScheme.primary,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: const Text(
//                           'Proceed to Service',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],

//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Info Card Widget
// class _InfoCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;

//   const _InfoCard({
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: colorScheme.outlineVariant),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: colorScheme.primary, size: 28),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: colorScheme.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: colorScheme.onSurface,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Car Selection Bottom Sheet
// class _CarSelectionSheet extends StatefulWidget {
//   final Map<String, List<String>> brands;
//   final List<String> years;
//   final List<String> modifications;
//   final String? selectedBrand;
//   final String? selectedModel;
//   final String? selectedYear;
//   final String? selectedModification;
//   final Function(String, String, String, String) onConfirm;

//   const _CarSelectionSheet({
//     required this.brands,
//     required this.years,
//     required this.modifications,
//     required this.selectedBrand,
//     required this.selectedModel,
//     required this.selectedYear,
//     required this.selectedModification,
//     required this.onConfirm,
//   });

//   @override
//   State<_CarSelectionSheet> createState() => _CarSelectionSheetState();
// }

// class _CarSelectionSheetState extends State<_CarSelectionSheet> {
//   String? _brand;
//   String? _model;
//   String? _year;
//   String? _modification;

//   @override
//   void initState() {
//     super.initState();
//     _brand = widget.selectedBrand;
//     _model = widget.selectedModel;
//     _year = widget.selectedYear;
//     _modification = widget.selectedModification;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       margin: const EdgeInsets.only(top: 60),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           /// HEADER
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: cs.onSurface,
//                     ),
//                     children: const [
//                       TextSpan(text: 'Search by '),
//                       TextSpan(
//                         text: 'Vehicle',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _dropdownCard(
//                     label: 'Car Maker',
//                     value: _brand,
//                     enabled: true,
//                     items: widget.brands.keys.toList(),
//                     onChanged: (v) {
//                       setState(() {
//                         _brand = v;
//                         _model = null;
//                         _year = null;
//                         _modification = null;
//                       });
//                     },
//                   ),

//                   _dropdownCard(
//                     label: 'Model Line',
//                     value: _model,
//                     enabled: _brand != null,
//                     items: _brand == null
//                         ? []
//                         : widget.brands[_brand]!,
//                     onChanged: (v) {
//                       setState(() {
//                         _model = v;
//                         _year = null;
//                         _modification = null;
//                       });
//                     },
//                   ),

//                   _dropdownCard(
//                     label: 'Year',
//                     value: _year,
//                     enabled: _model != null,
//                     items: widget.years,
//                     onChanged: (v) {
//                       setState(() {
//                         _year = v;
//                         _modification = null;
//                       });
//                     },
//                   ),

//                   _dropdownCard(
//                     label: 'Modification',
//                     value: _modification,
//                     enabled: _year != null,
//                     items: widget.modifications,
//                     onChanged: (v) {
//                       setState(() {
//                         _modification = v;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),

//           /// CONFIRM BUTTON
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: SafeArea(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _brand != null &&
//                           _model != null &&
//                           _year != null &&
//                           _modification != null
//                       ? () {
//                           widget.onConfirm(
//                             _brand!,
//                             _model!,
//                             _year!,
//                             _modification!,
//                           );
//                           Navigator.pop(context);
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: cs.primary,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'SEARCH PARTS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// DROPDOWN CARD (Reusable)
//   Widget _dropdownCard({
//     required String label,
//     required String? value,
//     required bool enabled,
//     required List<String> items,
//     required Function(String) onChanged,
//   }) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: enabled ? cs.surface : cs.surfaceVariant,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: cs.outlineVariant),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           hint: Text(
//             label,
//             style: TextStyle(
//               color: enabled
//                   ? cs.onSurfaceVariant
//                   : cs.onSurfaceVariant.withOpacity(0.5),
//             ),
//           ),
//           isExpanded: true,
//           icon: const Icon(Icons.keyboard_arrow_down),
//           items: items
//               .map(
//                 (e) => DropdownMenuItem(
//                   value: e,
//                   child: Text(e),
//                 ),
//               )
//               .toList(),
//           onChanged: enabled ? (v) => onChanged(v!) : null,
//         ),
//       ),
//     );
//   }
// }



























import 'package:flutter/material.dart';
import 'package:nupura_cars/views/CarService/service_booking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceTitle;
  final String serviceId;
  final String imageUrl;
  final List<String> included;

  const ServiceDetailScreen({
    Key? key,
    required this.serviceTitle,
    required this.serviceId,
    required this.imageUrl,
    required this.included,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String? selectedBrand;
  String? selectedModel;
  String? selectedYear;
  String? selectedModification;

  final String _adminWhatsAppNumber = '919133905401';

  // Car selection data
  final Map<String, List<String>> _carBrands = {
    // ================= MARUTI SUZUKI =================
    'Maruti Suzuki': [
      'Alto 800',
      'Alto K10',
      'S-Presso',
      'Celerio',
      'WagonR',
      'Swift',
      'Dzire',
      'Baleno',
      'Fronx',
      'Ignis',
      'Ertiga',
      'XL6',
      'Brezza',
      'Grand Vitara',
      'Jimny',
      'Ciaz',
    ],

    // ================= HYUNDAI =================
    'Hyundai': [
      'Grand i10 Nios',
      'i20',
      'i20 N Line',
      'Aura',
      'Verna',
      'Exter',
      'Venue',
      'Venue N Line',
      'Creta',
      'Alcazar',
      'Tucson',
      'Kona Electric',
    ],

    // ================= TATA =================
    'Tata': [
      'Tiago',
      'Tiago EV',
      'Tigor',
      'Tigor EV',
      'Altroz',
      'Altroz Racer',
      'Punch',
      'Punch EV',
      'Nexon',
      'Nexon EV',
      'Harrier',
      'Safari',
    ],

    // ================= MAHINDRA =================
    'Mahindra': [
      'Bolero',
      'Bolero Neo',
      'Scorpio Classic',
      'Scorpio N',
      'XUV300',
      'XUV400 EV',
      'XUV700',
      'Thar',
      'Thar 5-Door',
      'Marazzo',
    ],

    // ================= HONDA =================
    'Honda': [
      'Amaze',
      'City',
      'City Hybrid',
      'Elevate',
    ],

    // ================= TOYOTA =================
    'Toyota': [
      'Glanza',
      'Urban Cruiser Taisor',
      'Urban Cruiser Hyryder',
      'Innova Crysta',
      'Innova Hycross',
      'Fortuner',
      'Fortuner Legender',
      'Camry',
      'Vellfire',
    ],

    // ================= KIA =================
    'Kia': [
      'Sonet',
      'Sonet Facelift',
      'Seltos',
      'Seltos Facelift',
      'Carens',
      'EV6',
    ],

    // ================= SKODA =================
    'Skoda': [
      'Slavia',
      'Kushaq',
      'Kodiaq',
    ],

    // ================= VOLKSWAGEN =================
    'Volkswagen': [
      'Virtus',
      'Taigun',
      'Tiguan',
    ],

    // ================= RENAULT =================
    'Renault': [
      'Kwid',
      'Triber',
      'Kiger',
    ],

    // ================= NISSAN =================
    'Nissan': [
      'Magnite',
    ],

    // ================= MG MOTOR =================
    'MG Motor': [
      'Comet EV',
      'Astor',
      'Hector',
      'Hector Plus',
      'ZS EV',
      'Gloster',
    ],

    // ================= JEEP =================
    'Jeep': [
      'Compass',
      'Meridian',
    ],

    // ================= CITROËN =================
    'Citroen': [
      'C3',
      'C3 Aircross',
      'eC3',
    ],

    // ================= BMW =================
    'BMW': [
      '2 Series',
      '3 Series',
      '5 Series',
      '7 Series',
      'X1',
      'X3',
      'X5',
      'X7',
      'i4',
      'iX',
    ],

    // ================= MERCEDES-BENZ =================
    'Mercedes-Benz': [
      'A-Class',
      'C-Class',
      'E-Class',
      'S-Class',
      'GLA',
      'GLC',
      'GLE',
      'GLS',
      'EQB',
      'EQE',
      'EQS',
    ],

    // ================= AUDI =================
    'Audi': [
      'A4',
      'A6',
      'Q3',
      'Q5',
      'Q7',
      'Q8',
      'e-tron',
    ],

    // ================= VOLVO =================
    'Volvo': [
      'XC40',
      'XC60',
      'XC90',
      'C40 Recharge',
    ],

    // ================= BYD =================
    'BYD': [
      'Atto 3',
      'Seal',
    ],
  };

  final List<String> _years = [
    '2025',
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000'
  ];

  final List<String> _modifications = [
    'Petrol Manual',
    'Petrol Automatic',
    'Diesel Manual',
    'Diesel Automatic',
    'CNG Manual',
    'Electric',
  ];

  bool get _canProceed =>
      selectedBrand != null &&
      selectedModel != null &&
      selectedYear != null &&
      selectedModification != null;

  void _showCarSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CarSelectionSheet(
        brands: _carBrands,
        years: _years,
        modifications: _modifications,
        selectedBrand: selectedBrand,
        selectedModel: selectedModel,
        selectedYear: selectedYear,
        selectedModification: selectedModification,
        onConfirm: (brand, model, year, modification) {
          setState(() {
            selectedBrand = brand;
            selectedModel = model;
            selectedYear = year;
            selectedModification = modification;
          });
        },
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    if (!_canProceed) return;

    final message = '''
Hello, I'm interested in ${widget.serviceTitle}

Car Details:
Brand: $selectedBrand
Model: $selectedModel
Year: $selectedYear
Modification: $selectedModification

Please provide more information.
''';

    final uri = Uri.parse(
      'https://wa.me/$_adminWhatsAppNumber?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callNow() async {
    final uri = Uri.parse('tel:9133905401');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _proceedToBooking() {
    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your car details first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceBookingScreen(
          serviceId: widget.serviceId,
          serviceName: widget.serviceTitle,
          imageUrl: widget.imageUrl,
          carBrand: selectedBrand!,
          carModel: selectedModel!,
          carYear: selectedYear!,
          carModification: selectedModification!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          widget.serviceTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Features Section
                  Text(
                    'What\'s Included',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: widget.included.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No service details available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: widget.included
                                .map<Widget>((feature) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: colorScheme.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              feature,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // Car Selection Card
                  GestureDetector(
                    onTap: _showCarSelectionBottomSheet,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.1),
                            colorScheme.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _canProceed
                                      ? 'Selected Car'
                                      : 'Select Your Car',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _canProceed
                                      ? '$selectedBrand $selectedModel ($selectedYear)'
                                      : 'Tap to choose your car details',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (_canProceed &&
                                    selectedModification != null)
                                  Text(
                                    selectedModification!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_canProceed) ...[
                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _callNow,
                            icon: const Icon(Icons.call, size: 18),
                            label: const Text('Call Now'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(
                                  color: Colors.green, width: 2),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _openWhatsApp,
                            icon: const Icon(Icons.chat, size: 18),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side:
                                  const BorderSide(color: Colors.blue, width: 2),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Proceed Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _proceedToBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Proceed to Service',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Car Selection Bottom Sheet
class _CarSelectionSheet extends StatefulWidget {
  final Map<String, List<String>> brands;
  final List<String> years;
  final List<String> modifications;
  final String? selectedBrand;
  final String? selectedModel;
  final String? selectedYear;
  final String? selectedModification;
  final Function(String, String, String, String) onConfirm;

  const _CarSelectionSheet({
    required this.brands,
    required this.years,
    required this.modifications,
    required this.selectedBrand,
    required this.selectedModel,
    required this.selectedYear,
    required this.selectedModification,
    required this.onConfirm,
  });

  @override
  State<_CarSelectionSheet> createState() => _CarSelectionSheetState();
}

class _CarSelectionSheetState extends State<_CarSelectionSheet> {
  String? _brand;
  String? _model;
  String? _year;
  String? _modification;

  @override
  void initState() {
    super.initState();
    _brand = widget.selectedBrand;
    _model = widget.selectedModel;
    _year = widget.selectedYear;
    _modification = widget.selectedModification;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                    children: const [
                      TextSpan(text: 'Search by '),
                      TextSpan(
                        text: 'Vehicle',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _dropdownCard(
                    label: 'Car Maker',
                    value: _brand,
                    enabled: true,
                    items: widget.brands.keys.toList(),
                    onChanged: (v) {
                      setState(() {
                        _brand = v;
                        _model = null;
                        _year = null;
                        _modification = null;
                      });
                    },
                  ),
                  _dropdownCard(
                    label: 'Model Line',
                    value: _model,
                    enabled: _brand != null,
                    items: _brand == null ? [] : widget.brands[_brand]!,
                    onChanged: (v) {
                      setState(() {
                        _model = v;
                        _year = null;
                        _modification = null;
                      });
                    },
                  ),
                  _dropdownCard(
                    label: 'Year',
                    value: _year,
                    enabled: _model != null,
                    items: widget.years,
                    onChanged: (v) {
                      setState(() {
                        _year = v;
                        _modification = null;
                      });
                    },
                  ),
                  _dropdownCard(
                    label: 'Modification',
                    value: _modification,
                    enabled: _year != null,
                    items: widget.modifications,
                    onChanged: (v) {
                      setState(() {
                        _modification = v;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// CONFIRM BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _brand != null &&
                          _model != null &&
                          _year != null &&
                          _modification != null
                      ? () {
                          widget.onConfirm(
                            _brand!,
                            _model!,
                            _year!,
                            _modification!,
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM SELECTION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// DROPDOWN CARD (Reusable)
  Widget _dropdownCard({
    required String label,
    required String? value,
    required bool enabled,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? cs.surface : cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            label,
            style: TextStyle(
              color: enabled
                  ? cs.onSurfaceVariant
                  : cs.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: enabled ? (v) => onChanged(v!) : null,
        ),
      ),
    );
  }
}