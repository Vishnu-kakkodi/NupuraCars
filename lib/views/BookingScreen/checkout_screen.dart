// import 'package:nupura_cars/models/DocumentModel/document_model.dart';
// import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
// import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
// import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
// import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
// import 'package:nupura_cars/views/BookingScreen/booking_screen.dart';
// import 'package:nupura_cars/views/BookingScreen/kyc_verification_screen.dart';
// import 'package:nupura_cars/views/BookingScreen/payment_success_screen.dart';
// import 'package:nupura_cars/widgects/CustomSnakeBar/custom_snakebar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// failed({required String mesg, required context}) {
//   EasyLoading.dismiss();
//   return showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.error(message: "${mesg}"),
//   );
// }

// success({required String mesg, required BuildContext context}) {
//   EasyLoading.dismiss();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
//       backgroundColor: Colors.green[700],
//       behavior: SnackBarBehavior.floating,
//       duration: Duration(seconds: 3),
//     ),
//   );
// }

// showLoading() {
//   return EasyLoading.show(status: 'loading...');
// }

// enum PaymentOption { full, percent30 }

// class CheckoutScreen extends StatefulWidget {
//   final List<String> carImages;
//   final String carId;
//   final String carName;
//   final String fuel;
//   final String carType;
//   final int seats;
//   final String location;
//   final int pricePerDay;
//   final int pricePerHour;
//   final String branch;
//   final List cordinates;

//   const CheckoutScreen({
//     Key? key,
//     required this.carImages,
//     required this.carId,
//     required this.carName,
//     required this.fuel,
//     required this.carType,
//     required this.seats,
//     required this.location,
//     required this.pricePerDay,
//     required this.pricePerHour,
//     required this.branch,
//     required this.cordinates,
//   }) : super(key: key);

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   late String userId;
//   bool isLoading = true;
//   bool isProcessingPayment = false;
//   int selectedImageIndex = 0;
//   String? deposit;
//   int? totalPrice; // rental cost only
//   String name = '';
//   String email = '';
//   String mobile = '';
//   final PageController _pageController = PageController();

//   // New fields
//   bool carWashSelected = false;
//   bool dailyDepositSelected = false; // will be set when dropdown == 'Daily'
//   PaymentOption selectedPaymentOption = PaymentOption.full;
//   Razorpay? _razorpay;
//   // End new fields

//   @override
//   void initState() {
//     super.initState();
//     _getUserIdAndFetchDocuments();
//     _loadUserData();
//     _initRazorpay();
//   }

//   void _initRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     try {
//       _razorpay?.clear();
//     } catch (e) {}
//     super.dispose();
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

//   Future<void> _getUserIdAndFetchDocuments() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       userId = prefs.getString('userId') ?? '';

//       if (userId.isNotEmpty) {
//         await Provider.of<DocumentProvider>(
//           context,
//           listen: false,
//         ).fetchDocuments(userId);
//       }
//     } catch (e) {
//       print('Error getting user ID: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   int _calculateTotalHours(
//     DateTime? startDate,
//     TimeOfDay? startTime,
//     DateTime? endDate,
//     TimeOfDay? endTime,
//   ) {
//     if (startDate == null ||
//         endDate == null ||
//         startTime == null ||
//         endTime == null) return 0;

//     final startDateTime = DateTime(
//       startDate.year,
//       startDate.month,
//       startDate.day,
//       startTime.hour,
//       startTime.minute,
//     );

//     final endDateTime = DateTime(
//       endDate.year,
//       endDate.month,
//       endDate.day,
//       endTime.hour,
//       endTime.minute,
//     );

//     final difference = endDateTime.difference(startDateTime);
//     return difference.inMinutes <= 0 ? 0 : (difference.inMinutes / 60).ceil();
//   }

//   int calculatePriceForHours(int hours) {
//     if (hours <= 0) return 0;

//     if (hours < 24) {
//       return hours * widget.pricePerHour;
//     }

//     int fullDays = hours ~/ 24;
//     int remainingHours = hours % 24;

//     int dayPrice = fullDays * widget.pricePerDay;
//     int hourPrice = remainingHours * widget.pricePerHour;

//     return dayPrice + hourPrice;
//   }

//   int calculateTotalPrice(int totalHours) {
//     return calculatePriceForHours(totalHours);
//   }

//   String _formatTimeOfDay(TimeOfDay? time) {
//     if (time == null) return '--:--';
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }

//   Future<void> _openGoogleMaps() async {
//     try {
//       if (widget.cordinates.length >= 2) {
//         final double latitude = widget.cordinates[1].toDouble();
//         final double longitude = widget.cordinates[0].toDouble();

//         final String googleMapsUrl =
//             'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

//         final String googleMapsAppUrl = 'google.navigation:q=$latitude,$longitude';

//         bool launched = false;

//         try {
//           launched = await launchUrl(
//             Uri.parse(googleMapsAppUrl),
//             mode: LaunchMode.externalApplication,
//           );
//         } catch (e) {
//           print('Could not launch Google Maps app: $e');
//         }

//         if (!launched) {
//           launched = await launchUrl(
//             Uri.parse(googleMapsUrl),
//             mode: LaunchMode.externalApplication,
//           );
//         }

//         if (!launched) {
//           _showErrorSnackbar(
//             'Could not open Google Maps. Please check if you have Google Maps installed.',
//           );
//         }
//       } else {
//         _showErrorSnackbar('Location coordinates are not available.');
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to open Google Maps: $e');
//     }
//   }

//   // RAZORPAY handlers
//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     setState(() {
//       isProcessingPayment = false;
//     });
//     showAlertDialog(
//       context,
//       "Payment Failed",
//       "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.toString()}",
//     );
//   }

//   void showPaymentSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(16),
//         child: SizedBox(height: 400, child: PaymentSuccessScreen()),
//       ),
//     );
//   }

//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     // keep overlay
//     setState(() {
//       isProcessingPayment = true;
//     });

//     final dateTimeProvider = Provider.of<DateTimeProvider>(
//       context,
//       listen: false,
//     );
//     final bookingProvider = Provider.of<BookingProvider>(
//       context,
//       listen: false,
//     );
//     final documentProvider = Provider.of<DocumentProvider>(
//       context,
//       listen: false,
//     );

//     final userId = await StorageHelper.getUserId();

//     if (userId == null) {
//       setState(() {
//         isProcessingPayment = false;
//       });
//       _showErrorDialog("You must be logged in to create a booking");
//       return;
//     }

//     // final documents = documentProvider.uploadedDocuments;
//     // if (!_hasRequiredDocuments(documents)) {
//     //   setState(() {
//     //     isProcessingPayment = false;
//     //   });
//     //   _showDocumentMissingDialog();
//     //   return;
//     // }

//     if (deposit == null || deposit!.isEmpty) {
//       setState(() {
//         isProcessingPayment = false;
//       });
//       _showErrorDialog("Please select a security deposit option");
//       return;
//     }

//     final startDate = dateTimeProvider.startDate;
//     final endDate = dateTimeProvider.endDate;
//     final startTime = dateTimeProvider.startTime;
//     final endTime = dateTimeProvider.endTime;

//     if (startDate == null ||
//         endDate == null ||
//         startTime == null ||
//         endTime == null) {
//       setState(() {
//         isProcessingPayment = false;
//       });
//       _showErrorDialog("Please select dates and times for your booking");
//       return;
//     }

//     try {
//       final totalHours =
//           _calculateTotalHours(startDate, startTime, endDate, endTime);
//       final rentalCost = calculateTotalPrice(totalHours);
//       final carWashPrice = _getCarWashPrice(carWashSelected);
//       final days = _getTotalDaysFromHours(totalHours);
//       final dailyDepositAmt = dailyDepositSelected ? 1 * days : 0;
//       final grandTotal = rentalCost + carWashPrice + dailyDepositAmt;
//       final payableNow = _computePayableNow1(grandTotal);

//       // Create booking with new payload fields
//       final result = await bookingProvider.createBooking(
//         userId: userId,
//         carId: widget.carId,
//         rentalStartDate: startDate,
//         rentalEndDate: endDate,
//         from: startTime.format(context),
//         to: endTime.format(context),
//         deposit: deposit!,
//         amount: grandTotal,
//         transactionId: response.paymentId.toString(),
//         advancePayment: payableNow,
//         depositAmount: dailyDepositAmt,
//         completePayment: selectedPaymentOption == PaymentOption.full,
//         isCarWash: carWashSelected,
//         carWashAmount: carWashPrice,
//       );

//       setState(() {
//         isProcessingPayment = false;
//       });

//       if (result.booking.id != "") {
//         Navigator.pop(context);
//         final dateTimeProvider = Provider.of<DateTimeProvider>(
//           context,
//           listen: false,
//         );
//         dateTimeProvider.resetAll();

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => BookingScreen()),
//         );
//       } else {
//         _showErrorDialog(
//           bookingProvider.bookingError ?? "Failed to create booking",
//         );
//       }

//             if (result.booking.id != "") {
//         // Hide processing overlay before navigation
//         setState(() {
//           isProcessingPayment = false;
//         });

//         dateTimeProvider.resetAll();

//         // Navigate to payment success screen
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PaymentSuccessScreen(
//               // onContinue: () {
//               //   Navigator.pushAndRemoveUntil(
//               //     context,
//               //     MaterialPageRoute(
//               //       builder: (context) => MainNavigationScreen(initialIndex: 1),
//               //     ),
//               //     (route) => route.isFirst,
//               //   );
//               // },
//             ),
//           ),
//           (route) => false,
//         );
//       } else {
//         setState(() {
//           isProcessingPayment = false;
//         });
//         _showErrorSnackbar(
//           bookingProvider.bookingError ?? "Failed to create booking",
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isProcessingPayment = false;
//       });
//       _showErrorDialog("An error occurred: $e");
//     }
//   }

//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     showAlertDialog(
//       context,
//       "External Wallet Selected",
//       "${response.walletName}",
//     );
//   }

//   void showAlertDialog(BuildContext context, String title, String message) {
//     failed(mesg: "failed", context: context);
//   }

//   bool _hasRequiredDocuments(UploadedDocuments? documents) {
//     return (documents?.aadharCard?.url != null && documents!.aadharCard!.url != "") ||
//         (documents?.drivingLicense?.url != null && documents!.drivingLicense!.url != "");
//   }

//   void _showDocumentMissingDialog() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.warning_amber, color: Colors.orange, size: 28),
//             SizedBox(width: 12),
//             Text(
//               'Documents Required',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         content: Text(
//           'Please upload your Aadhar Card or Driving License to proceed with the booking.',
//           style: TextStyle(fontSize: 16),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: TextStyle(color: Colors.teal[600])),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       KycVerificationScreen(userId: userId, isEdit: false),
//                 ),
//               );

//               if (result == true) {
//                 await Provider.of<DocumentProvider>(
//                   context,
//                   listen: false,
//                 ).fetchDocuments(userId);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.teal,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text('Upload Now', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   int _getCarWashPrice(bool selected) {
//     if (!selected) return 0;
//     if (widget.seats == 5) return 99;
//     if (widget.seats == 7) return 199;
//     return 1;
//   }

//   int _getTotalDaysFromHours(int hours) {
//     if (hours <= 0) return 0;
//     final days = (hours / 24).ceil();
//     return days == 0 ? 1 : days;
//   }

//   int _computePayableNow(int grandTotal) {
//     if (selectedPaymentOption == PaymentOption.full) return grandTotal;
//         // if (selectedPaymentOption == PaymentOption.full) return 1;

//     return ((grandTotal * 0.30).ceil());
//         // return ((3 * 0.30).ceil());

//   }

//     int _computePayableNow1(int grandTotal) {
//     if (selectedPaymentOption == PaymentOption.full) return 0;
//         // if (selectedPaymentOption == PaymentOption.full) return 0;

//     return ((grandTotal * 0.30).ceil());
//         // return ((3 * 0.30).ceil());

//   }

//   Future<void> submitBooking() async {
//     final dateTimeProvider = Provider.of<DateTimeProvider>(
//       context,
//       listen: false,
//     );
//     final bookingProvider = Provider.of<BookingProvider>(
//       context,
//       listen: false,
//     );
//     final documentProvider = Provider.of<DocumentProvider>(
//       context,
//       listen: false,
//     );
//     final documents = documentProvider.uploadedDocuments;

//     // if (!_hasRequiredDocuments(documents)) {
//     //   _showDocumentMissingDialog();
//     //   return;
//     // }

//     if (deposit == null || deposit!.isEmpty) {
//       _showErrorDialog("Please select a security deposit option");
//       return;
//     }

//     final startDate = dateTimeProvider.startDate;
//     final endDate = dateTimeProvider.endDate;
//     final startTime = dateTimeProvider.startTime;
//     final endTime = dateTimeProvider.endTime;

//     if (startDate == null ||
//         endDate == null ||
//         startTime == null ||
//         endTime == null) {
//       _showErrorDialog("Please select dates and times for your booking");
//       return;
//     }

//     final totalHours =
//         _calculateTotalHours(startDate, startTime, endDate, endTime);
//     final rentalCost = calculateTotalPrice(totalHours);
//     final carWashPrice = _getCarWashPrice(carWashSelected);
//     final days = _getTotalDaysFromHours(totalHours);
//     final dailyDepositAmt = dailyDepositSelected ? 1000 * days : 0;
//     final grandTotal = rentalCost + carWashPrice + dailyDepositAmt;
//     final payableNow = _computePayableNow(grandTotal);

//     setState(() {
//       isProcessingPayment = true;
//     });

//     try {
//       var options = {
//         'key': 'rzp_test_RgqXPvDLbgEIVv',
//         'amount': (payableNow * 100),
//         'name': 'Varahi Self Drive Cars.',
//         'description': 'Booking Payment',
//         'retry': {'enabled': true, 'max_count': 1},
//         'send_sms_hash': true,
//         'prefill': {'contact': mobile, 'email': email},
//         'external': {
//           'wallets': ['paytm'],
//         },
//       };

//       _razorpay?.open(options);
//     } catch (e) {
//       setState(() {
//         isProcessingPayment = false;
//       });
//       _showErrorSnackbar("Error initiating payment: $e");
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Alert"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showDepositNotes(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Security Deposit Notes",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               _noteItem(
//                 "🚲 Bike",
//                 "Should be considered only if less than 4 years old.",
//               ),
//               _noteItem(
//                 "💻 Laptop",
//                 "Must include box cover and warranty card.",
//               ),
//               _noteItem(
//                 "💵 Cash",
//                 "Should be handed over directly at the office.",
//               ),
//               _noteItem(
//                 "📅 Daily",
//                 "Daily deposit is ₹1000 per day and is non-refundable.",
//               ),
//               const SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSelectedDepositNote(String selectedDeposit) {
//     String noteText;
//     IconData noteIcon;

//     switch (selectedDeposit) {
//       case 'Bike':
//         noteText = "Should be considered only if less than 4 years old.";
//         noteIcon = Icons.motorcycle;
//         break;
//       case 'Laptop':
//         noteText = "Must include box cover and warranty card.";
//         noteIcon = Icons.laptop;
//         break;
//       case 'Cash':
//         noteText = "Should be handed over directly at the office.";
//         noteIcon = Icons.payments;
//         break;
//       case 'Daily':
//         noteText = "Daily deposit: ₹1000 per day (non-refundable).";
//         noteIcon = Icons.calendar_today;
//         break;
//       default:
//         noteText = "";
//         noteIcon = Icons.info;
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.blue[50]!, Colors.teal[50]!],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue[200]!, width: 1),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.blue[500],
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue[300]!,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Icon(noteIcon, color: Colors.white, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               noteText,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.blue[900],
//                 height: 1.4,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _noteItem(String title, String description) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.green[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.green[100]!, width: 1),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.green[500],
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.check, color: Colors.white, size: 12),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 text: "$title: ",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                   color: Colors.green[900],
//                 ),
//                 children: [
//                   TextSpan(
//                     text: description,
//                     style: TextStyle(
//                       fontWeight: FontWeight.normal,
//                       color: Colors.green[800],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard({String? title, required Widget child}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.white, Colors.teal[50]!],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.teal[100]!, width: 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (title != null) ...[
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal[800],
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Divider(color: Colors.teal[300], height: 1),
//               const SizedBox(height: 16),
//             ],
//             child,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChip({required IconData icon, required String text}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.teal.withOpacity(0.15),
//             Colors.teal.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: Colors.teal),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.teal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateTimeInfo({
//     required String title,
//     required String date,
//     required String time,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue[100]!, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.blue[700],
//               letterSpacing: 0.5,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[500],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: const Icon(
//                   Icons.calendar_today,
//                   size: 14,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   date,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue[900],
//                   ),
//                   softWrap: true,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.teal,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Icon(icon, size: 14, color: Colors.white),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   time,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blue[800],
//                   ),
//                   softWrap: true,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentPreview({
//     required String title,
//     String? url,
//     required bool isUploaded,
//     required String documentType,
//   }) {
//     final documentProvider = Provider.of<DocumentProvider>(
//       context,
//       listen: false,
//     );
//     final documents = documentProvider.uploadedDocuments;

//     return GestureDetector(
//       onTap: () {
//         if (isUploaded && url != null) {
//           _showFullImageDialog(url, title);
//         } else if (!_hasRequiredDocuments(documents)) {
//           _showDocumentMissingDialog();
//         }
//       },
//       child: Container(
//         height: 140,
//         decoration: BoxDecoration(
//           gradient: isUploaded
//               ? LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.green[50]!, Colors.teal[50]!],
//                 )
//               : LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.teal[50]!, Colors.teal[100]!],
//                 ),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isUploaded ? Colors.green[300]! : Colors.teal[300]!,
//             width: isUploaded ? 2 : 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             if (isUploaded && url != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: Image.network(
//                         url,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Colors.green[100]!, Colors.teal[100]!],
//                               ),
//                             ),
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 value:
//                                     loadingProgress.expectedTotalBytes != null
//                                         ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                         : null,
//                                 strokeWidth: 2,
//                                 color: Colors.green[600],
//                               ),
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Colors.red[100]!, Colors.orange[100]!],
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.error_outline,
//                                   color: Colors.red[500],
//                                   size: 32,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Failed to load',
//                                   style: TextStyle(
//                                     color: Colors.red[700],
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Positioned.fill(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.1),
//                               Colors.black.withOpacity(0.5),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.8),
//                             ],
//                           ),
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(15),
//                             bottomRight: Radius.circular(15),
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               title,
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                               textAlign: TextAlign.center,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: Colors.green[300],
//                                   size: 12,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Uploaded',
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     color: Colors.green[300],
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.teal[800],
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.red[100],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.red[200]!),
//                       ),
//                       child: Text(
//                         'Not uploaded',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.red[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Colors.blue[500]!, Colors.teal[500]!],
//                         ),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         'Tap to upload',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showFullImageDialog(String imageUrl, String title) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Stack(
//           children: [
//             Center(
//               child: Container(
//                 margin: EdgeInsets.all(20),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         width: 200,
//                         height: 200,
//                         color: Colors.teal[800],
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         width: 200,
//                         height: 200,
//                         color: Colors.teal[800],
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.error_outline,
//                               color: Colors.white,
//                               size: 48,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Failed to load image',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.close, color: Colors.white, size: 24),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool get isUploaded {
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateTimeProvider = Provider.of<DateTimeProvider>(context);
//     final locationProvider = Provider.of<LocationProvider>(context);
//     final theme = Theme.of(context);

//     final startDate = dateTimeProvider.startDate;
//     final endDate = dateTimeProvider.endDate;
//     final startTime = dateTimeProvider.startTime;
//     final endTime = dateTimeProvider.endTime;

//     final totalHours = _calculateTotalHours(
//       startDate,
//       startTime,
//       endDate,
//       endTime,
//     );
//     final rentalCost = calculateTotalPrice(totalHours);
//     totalPrice = rentalCost;

//     final carWashPrice = _getCarWashPrice(carWashSelected);
//     final days = _getTotalDaysFromHours(totalHours);
//     final dailyDepositAmt = dailyDepositSelected ? 1000 * days : 0;
//     final grandTotal = rentalCost + carWashPrice + dailyDepositAmt;
//     final payableNow = _computePayableNow(grandTotal);
//     final remaining = grandTotal - payableNow;

//     return PopScope(
//       canPop: !isProcessingPayment,
//       child: Scaffold(
//         backgroundColor: Colors.teal[50],
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.teal,
//           foregroundColor: Colors.black87,
//           centerTitle: true,
//           title: Text(
//             'Checkout',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             onPressed: isProcessingPayment ? null : () => Navigator.pop(context),
//           ),
//         ),
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // car images etc (same as before)
//                   Container(
//                     height: 260,
//                     margin: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Stack(
//                         children: [
//                           PageView.builder(
//                             controller: _pageController,
//                             itemCount: widget.carImages.length,
//                             onPageChanged: (index) {
//                               setState(() {
//                                 selectedImageIndex = index;
//                               });
//                             },
//                             itemBuilder: (context, index) {
//                               return Hero(
//                                 tag: 'car_image_$index',
//                                 child: Image.network(
//                                   widget.carImages[index],
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       Container(
//                                     color: Colors.teal[200],
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.car_rental,
//                                         size: 50,
//                                         color: Colors.teal,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           Positioned(
//                             top: 16,
//                             right: 16,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black54,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 '${selectedImageIndex + 1}/${widget.carImages.length}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       widget.carImages.length,
//                       (index) => AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: selectedImageIndex == index ? 24 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: selectedImageIndex == index
//                               ? Colors.teal
//                               : Colors.teal[300],
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 24),

//                   _buildCard(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.carName,
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             _buildChip(
//                               icon: Icons.airline_seat_recline_normal,
//                               text: '${widget.seats} seats',
//                             ),
//                             SizedBox(width: 8),
//                             _buildChip(
//                               icon: Icons.local_gas_station,
//                               text: widget.fuel,
//                             ),
//                             SizedBox(width: 8),
//                             _buildChip(
//                               icon: Icons.directions_car,
//                               text: widget.carType,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   _buildCard(
//                     title: 'Rental Period',
//                     child: Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.teal.withOpacity(0.1),
//                             Colors.teal.withOpacity(0.05),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.teal.withOpacity(0.2)),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: _buildDateTimeInfo(
//                                   title: 'Pickup',
//                                   date: startDate != null
//                                       ? DateFormat(
//                                           'MMM dd, yyyy',
//                                         ).format(startDate)
//                                       : 'Select date',
//                                   time: _formatTimeOfDay(startTime),
//                                   icon: Icons.schedule,
//                                 ),
//                               ),
//                               Container(
//                                 width: 2,
//                                 height: 50,
//                                 color: Colors.teal.withOpacity(0.3),
//                                 margin: EdgeInsets.symmetric(horizontal: 16),
//                               ),
//                               Expanded(
//                                 child: _buildDateTimeInfo(
//                                   title: 'Return',
//                                   date: endDate != null
//                                       ? DateFormat(
//                                           'MMM dd, yyyy',
//                                         ).format(endDate)
//                                       : 'Select date',
//                                   time: _formatTimeOfDay(endTime),
//                                   icon: Icons.schedule,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.teal,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               'Total Duration: $totalHours hours',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   _buildCard(
//                     title: 'Pickup Location',
//                     child: GestureDetector(
//                       onTap: _openGoogleMaps,
//                       child: Container(
//                         height: 80,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.blue[200]!),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Stack(
//                             children: [
//                               Positioned.fill(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.blue.withOpacity(0.2),
//                                         Colors.blue.withOpacity(0.4),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue,
//                                         borderRadius: BorderRadius.circular(12),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black26,
//                                             blurRadius: 4,
//                                             offset: Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Icon(
//                                         Icons.location_on,
//                                         color: Colors.white,
//                                         size: 24,
//                                       ),
//                                     ),
//                                     SizedBox(width: 16),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             widget.location,
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               color: const Color.fromARGB(
//                                                 255,
//                                                 0,
//                                                 0,
//                                                 0,
//                                               ),
//                                               shadows: [
//                                                 Shadow(
//                                                   offset: Offset(0, 1),
//                                                   blurRadius: 3,
//                                                   color: Colors.black54,
//                                                 ),
//                                               ],
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           SizedBox(height: 4),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.2),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Icon(
//                                         Icons.arrow_forward_ios,
//                                         color: const Color.fromARGB(
//                                           255,
//                                           0,
//                                           0,
//                                           0,
//                                         ),
//                                         size: 16,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Add-ons card (car wash)
//                   _buildCard(
//                     title: 'Add-ons',
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.seats == 5 || widget.seats == 7) ...[
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: carWashSelected,
//                                 onChanged: (v) {
//                                   setState(() {
//                                     carWashSelected = v ?? false;
//                                   });
//                                 },
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   'Car wash (${widget.seats == 5 ? '99' : '199'})',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 'Add',
//                                 style: TextStyle(color: Colors.teal),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                         ] else
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: false,
//                                 onChanged: null,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   'Car wash (Not available for this vehicle)',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),

//                   // SECURITY DEPOSIT card: dropdown includes Daily option now
//                   _buildCard(
//                     title: 'Security Deposit',
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         DropdownButtonFormField<String>(
//                           value: deposit,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(color: Colors.teal[300]!),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(color: Colors.teal[300]!),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: Colors.teal,
//                                 width: 2,
//                               ),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 16,
//                             ),
//                             hintText: 'Select deposit option',
//                             prefixIcon: const Icon(Icons.security),
//                           ),
//                           items: <DropdownMenuItem<String>>[
//                             DropdownMenuItem(
//                               value: 'Bike',
//                               child: Text('Bike'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'Laptop',
//                               child: Text('Laptop'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'Cash',
//                               child: Text('Cash'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'Daily',
//                               child: Text('Daily (₹1000 / day)'),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               deposit = value;
//                               // dailyDepositSelected becomes true only if user picks 'Daily'
//                               dailyDepositSelected = (value == 'Daily');
//                             });
//                           },
//                         ),

//                         const SizedBox(height: 12),

//                         if (dailyDepositSelected) ...[
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.blue[50],
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.blue[100]!),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Daily deposit: 1000 x $days',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.blue[800],
//                                   ),
//                                 ),
//                                 Text(
//                                   '₹${(1000 * days).toString()}',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                         ],

//                         if (deposit != null) ...[
//                           _buildSelectedDepositNote(deposit!),
//                         ],
//                       ],
//                     ),
//                   ),

//                   // Price summary (same as previous implementation)
//                   _buildCard(
//                     title: 'Price Summary',
//                     child: Container(
//                       padding: EdgeInsets.all(0),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Rental Cost',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.teal[700],
//                                   ),
//                                 ),
//                                 Text(
//                                   '₹${rentalCost.toString()}',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (carWashPrice > 0) ...[
//                             const SizedBox(height: 6),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Car wash',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.teal[700],
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹${carWashPrice.toString()}',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                           const SizedBox(height: 6),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Security Deposit',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.teal[700],
//                                   ),
//                                 ),
//                                 Text(
//                                   deposit == 'Daily' ? 'Daily (₹1000/day)' : (deposit ?? 'Not selected'),
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: deposit != null ? Colors.green[600] : Colors.red[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (dailyDepositAmt > 0) ...[
//                             const SizedBox(height: 6),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Daily deposit total',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.teal[700],
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹${dailyDepositAmt.toString()}',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                           Divider(height: 32, thickness: 1),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Total Amount',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 Text(
//                                   '₹${grandTotal.toString()}',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     color: Colors.teal,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           // Payment options
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Payment Option',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.teal[800],
//                                 ),
//                               ),
//                               ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text('Full Payment (₹${grandTotal.toString()})'),
//                                 leading: Radio<PaymentOption>(
//                                   value: PaymentOption.full,
//                                   groupValue: selectedPaymentOption,
//                                   onChanged: (PaymentOption? value) {
//                                     setState(() {
//                                       selectedPaymentOption = value ?? PaymentOption.full;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text('30% Advance (₹${payableNow.toString()})'),
//                                 subtitle: Text('Remaining ₹${(grandTotal - payableNow).toString()} to be paid later'),
//                                 leading: Radio<PaymentOption>(
//                                   value: PaymentOption.percent30,
//                                   groupValue: selectedPaymentOption,
//                                   onChanged: (PaymentOption? value) {
//                                     setState(() {
//                                       selectedPaymentOption = value ?? PaymentOption.percent30;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 16),
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.amber[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.amber[200]!),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           color: Colors.amber[800],
//                           size: 20,
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             'Once booking payment is completed amount is not refund',
//                             style: TextStyle(
//                               color: Colors.amber[800],
//                               fontSize: 14,
//                               height: 1.4,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: 100),
//                 ],
//               ),
//             ),

//             if (isProcessingPayment)
//               Container(
//                 color: Colors.black.withOpacity(0.7),
//                 child: Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(24),
//                     margin: const EdgeInsets.symmetric(horizontal: 40),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.teal,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Processing Payment...',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Please wait while we confirm your booking',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.teal[600],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),

//         bottomNavigationBar: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 8,
//                 offset: Offset(0, -2),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: ElevatedButton(
//               onPressed: isProcessingPayment ? null : submitBooking,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 2,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (isProcessingPayment)
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   else
//                     Text(
//                       isProcessingPayment ? 'Processing...' : 'Continue to Pay',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




















import 'package:nupura_cars/models/DocumentModel/document_model.dart';
import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/booking_screen.dart';
import 'package:nupura_cars/views/BookingScreen/kyc_verification_screen.dart';
import 'package:nupura_cars/views/BookingScreen/payment_success_screen.dart';
import 'package:nupura_cars/widgects/CustomSnakeBar/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// Helper functions
failed({required String mesg, required context}) {
  EasyLoading.dismiss();
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(message: "${mesg}"),
  );
}

success({required String mesg, required BuildContext context}) {
  EasyLoading.dismiss();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
      backgroundColor: Colors.green[700],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ),
  );
}

showLoading() {
  return EasyLoading.show(status: 'loading...');
}

enum PaymentOption { full, percent30 }

class CheckoutScreen extends StatefulWidget {
  final List<String> carImages;
  final String carId;
  final String carName;
  final String fuel;
  final String carType;
  final int seats;
  final String location;
  final int pricePerDay;
  final int pricePerHour;
  final String branch;
  final List cordinates;

  const CheckoutScreen({
    Key? key,
    required this.carImages,
    required this.carId,
    required this.carName,
    required this.fuel,
    required this.carType,
    required this.seats,
    required this.location,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.branch,
    required this.cordinates,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String userId;
  bool isLoading = true;
  bool isProcessingPayment = false;
  int selectedImageIndex = 0;
  String? deposit;
  int? totalPrice;
  String name = '';
  String email = '';
  String mobile = '';
  final PageController _pageController = PageController();

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

  bool carWashSelected = false;
  bool dailyDepositSelected = false;
  PaymentOption selectedPaymentOption = PaymentOption.full;
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _getUserIdAndFetchDocuments();
    _loadUserData();
    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    _pageController.dispose();
    try {
      _razorpay?.clear();
    } catch (e) {}
    super.dispose();
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

  Future<void> _getUserIdAndFetchDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';

      if (userId.isNotEmpty) {
        await Provider.of<DocumentProvider>(
          context,
          listen: false,
        ).fetchDocuments(userId);
      }
    } catch (e) {
      print('Error getting user ID: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateTotalHours(
    DateTime? startDate,
    TimeOfDay? startTime,
    DateTime? endDate,
    TimeOfDay? endTime,
  ) {
    if (startDate == null ||
        endDate == null ||
        startTime == null ||
        endTime == null) return 0;

    final startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );

    final endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    );

    final difference = endDateTime.difference(startDateTime);
    return difference.inMinutes <= 0 ? 0 : (difference.inMinutes / 60).ceil();
  }

  int calculatePriceForHours(int hours) {
    if (hours <= 0) return 0;

    if (hours < 24) {
      return hours * widget.pricePerHour;
    }

    int fullDays = hours ~/ 24;
    int remainingHours = hours % 24;

    int dayPrice = fullDays * widget.pricePerDay;
    int hourPrice = remainingHours * widget.pricePerHour;

    return dayPrice + hourPrice;
  }

  int calculateTotalPrice(int totalHours) {
    return calculatePriceForHours(totalHours);
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _openGoogleMaps() async {
    try {
      if (widget.cordinates.length >= 2) {
        final double latitude = widget.cordinates[1].toDouble();
        final double longitude = widget.cordinates[0].toDouble();

        final String googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

        final String googleMapsAppUrl = 'google.navigation:q=$latitude,$longitude';

        bool launched = false;

        try {
          launched = await launchUrl(
            Uri.parse(googleMapsAppUrl),
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          print('Could not launch Google Maps app: $e');
        }

        if (!launched) {
          launched = await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        }

        if (!launched) {
          _showErrorSnackbar(
            'Could not open Google Maps. Please check if you have Google Maps installed.',
          );
        }
      } else {
        _showErrorSnackbar('Location coordinates are not available.');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to open Google Maps: $e');
    }
  }

  // RAZORPAY handlers
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    setState(() {
      isProcessingPayment = false;
    });
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}",
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    setState(() {
      isProcessingPayment = true;
    });

    final dateTimeProvider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );

    final userId = await StorageHelper.getUserId();

    if (userId == null) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorDialog("You must be logged in to create a booking");
      return;
    }

    if (deposit == null || deposit!.isEmpty) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorDialog("Please select a security deposit option");
      return;
    }

    final startDate = dateTimeProvider.startDate;
    final endDate = dateTimeProvider.endDate;
    final startTime = dateTimeProvider.startTime;
    final endTime = dateTimeProvider.endTime;

    if (startDate == null ||
        endDate == null ||
        startTime == null ||
        endTime == null) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorDialog("Please select dates and times for your booking");
      return;
    }

    try {
      final totalHours =
          _calculateTotalHours(startDate, startTime, endDate, endTime);
      final rentalCost = calculateTotalPrice(totalHours);
      final carWashPrice = _getCarWashPrice(carWashSelected);
      final days = _getTotalDaysFromHours(totalHours);
      final dailyDepositAmt = dailyDepositSelected ? 1000 * days : 0;
      final grandTotal = rentalCost + carWashPrice + dailyDepositAmt;
      final payableNow = _computePayableNow1(grandTotal);

      final result = await bookingProvider.createBooking(
        userId: userId,
        carId: widget.carId,
        rentalStartDate: startDate,
        rentalEndDate: endDate,
        from: startTime.format(context),
        to: endTime.format(context),
        deposit: deposit!,
        amount: grandTotal,
        transactionId: response.paymentId.toString(),
        advancePayment: payableNow,
        depositAmount: dailyDepositAmt,
        completePayment: selectedPaymentOption == PaymentOption.full,
        isCarWash: carWashSelected,
        carWashAmount: carWashPrice,
      );

      if (result.booking.id != "") {
        setState(() {
          isProcessingPayment = false;
        });

        dateTimeProvider.resetAll();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          isProcessingPayment = false;
        });
        _showErrorSnackbar(
          bookingProvider.bookingError ?? "Failed to create booking",
        );
      }
    } catch (e) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorDialog("An error occurred: $e");
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      "External Wallet Selected",
      "${response.walletName}",
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    failed(mesg: "Payment Failed", context: context);
  }

  bool _hasRequiredDocuments(UploadedDocuments? documents) {
    return (documents?.aadharCard?.url != null && documents!.aadharCard!.url != "") ||
        (documents?.drivingLicense?.url != null && documents!.drivingLicense!.url != "");
  }

  void _showDocumentMissingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text(
              'Documents Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Please upload your Aadhar Card or Driving License to proceed with the booking.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: _primaryColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      KycVerificationScreen(userId: userId, isEdit: false),
                ),
              );

              if (result == true) {
                await Provider.of<DocumentProvider>(
                  context,
                  listen: false,
                ).fetchDocuments(userId);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Upload Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  int _getCarWashPrice(bool selected) {
    if (!selected) return 0;
    if (widget.seats == 5) return 99;
    if (widget.seats == 7) return 199;
    return 1;
  }

  int _getTotalDaysFromHours(int hours) {
    if (hours <= 0) return 0;
    final days = (hours / 24).ceil();
    return days == 0 ? 1 : days;
  }

  int _computePayableNow(int grandTotal) {
    if (selectedPaymentOption == PaymentOption.full) return grandTotal;
    return ((grandTotal * 0.30).ceil());
  }

  int _computePayableNow1(int grandTotal) {
    if (selectedPaymentOption == PaymentOption.full) return 0;
    return ((grandTotal * 0.30).ceil());
  }

  Future<void> submitBooking() async {
    final dateTimeProvider = Provider.of<DateTimeProvider>(
      context,
      listen: false,
    );
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );

    if (deposit == null || deposit!.isEmpty) {
      _showErrorDialog("Please select a security deposit option");
      return;
    }

    final startDate = dateTimeProvider.startDate;
    final endDate = dateTimeProvider.endDate;
    final startTime = dateTimeProvider.startTime;
    final endTime = dateTimeProvider.endTime;

    if (startDate == null ||
        endDate == null ||
        startTime == null ||
        endTime == null) {
      _showErrorDialog("Please select dates and times for your booking");
      return;
    }

    final totalHours =
        _calculateTotalHours(startDate, startTime, endDate, endTime);
    final rentalCost = calculateTotalPrice(totalHours);
    final carWashPrice = _getCarWashPrice(carWashSelected);
    final days = _getTotalDaysFromHours(totalHours);
    final dailyDepositAmt = dailyDepositSelected ? 1000 * days : 0;
    final grandTotal = rentalCost + carWashPrice + dailyDepositAmt;
    final payableNow = _computePayableNow(grandTotal);

    setState(() {
      isProcessingPayment = true;
    });

    try {
      var options = {
        'key': 'rzp_test_RgqXPvDLbgEIVv',
        'amount': (payableNow * 100),
        'name': 'Car Service App.',
        'description': 'Booking Payment',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': mobile, 'email': email},
        'external': {
          'wallets': ['paytm'],
        },
      };

      _razorpay?.open(options);
    } catch (e) {
      setState(() {
        isProcessingPayment = false;
      });
      _showErrorSnackbar("Error initiating payment: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alert", style: TextStyle(color: _textPrimary)),
        content: Text(message, style: TextStyle(color: _textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK", style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  // UI Building Methods with Modern Design
  Widget _buildCard({String? title, required Widget child, Color? backgroundColor}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey.shade200, height: 1),
              SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _primaryColor),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeCard({
    required String title,
    required String date,
    required String time,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, size: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({required String label, required String value, bool isTotal = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? _textPrimary : _textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? _primaryColor : _textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required String title,
    required String subtitle,
    required PaymentOption option,
    required String amount,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentOption = option;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedPaymentOption == option ? _primaryColor.withOpacity(0.1) : _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedPaymentOption == option ? _primaryColor : Colors.grey.shade200,
            width: selectedPaymentOption == option ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedPaymentOption == option ? _primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: selectedPaymentOption == option
                  ? Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryColor,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeProvider = Provider.of<DateTimeProvider>(context);
    final theme = Theme.of(context);

    final startDate = dateTimeProvider.startDate;
    final endDate = dateTimeProvider.endDate;
    final startTime = dateTimeProvider.startTime;
    final endTime = dateTimeProvider.endTime;

    final totalHours = _calculateTotalHours(
      startDate,
      startTime,
      endDate,
      endTime,
    );
    final rentalCost = calculateTotalPrice(totalHours);
    totalPrice = rentalCost;

    final carWashPrice = _getCarWashPrice(carWashSelected);
    final days = _getTotalDaysFromHours(totalHours);
    final dailyDepositAmt = dailyDepositSelected ? 1000 * days : 0;
    final grandTotal = rentalCost + carWashPrice + dailyDepositAmt;
    final payableNow = _computePayableNow(grandTotal);
    final remaining = grandTotal - payableNow;

    return PopScope(
      canPop: !isProcessingPayment,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: _textPrimary,
          centerTitle: true,
          title: Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: _textPrimary,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: _textPrimary),
            onPressed: isProcessingPayment ? null : () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Images Section
                  Container(
                    height: 220,
                    margin: EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: widget.carImages.length,
                            onPageChanged: (index) {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                widget.carImages[index],
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: _primaryColor.withOpacity(0.1),
                                  child: Center(
                                    child: Icon(
                                      Icons.directions_car,
                                      size: 50,
                                      color: _primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${selectedImageIndex + 1}/${widget.carImages.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Car Details
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.carName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFeatureChip(
                              icon: Icons.airline_seat_recline_normal,
                              text: '${widget.seats} seats',
                            ),
                            _buildFeatureChip(
                              icon: Icons.local_gas_station,
                              text: widget.fuel,
                            ),
                            _buildFeatureChip(
                              icon: Icons.directions_car,
                              text: widget.carType,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Rental Period
                  _buildCard(
                    title: 'Rental Period',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateTimeCard(
                                title: 'Pickup',
                                date: startDate != null
                                    ? DateFormat('MMM dd, yyyy').format(startDate)
                                    : 'Select date',
                                time: _formatTimeOfDay(startTime),
                                icon: Icons.schedule,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildDateTimeCard(
                                title: 'Return',
                                date: endDate != null
                                    ? DateFormat('MMM dd, yyyy').format(endDate)
                                    : 'Select date',
                                time: _formatTimeOfDay(endTime),
                                icon: Icons.schedule,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_primaryColor, _secondaryColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Total Duration: $totalHours hours',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Location
                  _buildCard(
                    title: 'Pickup Location',
                    child: GestureDetector(
                      onTap: _openGoogleMaps,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor.withOpacity(0.1),
                              _secondaryColor.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _primaryColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.location_on, color: Colors.white, size: 24),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tap to open in Maps',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: _textSecondary, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Add-ons
                  _buildCard(
                    title: 'Add-ons',
                    child: Column(
                      children: [
                        if (widget.seats == 5 || widget.seats == 7)
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _primaryColor.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: carWashSelected,
                                  onChanged: (v) {
                                    setState(() {
                                      carWashSelected = v ?? false;
                                    });
                                  },
                                  activeColor: _primaryColor,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Car Wash Service',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: _textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '₹${widget.seats == 5 ? '99' : '199'} - Professional interior cleaning',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: _textSecondary, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Car wash not available for this vehicle',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Security Deposit
                  _buildCard(
                    title: 'Security Deposit',
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButton<String>(
                            value: deposit,
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
                            hint: Text('Select deposit option'),
                            items: [
                              DropdownMenuItem(value: 'Bike', child: Text('Bike')),
                              DropdownMenuItem(value: 'Laptop', child: Text('Laptop')),
                              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                              DropdownMenuItem(
                                value: 'Daily',
                                child: Text('Daily (₹1000/day)'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                deposit = value;
                                dailyDepositSelected = (value == 'Daily');
                              });
                            },
                          ),
                        ),
                        if (deposit != null && deposit == 'Daily') ...[
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _accentColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Daily Deposit Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _accentColor,
                                  ),
                                ),
                                Text(
                                  '₹${(1000 * days).toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Price Summary
                  _buildCard(
                    title: 'Price Summary',
                    child: Column(
                      children: [
                        _buildPriceRow(
                          label: 'Rental Cost',
                          value: '₹${rentalCost.toString()}',
                        ),
                        if (carWashPrice > 0)
                          _buildPriceRow(
                            label: 'Car Wash',
                            value: '₹${carWashPrice.toString()}',
                          ),
                        if (dailyDepositAmt > 0)
                          _buildPriceRow(
                            label: 'Security Deposit',
                            value: '₹${dailyDepositAmt.toString()}',
                          ),
                        Divider(color: Colors.grey.shade300, height: 24),
                        _buildPriceRow(
                          label: 'Total Amount',
                          value: '₹${grandTotal.toString()}',
                          isTotal: true,
                        ),
                        SizedBox(height: 20),
                        
                        // Payment Options
                        Text(
                          'Choose Payment Option',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildPaymentOptionCard(
                          title: 'Pay Full Amount',
                          subtitle: 'Pay the complete amount now',
                          option: PaymentOption.full,
                          amount: '₹${grandTotal.toString()}',
                        ),
                        _buildPaymentOptionCard(
                          title: 'Pay 30% Advance',
                          subtitle: 'Pay ₹${payableNow.toString()} now, remaining ₹${remaining.toString()} later',
                          option: PaymentOption.percent30,
                          amount: '₹${payableNow.toString()}',
                        ),
                      ],
                    ),
                  ),

                  // Info Banner
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: _accentColor, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Once booking payment is completed, amount is non-refundable',
                            style: TextStyle(
                              color: _accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),

            // Processing Overlay
            if (isProcessingPayment)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Processing Payment...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please wait while we confirm your booking',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: isProcessingPayment ? null : submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                shadowColor: _primaryColor.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isProcessingPayment)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    Icon(Icons.lock_outline, size: 20),
                  SizedBox(width: 8),
                  Text(
                    isProcessingPayment ? 'Processing...' : 'Pay ₹${payableNow.toString()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}