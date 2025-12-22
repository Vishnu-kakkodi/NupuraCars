

// import 'package:car_rental_app/providers/theme_provider.dart';
// import 'package:car_rental_app/utils/storage_helper.dart';
// import 'package:car_rental_app/views/booking_screen.dart';
// import 'package:car_rental_app/views/payment_success_screen.dart';
// import 'package:car_rental_app/widgect/custom_snakebar.dart';
import 'package:nupura_cars/providers/ThemeProvider/theme_provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';
import 'package:nupura_cars/views/BookingScreen/payment_success_screen.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:nupura_cars/widgects/CustomSnakeBar/custom_snakebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


failed({required String mesg, required context}) {
  EasyLoading.dismiss();
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: "${mesg}",
    ),
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

class ExtendDatePage extends StatefulWidget {
  final String userId;
  final String bookingId;
  final DateTime deliveryDate;
  final String to;
  final int price;
  final int pricePerHour;
  final int pricePerDay;

  const ExtendDatePage(
      {super.key,
      required this.userId,
      required this.bookingId,
      required this.deliveryDate,
      required this.to,
      required this.price,
      required this.pricePerHour,
      required this.pricePerDay
      });

  @override
  _ExtendDatePageState createState() => _ExtendDatePageState();
}

class _ExtendDatePageState extends State<ExtendDatePage> {
  String? formattedDate;
  String? formattedTime;

  // Selection state
  int? selectedHours;
  DateTime? customExtendDate;
  TimeOfDay? customExtendTime;

  // Calculated values
  int extendAmount = 0;
  int totalAmount = 0;
  int totalExtendHours = 0;
    String email = '';
  String mobile = '';

  // API state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeDates();
    calculateAmounts();
            _loadUserData();

  }

      Future<void> _loadUserData() async {
    // Load all user data
    final userName = await StorageHelper.getUserName();
    final userEmail = await StorageHelper.getEmail();
    final userMobile = await StorageHelper.getMobile();

    // Update state with the retrieved values
    setState(() {
      email = userEmail ?? '';
      mobile = userMobile ?? '';
    });
  }

  void initializeDates() {
    String rawDateTime = (widget.deliveryDate).toString();
    DateTime dateTime = DateTime.parse(rawDateTime);

    formattedDate = DateFormat('EEE, MMM d').format(dateTime);
    formattedTime = (widget.to).toString();

    print('Date: $formattedDate');
    print('Time: $formattedTime');
  }

  void selectHours(int hours) {
    setState(() {
      selectedHours = hours;
      // Clear custom date/time when hours are selected
      customExtendDate = null;
      customExtendTime = null;
      calculateAmounts();
    });
  }

  void selectCustomDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.deliveryDate.add(const Duration(days: 1)),
      firstDate: widget.deliveryDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        customExtendDate = pickedDate;
        // Clear hour selection when custom date is selected
        selectedHours = null;
        calculateAmounts();
      });
    }
  }

  void selectCustomTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.deliveryDate),
    );

    if (pickedTime != null) {
      setState(() {
        customExtendTime = pickedTime;
        // Clear hour selection when custom time is selected
        selectedHours = null;
        calculateAmounts();
      });
    }
  }

  // void calculateAmounts() {
  //   if (selectedHours != null) {
  //     // Calculate based on selected hours
  //     totalExtendHours = selectedHours!;
  //     extendAmount = selectedHours! * (widget.pricePerHour.toDouble());
  //   } else if (customExtendDate != null || customExtendTime != null) {
  //     // Calculate based on custom date/time
  //     DateTime newDeliveryDate = widget.deliveryDate;

  //     if (customExtendDate != null) {
  //       newDeliveryDate = DateTime(
  //         customExtendDate!.year,
  //         customExtendDate!.month,
  //         customExtendDate!.day,
  //         newDeliveryDate.hour,
  //         newDeliveryDate.minute,
  //       );
  //     }

  //     if (customExtendTime != null) {
  //       newDeliveryDate = DateTime(
  //         newDeliveryDate.year,
  //         newDeliveryDate.month,
  //         newDeliveryDate.day,
  //         customExtendTime!.hour,
  //         customExtendTime!.minute,
  //       );
  //     }

  //     // Calculate difference in hours
  //     Duration difference = newDeliveryDate.difference(widget.deliveryDate);
  //     totalExtendHours = difference.inHours;

  //     if (totalExtendHours > 0) {
  //       extendAmount = totalExtendHours * (widget.pricePerHour.toDouble());
  //     } else {
  //       extendAmount = 0;
  //       totalExtendHours = 0;
  //     }
  //   } else {
  //     extendAmount = 0;
  //     totalExtendHours = 0;
  //   }

  //   totalAmount = extendAmount;
  // }


// void calculateAmounts() {
//   if (selectedHours != null) {
//     // Calculate based on selected hours
//     totalExtendHours = selectedHours!;
//     extendAmount = calculatePriceForHours(selectedHours!);
//   } else if (customExtendDate != null || customExtendTime != null) {
//     // Calculate based on custom date/time
//     DateTime newDeliveryDate = widget.deliveryDate;

//     if (customExtendDate != null) {
//       newDeliveryDate = DateTime(
//         customExtendDate!.year,
//         customExtendDate!.month,
//         customExtendDate!.day,
//         newDeliveryDate.hour,
//         newDeliveryDate.minute,
//       );
//     }

//     if (customExtendTime != null) {
//       newDeliveryDate = DateTime(
//         newDeliveryDate.year,
//         newDeliveryDate.month,
//         newDeliveryDate.day,
//         customExtendTime!.hour,
//         customExtendTime!.minute,
//       );
//     }

//     // Calculate difference in hours
//         print("ppppppppppppppppppppppppppppppppppppppppppppp$newDeliveryDate");
//                 print("ppppppppppppppppppppppppppppppppppppppppppppp${widget.deliveryDate}");
//                 print("ppppppppppppppppppppppppppppppppppppppppppppp${widget.to}");


//     Duration difference = newDeliveryDate.difference(widget.deliveryDate);
//     totalExtendHours = difference.inHours;
//     print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$difference");

//     print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$totalExtendHours");

//     if (totalExtendHours > 0) {
//       extendAmount = calculatePriceForHours(totalExtendHours);
//     } else {
//       extendAmount = 0;
//       totalExtendHours = 0;
//     }
//   } else {
//     extendAmount = 0;
//     totalExtendHours = 0;
//   }

//   totalAmount = extendAmount;
// }

// // New method to calculate price based on hours with day/hour logic
// double calculatePriceForHours(int hours) {

//   print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkk$hours');
//   if (hours <= 0) return 0;
  
//   // If less than 24 hours, use hourly rate
//   if (hours < 24) {
//     print("Helllllllllllllllllllllllllllllllllllll$hours");
//         print("Helllllllllllllllllllllllllllllllllllll${widget.pricePerHour.toDouble()}");

//     return hours * widget.pricePerHour.toDouble();
//   }
  
//   // If 24 hours or more, calculate days and remaining hours
//   int fullDays = hours ~/ 24; // Integer division to get full days
//   int remainingHours = hours % 24; // Remaining hours after full days
//      print("HelllllllllllllllllllllllllllllllllllllFullDays$fullDays");
//         print("Helllllllllllllllllllllllllllllllllllll$remainingHours");
//         print("DayPrice${widget.pricePerDay.toDouble()}");
  
//   // Calculate price: (full days * price per day) + (remaining hours * price per hour)
//   double dayPrice = fullDays * widget.pricePerDay.toDouble();
//   double hourPrice = remainingHours * widget.pricePerHour.toDouble();
//      print("HelllllllllllllllllllllllllllllllllllllDaysPrice$dayPrice");
//         print("Helllllllllllllllllllllllllllllllllllll$hourPrice");
  
//   return dayPrice + hourPrice;
// }



void calculateAmounts() {
  if (selectedHours != null) {
    // Calculate based on selected hours
    totalExtendHours = selectedHours!;
    extendAmount = calculatePriceForHours(selectedHours!);
  } else if (customExtendDate != null || customExtendTime != null) {
    // Calculate based on custom date/time
    
    // First, create the original delivery DateTime by combining date and time
    DateTime originalDeliveryDateTime = getOriginalDeliveryDateTime();
    
    DateTime newDeliveryDate = originalDeliveryDateTime;

    if (customExtendDate != null) {
      newDeliveryDate = DateTime(
        customExtendDate!.year,
        customExtendDate!.month,
        customExtendDate!.day,
        originalDeliveryDateTime.hour,
        originalDeliveryDateTime.minute,
      );
    }

    if (customExtendTime != null) {
      newDeliveryDate = DateTime(
        newDeliveryDate.year,
        newDeliveryDate.month,
        newDeliveryDate.day,
        customExtendTime!.hour,
        customExtendTime!.minute,
      );
    }

    // Calculate difference in hours
    print("Original delivery DateTime: $originalDeliveryDateTime");
    print("New delivery DateTime: $newDeliveryDate");
    
    Duration difference = newDeliveryDate.difference(originalDeliveryDateTime);
    totalExtendHours = difference.inHours;
    
    print("Duration difference: $difference");
    print("Total extend hours: $totalExtendHours");

    if (totalExtendHours > 0) {
      extendAmount = calculatePriceForHours(totalExtendHours);
    } else {
      extendAmount = 0;
      totalExtendHours = 0;
    }
  } else {
    extendAmount = 0;
    totalExtendHours = 0;
  }

  setState(() {
    totalAmount = extendAmount;
  });
}

// Helper method to combine delivery date and time
DateTime getOriginalDeliveryDateTime() {
  try {
    // Parse the time string (widget.to) - assuming format like "12:00 PM" or "14:30"
    DateFormat timeFormat;
    
    // Check if the time contains AM/PM
    if (widget.to.toUpperCase().contains('AM') || widget.to.toUpperCase().contains('PM')) {
      timeFormat = DateFormat('h:mm a'); // For "12:00 PM" format
    } else {
      timeFormat = DateFormat('HH:mm'); // For "14:30" format
    }
    
    DateTime timeOnly = timeFormat.parse(widget.to);
    
    // Combine the delivery date with the parsed time
    DateTime combinedDateTime = DateTime(
      widget.deliveryDate.year,
      widget.deliveryDate.month,
      widget.deliveryDate.day,
      timeOnly.hour,
      timeOnly.minute,
    );
    
    return combinedDateTime;
  } catch (e) {
    print("Error parsing delivery time: $e");
    // Fallback to original delivery date if parsing fails
    return widget.deliveryDate;
  }
}

// New method to calculate price based on hours with day/hour logic
int calculatePriceForHours(int hours) {
  if (hours <= 0) return 0;
  
  // If less than 24 hours, use hourly rate
  if (hours < 24) {
    return hours * widget.pricePerHour;
  }
  
  // If 24 hours or more, calculate days and remaining hours
  int fullDays = hours ~/ 24; // Integer division to get full days
  int remainingHours = hours % 24; // Remaining hours after full days
  
  // Calculate price: (full days * price per day) + (remaining hours * price per hour)
  int dayPrice = fullDays * widget.pricePerDay;
  int hourPrice = remainingHours * widget.pricePerHour;
  
  return dayPrice + hourPrice;
}


  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // EasyLoading.dismiss();
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.toString()}");
  }

    void showPaymentSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 400,
        child: PaymentSuccessScreen(),
      ),
    ),
  );
}

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    failed(mesg: "failed", context: context);
    // Widget continueButton = ElevatedButton(
    //   child: const Text("Continue"),
    //   onPressed: () {},
    // );
    // // set up the AlertDialog
    // AlertDialog alert = AlertDialog(
    //   title: Text(title),
    //   content: Text(message),
    //   actions: [
    //     continueButton,
    //   ],
    // );
    // // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }


  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
      showPaymentSuccessDialog(context);
      if (totalExtendHours <= 0 && selectedHours == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select extension time')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final String url =
          'http://31.97.206.144:4072/api/users/extendbookings/${widget.userId}/${widget.bookingId}';

      Map<String, dynamic> payload;

      if (selectedHours != null) {
        // If hours are selected
        payload = {"hours": selectedHours,"amount": totalAmount, "transactionId" : response.paymentId.toString()};
      } else {
        // If custom date/time is selected
        String extendDate = '';
        String extendTime = '';

        if (customExtendDate != null) {
          extendDate = DateFormat('yyyy-MM-dd').format(customExtendDate!);
        } else {
          extendDate = DateFormat('yyyy-MM-dd').format(widget.deliveryDate);
        }

        if (customExtendTime != null) {
          final now = DateTime.now();
          final dateTime = DateTime(now.year, now.month, now.day,
              customExtendTime!.hour, customExtendTime!.minute);
          extendTime = DateFormat('hh:mm a').format(dateTime);
        } else {
          extendTime = DateFormat('hh:mm a').format(widget.deliveryDate);
        }

                print('pppppppppppppppppppppppppppppppppppppppp');


        print('pppppppppppp${totalAmount}');

        payload = {
          "extendDeliveryDate": extendDate,
          "extendDeliveryTime": extendTime,
          "amount": totalAmount,
          "transactionId" : response.paymentId.toString()
        };
      }

      final responseData = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      setState(() {
        isLoading = false;
      });

      print("ppppppppppppppprrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr${responseData.statusCode}");
            print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr${json.decode(responseData.body)}");


      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        // Success - show Lottie animation
        showSuccessAnimation();
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to extend booking: ${responseData.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


    void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }


  Future<void> extendBooking() async {
    try{
      Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_hNwWuDNHuEICmT', // test keys
      'amount': (totalAmount! * 100).toInt(),
      'name': 'Varahi Self Drive Cars.',
      'description': 'Subscription',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': mobile,
        'email': email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
    }catch(e){
      print("errrrrrrrrrrrrrrrrrrr$e");
    }
    
  }

  void showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Simple animated checkmark using Flutter's built-in animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    // Auto close after animation completes
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).pop(); // Close dialog
                      // Navigate to booking screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainNavigationScreen(initialIndex: 2,),
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Extended Successfully!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildHourButton(int hours) {
    bool isSelected = selectedHours == hours;
    return GestureDetector(
      onTap: () => selectHours(hours),
      child: Container(
        width: 72,
        height: 37,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF120698) : const Color(0xFF1600C8),
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "${hours}hr",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String getExtendDateText() {
    if (customExtendDate != null) {
      return DateFormat('dd/MM/yyyy').format(customExtendDate!);
    }
    return '--/--/----';
  }

  String getExtendTimeText() {
    if (customExtendTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day,
          customExtendTime!.hour, customExtendTime!.minute);
      return DateFormat('hh:mm a').format(dateTime);
    }
    return '00:00 AA';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      // backgroundColor: theme.scaffoldBackgroundColor,

      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      child: Text(
                        "Select Extend Date",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog/modal
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Hour selection buttons
                Row(
                  children: [
                    buildHourButton(1),
                    const SizedBox(width: 20),
                    buildHourButton(2),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    buildHourButton(3),
                    const SizedBox(width: 20),
                    buildHourButton(4),
                  ],
                ),
                const SizedBox(height: 20),

                // Current delivery date section
                const Text(
                  "Delivery date",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 320,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1600C8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formattedDate!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.calendar_month, size: 18),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 115,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formattedTime!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.timer_outlined, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Extend date section
                const Text(
                  "Extend date",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 320,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1600C8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: selectCustomDate,
                        child: Container(
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    getExtendDateText(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: customExtendDate == null
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                      decorationStyle:
                                          TextDecorationStyle.dotted,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(Icons.calendar_month, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: selectCustomTime,
                        child: Container(
                          width: 115,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getExtendTimeText(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const Icon(Icons.timer_outlined, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Amount calculation section
                Column(
                  children: [
                    // infoRow("Outstanding", widget.price.toDouble(), color: Colors.black),
                    // infoRow("Extend", extendAmount.toDouble(), color: Colors.black),
                    const Divider(height: 20, thickness: 1, color: Colors.grey),
                    infoRow("Total", totalAmount,
                        color: Colors.black),
                  ],
                ),
                const SizedBox(height: 20),

                // Extend button
                Center(
                  child: GestureDetector(
                    onTap: (isLoading || totalAmount == 0) ? null : extendBooking,
                    child: Container(
                      width: 244,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            isLoading ? Colors.grey : const Color(0xFF120698),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                "Extend",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget infoRow(String title, int amount, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: color),
          ),
          Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(color: color))
        ],
      ),
    );
  }
}