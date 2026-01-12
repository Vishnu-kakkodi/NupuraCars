
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nupura_cars/constants/api_constants.dart';
// import 'package:nupura_cars/models/Cart/cart_model.dart';
// import 'package:nupura_cars/providers/CartProvider/cart_provider.dart';
// import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
// import 'package:nupura_cars/views/Location/location_picker.dart';
// import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   final String userId = '692468a7eef8da08eede6712';

//   String _mode = 'Pickup';
//   String _notes = '';
//   String? _coupon;
//   String _paymentMode = 'cash'; // cash or online

//   DateTime? _pickupDate;
//   TimeOfDay? _pickupTime;
//   DateTime? _bookingDate;

//   bool isProcessingPayment = false;
//   Razorpay? _razorpay;
  
//   String name = '';
//   String email = '';
//   String mobile = '';

//   @override
//   void initState() {
//     super.initState();
//     context.read<CartProvider>().loadCart(userId);
//     _loadUserData();
//     _initRazorpay();
//   }

//   @override
//   void dispose() {
//     try {
//       _razorpay?.clear();
//     } catch (e) {}
//     super.dispose();
//   }

//   void _initRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   Future<void> _loadUserData() async {
//     final userName = await StorageHelper.getUserName();
//     final userEmail = await StorageHelper.getEmail();
//     final userMobile = await StorageHelper.getMobile();

//     setState(() {
//       name = userName ?? '';
//       email = userEmail ?? '';
//       mobile = userMobile ?? '';
//     });
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     setState(() {
//       isProcessingPayment = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Payment Failed: ${response.message}'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     // Call API with transaction ID after successful payment
//     await _callBookingAPI(transactionId: response.paymentId);
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('External Wallet: ${response.walletName}')),
//     );
//   }

//   Future<void> _callBookingAPI({String? transactionId}) async {
//     final provider = context.read<LocationProvider>();
//     final cart = context.read<CartProvider>().cart;

//     if (cart == null) return;

//     // Prepare payload based on mode
//     Map<String, dynamic> payload = {
//       'bookingDate': _bookingDate != null 
//           ? '${_bookingDate!.year}-${_bookingDate!.month.toString().padLeft(2, '0')}-${_bookingDate!.day.toString().padLeft(2, '0')}'
//           : DateTime.now().toString().split(' ')[0],
//       'note': _notes.isEmpty ? 'No special requirements' : _notes,
//       'modeOfService': _mode.toLowerCase(),
//       'modeOfPayment': _paymentMode,
//     };

//     // Add pickup-specific fields
//     if (_mode == 'Pickup') {
//       if (_pickupDate == null || _pickupTime == null) {
//         setState(() {
//           isProcessingPayment = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select pickup date and time')),
//         );
//         return;
//       }

//       if (provider.address.isEmpty || provider.coordinates == null) {
//         setState(() {
//           isProcessingPayment = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please set pickup location')),
//         );
//         return;
//       }

//       payload['pickupDate'] = '${_pickupDate!.year}-${_pickupDate!.month.toString().padLeft(2, '0')}-${_pickupDate!.day.toString().padLeft(2, '0')}';
//       payload['pickupTime'] = _pickupTime!.format(context);
//       payload['location'] = {
//         'address': provider.address,
//         'lat': provider.coordinates![0],
//         'lng': provider.coordinates![1],
//       };
//     }

//     // Add transaction ID for online payment
//     if (_paymentMode == 'online' && transactionId != null) {
//       payload['transactionId'] = transactionId;
//     }

//     try {
//       // TODO: Replace with your actual API call
//       final response = await http.post(
//         Uri.parse('${ApiConstants.baseUrl}/users/carservicebooking/$userId'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(payload),
//       );

//       print('Booking Payload: $payload');

      
//       print("ppppppppppppppppppppppppppppppppppppppppppppppppppp${response.body}");


//       setState(() {
//         isProcessingPayment = false;
//       });

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Booking created successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Navigate back or to success screen
//                              Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     MainNavigationScreen(initialIndex: 2),
//                               ),
//                               (Route<dynamic> route) => false,
//                             );

//     } catch (e) {
//       setState(() {
//         isProcessingPayment = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error creating booking: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _removeItemLocally(String id) {
//     context.read<CartProvider>().removeLocal(userId, id);
//   }

//   Future<void> _selectPickupDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );

//     if (picked != null) {
//       setState(() => _pickupDate = picked);
//     }
//   }

//   Future<void> _selectPickupTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (picked != null) {
//       setState(() => _pickupTime = picked);
//     }
//   }

//   Future<void> _selectBookingDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );

//     if (picked != null) {
//       setState(() => _bookingDate = picked);
//     }
//   }

//   Widget _pickupLocationSection() {
//     return Consumer<LocationProvider>(
//       builder: (context, provider, _) {
//         return InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () async {
//             await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     LocationPickerScreen(isEditing: false, userId: userId),
//               ),
//             );
//           },
//           child: _whiteCard(
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.location_on_outlined,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: provider.isLoading
//                       ? const Text('Fetching location...')
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               provider.address.isNotEmpty
//                                   ? provider.address
//                                   : 'Set pickup location',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             if (provider.coordinates != null)
//                               Text(
//                                 'Lat: ${provider.coordinates![0]}, Lng: ${provider.coordinates![1]}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                           ],
//                         ),
//                 ),
//                 const Icon(Icons.keyboard_arrow_right),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _bookingDateTimeSection() {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _selectBookingDate,
//           child: _whiteCard(
//             child: Row(
//               children: [
//                 const Icon(Icons.calendar_today),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     _bookingDate == null
//                         ? 'Select booking date'
//                         : '${_bookingDate!.day}/${_bookingDate!.month}/${_bookingDate!.year}',
//                   ),
//                 ),
//                 const Icon(Icons.arrow_forward_ios, size: 16),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _pickupDateTimeSection() {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _selectPickupDate,
//           child: _whiteCard(
//             child: Row(
//               children: [
//                 const Icon(Icons.calendar_today),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     _pickupDate == null
//                         ? 'Select pickup date'
//                         : '${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}',
//                   ),
//                 ),
//                 const Icon(Icons.arrow_forward_ios, size: 16),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         GestureDetector(
//           onTap: _selectPickupTime,
//           child: _whiteCard(
//             child: Row(
//               children: [
//                 const Icon(Icons.access_time),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     _pickupTime == null
//                         ? 'Select pickup time'
//                         : _pickupTime!.format(context),
//                   ),
//                 ),
//                 const Icon(Icons.arrow_forward_ios, size: 16),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showNotesModal() {
//     final ctrl = TextEditingController(text: _notes);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
//       ),
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           left: 16,
//           right: 16,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Any other requirements',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: ctrl,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'Write instructions for service team...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() => _notes = ctrl.text.trim());
//                 Navigator.pop(context);
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _checkout(int total) {
//     if (total == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cart is empty')),
//       );
//       return;
//     }

//     // Validate booking date
//     if (_bookingDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select booking date')),
//       );
//       return;
//     }

//     // Validate pickup fields if pickup mode
//     if (_mode == 'Pickup') {
//       if (_pickupDate == null || _pickupTime == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select pickup date and time')),
//         );
//         return;
//       }

//       final provider = context.read<LocationProvider>();
//       if (provider.address.isEmpty || provider.coordinates == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please set pickup location')),
//         );
//         return;
//       }
//     }

//     setState(() {
//       isProcessingPayment = true;
//     });

//     if (_paymentMode == 'cash') {
//       // Direct API call for cash payment
//       _callBookingAPI();
//     } else {
//       // Razorpay integration for online payment
//       var options = {
//         'key': 'rzp_test_RgqXPvDLbgEIVv', // Replace with your key
//         'amount': (total * 100), // Amount in paise
//         'name': 'Car Service App',
//         'description': 'Car Service Booking',
//         'retry': {'enabled': true, 'max_count': 1},
//         'send_sms_hash': true,
//         'prefill': {'contact': mobile, 'email': email},
//         'external': {
//           'wallets': ['paytm'],
//         },
//       };

//       try {
//         _razorpay?.open(options);
//       } catch (e) {
//         setState(() {
//           isProcessingPayment = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error initiating payment: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<CartProvider>();
//     final CartModel? cart = provider.cart;

//     return PopScope(
//       canPop: !isProcessingPayment,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF6F6F8),
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           title: const Text(
//             'My Cart',
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, size: 18),
//             onPressed: isProcessingPayment ? null : () => Navigator.pop(context),
//           ),
//         ),
//         body: cart == null
//             ? const Center(child: CircularProgressIndicator())
//             : Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 90),
//                     child: ListView(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       children: [
//                         /// CART ITEMS
//                         Container(
//                           padding: const EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             children: cart.items.map((CartItem item) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 12),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 56,
//                                       height: 56,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(
//                                           color: Colors.grey.shade300,
//                                         ),
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           item.image,
//                                           fit: BoxFit.cover,
//                                           errorBuilder: (_, __, ___) =>
//                                               const Icon(Icons.car_repair),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             item.name,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 6),
//                                           Text('₹ ${item.price}'),
//                                         ],
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () => _removeItemLocally(item.id),
//                                       child: Container(
//                                         width: 34,
//                                         height: 34,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color: Colors.grey.shade300,
//                                           ),
//                                         ),
//                                         child: const Icon(Icons.close, size: 18),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),

//                         const SizedBox(height: 14),

//                         /// NOTES
//                         GestureDetector(
//                           onTap: _showNotesModal,
//                           child: _whiteCard(
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     _notes.isEmpty
//                                         ? 'Any other requirements…'
//                                         : _notes,
//                                     style: TextStyle(
//                                       color: _notes.isEmpty
//                                           ? Colors.grey
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 const Icon(Icons.edit),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 14),

//                         _bookingDateTimeSection(),

//                         const SizedBox(height: 14),

//                         /// MODE OF SERVICE
//                         _whiteCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Mode of Service',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Radio<String>(
//                                     value: 'Pickup',
//                                     groupValue: _mode,
//                                     onChanged: (v) =>
//                                         setState(() => _mode = v!),
//                                   ),
//                                   const Text('Pickup'),
//                                   Radio<String>(
//                                     value: 'Walk In',
//                                     groupValue: _mode,
//                                     onChanged: (v) =>
//                                         setState(() => _mode = v!),
//                                   ),
//                                   const Text('Walk In'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         if (_mode == 'Pickup') ...[
//                           const SizedBox(height: 14),
//                           _pickupDateTimeSection(),
//                           const SizedBox(height: 14),
//                           _pickupLocationSection(),
//                         ],

//                         const SizedBox(height: 14),

//                         /// PAYMENT MODE
//                         _whiteCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Mode of Payment',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Radio<String>(
//                                     value: 'cash',
//                                     groupValue: _paymentMode,
//                                     onChanged: (v) =>
//                                         setState(() => _paymentMode = v!),
//                                   ),
//                                   const Text('Cash'),
//                                   Radio<String>(
//                                     value: 'online',
//                                     groupValue: _paymentMode,
//                                     onChanged: (v) =>
//                                         setState(() => _paymentMode = v!),
//                                   ),
//                                   const Text('Online (Razorpay)'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 14),

//                         /// BILL SUMMARY
//                         _whiteCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Bill Summary',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               _billRow('Item Total (Incl. taxes)', cart.total),
//                               const Divider(),
//                               _billRow('Grand Total', cart.total, bold: true),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 100),
//                       ],
//                     ),
//                   ),

//                   /// CHECKOUT BAR
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(color: Colors.black12, blurRadius: 10),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Cart Value',
//                                   style: TextStyle(color: Colors.black54),
//                                 ),
//                                 Text(
//                                   '₹ ${cart.total}',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: isProcessingPayment
//                                 ? null
//                                 : () => _checkout(cart.total),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                             child: isProcessingPayment
//                                 ? const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white,
//                                       ),
//                                     ),
//                                   )
//                                 : const Text('Checkout'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   /// PROCESSING OVERLAY
//                   if (isProcessingPayment)
//                     Container(
//                       color: Colors.black.withOpacity(0.7),
//                       child: Center(
//                         child: Container(
//                           padding: const EdgeInsets.all(24),
//                           margin: const EdgeInsets.symmetric(horizontal: 40),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const [
//                               CircularProgressIndicator(
//                                 strokeWidth: 3,
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 'Processing Payment...',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Please wait while we confirm your booking',
//                                 style: TextStyle(fontSize: 14),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _whiteCard({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: child,
//     );
//   }

//   Widget _billRow(String title, int value, {bool bold = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title),
//         Text(
//           '₹ $value',
//           style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//         ),
//       ],
//     );
//   }
// }




















import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/Cart/cart_model.dart';
import 'package:nupura_cars/providers/CartProvider/cart_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/views/Location/location_picker.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String userId = '692468a7eef8da08eede6712';

  String _mode = 'Pickup';
  String _notes = '';
  String? _coupon;
  String _paymentMode = 'cash'; // cash or online

  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  DateTime? _bookingDate;

  bool isProcessingPayment = false;
  Razorpay? _razorpay;
  
  String name = '';
  String email = '';
  String mobile = '';

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().loadCart(userId);
    _loadUserData();
    _initRazorpay();
  }

  @override
  void dispose() {
    try {
      _razorpay?.clear();
    } catch (e) {}
    super.dispose();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _loadUserData() async {
    final userName = await StorageHelper.getUserName();
    final userEmail = await StorageHelper.getEmail();
    final userMobile = await StorageHelper.getMobile();

    setState(() {
      name = userName ?? '';
      email = userEmail ?? '';
      mobile = userMobile ?? '';
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isProcessingPayment = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Call API with transaction ID after successful payment
    await _callBookingAPI(transactionId: response.paymentId);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  Future<void> _callBookingAPI({String? transactionId}) async {
    final provider = context.read<LocationProvider>();
    final cart = context.read<CartProvider>().cart;

    if (cart == null) return;

    // Prepare payload based on mode
    Map<String, dynamic> payload = {
      'bookingDate': _bookingDate != null 
          ? '${_bookingDate!.year}-${_bookingDate!.month.toString().padLeft(2, '0')}-${_bookingDate!.day.toString().padLeft(2, '0')}'
          : DateTime.now().toString().split(' ')[0],
      'note': _notes.isEmpty ? 'No special requirements' : _notes,
      'modeOfService': _mode.toLowerCase(),
      'modeOfPayment': _paymentMode,
    };

    // Add pickup-specific fields
    if (_mode == 'Pickup') {
      if (_pickupDate == null || _pickupTime == null) {
        setState(() {
          isProcessingPayment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select pickup date and time')),
        );
        return;
      }

      if (provider.address.isEmpty || provider.coordinates == null) {
        setState(() {
          isProcessingPayment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set pickup location')),
        );
        return;
      }

      payload['pickupDate'] = '${_pickupDate!.year}-${_pickupDate!.month.toString().padLeft(2, '0')}-${_pickupDate!.day.toString().padLeft(2, '0')}';
      payload['pickupTime'] = _pickupTime!.format(context);
      payload['location'] = {
        'address': provider.address,
        'lat': provider.coordinates![0],
        'lng': provider.coordinates![1],
      };
    }

    // Add transaction ID for online payment
    if (_paymentMode == 'online' && transactionId != null) {
      payload['transactionId'] = transactionId;
    }

    try {
      // TODO: Replace with your actual API call
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/users/carservicebooking/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      print('Booking Payload: $payload');

      
      print("ppppppppppppppppppppppppppppppppppppppppppppppppppp${response.body}");


      setState(() {
        isProcessingPayment = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back or to success screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              MainNavigationScreen(initialIndex: 3),
        ),
        (Route<dynamic> route) => false,
      );

    } catch (e) {
      setState(() {
        isProcessingPayment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeItemLocally(String id) {
    context.read<CartProvider>().removeLocal(userId, id);
  }

  Future<void> _selectPickupDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _pickupDate = picked);
    }
  }

  Future<void> _selectPickupTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _pickupTime = picked);
    }
  }

  Future<void> _selectBookingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _bookingDate = picked);
    }
  }

  Widget _pickupLocationSection() {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LocationPickerScreen(isEditing: false, userId: userId),
              ),
            );
          },
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: provider.isLoading
                      ? const Text('Fetching location...')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.address.isNotEmpty
                                  ? provider.address
                                  : 'Set pickup location',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (provider.coordinates != null)
                              Text(
                                'Lat: ${provider.coordinates![0]}, Lng: ${provider.coordinates![1]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bookingDateTimeSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectBookingDate,
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _bookingDate == null
                        ? 'Select booking date'
                        : '${_bookingDate!.day}/${_bookingDate!.month}/${_bookingDate!.year}',
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickupDateTimeSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectPickupDate,
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupDate == null
                        ? 'Select pickup date'
                        : '${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}',
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectPickupTime,
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupTime == null
                        ? 'Select pickup time'
                        : _pickupTime!.format(context),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showNotesModal() {
    final ctrl = TextEditingController(text: _notes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Any other requirements',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write instructions for service team...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() => _notes = ctrl.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout(int total) {
    if (total == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    // Validate booking date
    if (_bookingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select booking date')),
      );
      return;
    }

    // Validate pickup fields if pickup mode
    if (_mode == 'Pickup') {
      if (_pickupDate == null || _pickupTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select pickup date and time')),
        );
        return;
      }

      final provider = context.read<LocationProvider>();
      if (provider.address.isEmpty || provider.coordinates == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set pickup location')),
        );
        return;
      }
    }

    setState(() {
      isProcessingPayment = true;
    });

    if (_paymentMode == 'cash') {
      // Direct API call for cash payment
      _callBookingAPI();
    } else {
      // Razorpay integration for online payment
      var options = {
        'key': 'rzp_test_RgqXPvDLbgEIVv', // Replace with your key
        'amount': (total * 100), // Amount in paise
        'name': 'Car Service App',
        'description': 'Car Service Booking',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': mobile, 'email': email},
        'external': {
          'wallets': ['paytm'],
        },
      };

      try {
        _razorpay?.open(options);
      } catch (e) {
        setState(() {
          isProcessingPayment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initiating payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    final CartModel? cart = provider.cart;

    return PopScope(
      canPop: !isProcessingPayment,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          title: const Text(
            'My Cart',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: isProcessingPayment ? null : () => Navigator.pop(context),
          ),
        ),
        body: cart == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      children: [
                        /// CART ITEMS
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: cart.items.map((CartItem item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade700
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.car_repair),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text('₹ ${item.price}'),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _removeItemLocally(item.id),
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.grey.shade700
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: const Icon(Icons.close, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// NOTES
                        GestureDetector(
                          onTap: _showNotesModal,
                          child: _whiteCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _notes.isEmpty
                                        ? 'Any other requirements…'
                                        : _notes,
                                    style: TextStyle(
                                      color: _notes.isEmpty
                                          ? (Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade400
                                              : Colors.grey)
                                          : null,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _bookingDateTimeSection(),

                        const SizedBox(height: 14),

                        /// MODE OF SERVICE
                        _whiteCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode of Service',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Pickup',
                                    groupValue: _mode,
                                    onChanged: (v) =>
                                        setState(() => _mode = v!),
                                  ),
                                  const Text('Pickup'),
                                  Radio<String>(
                                    value: 'Walk In',
                                    groupValue: _mode,
                                    onChanged: (v) =>
                                        setState(() => _mode = v!),
                                  ),
                                  const Text('Walk In'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (_mode == 'Pickup') ...[
                          const SizedBox(height: 14),
                          _pickupDateTimeSection(),
                          const SizedBox(height: 14),
                          _pickupLocationSection(),
                        ],

                        const SizedBox(height: 14),

                        /// PAYMENT MODE
                        _whiteCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode of Payment',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'cash',
                                    groupValue: _paymentMode,
                                    onChanged: (v) =>
                                        setState(() => _paymentMode = v!),
                                  ),
                                  const Text('Cash'),
                                  Radio<String>(
                                    value: 'online',
                                    groupValue: _paymentMode,
                                    onChanged: (v) =>
                                        setState(() => _paymentMode = v!),
                                  ),
                                  const Text('Online (Razorpay)'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// BILL SUMMARY
                        _whiteCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bill Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _billRow('Item Total (Incl. taxes)', cart.total),
                              const Divider(),
                              _billRow('Grand Total', cart.total, bold: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),

                  /// CHECKOUT BAR
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cart Value',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade400
                                        : Colors.black54,
                                  ),
                                ),
                                Text(
                                  '₹ ${cart.total}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isProcessingPayment
                                ? null
                                : () => _checkout(cart.total),
                            child: isProcessingPayment
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// PROCESSING OVERLAY
                  if (isProcessingPayment)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Processing Payment...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please wait while we confirm your booking',
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _billRow(String title, int value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          '₹ $value',
          style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
        ),
      ],
    );
  }
}