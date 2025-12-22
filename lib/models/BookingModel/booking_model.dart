


// import 'package:drive_car/models/CarModel/car_model.dart';

// class Branch {
//   final String name;
//   final List<double> coordinates;

//   Branch({required this.name, required this.coordinates});

//   factory Branch.fromJson(Map<String, dynamic> json) {
//     return Branch(
//       name: json['name'] ?? 'Unknown Branch',
//       coordinates: List<double>.from(json['location']['coordinates'] ?? [0.0, 0.0]),
//     );
//   }
// }

// class BookingExtension {
//   final int? hours;
//   final int amount;
//   final String transactionId;
//   final String id;
//   final DateTime extendedAt;
//   final String? extendDeliveryDate;
//   final String? extendDeliveryTime;

//   BookingExtension({
//     this.hours,
//     required this.amount,
//     required this.transactionId,
//     required this.id,
//     required this.extendedAt,
//     this.extendDeliveryDate,
//     this.extendDeliveryTime,
//   });

//   factory BookingExtension.fromJson(Map<String, dynamic> json) {
//     return BookingExtension(
//       hours: json['hours'],
//       amount: json['amount'] ?? 0,
//       transactionId: json['transactionId'] ?? '',
//       id: json['_id'] ?? '',
//       extendedAt: DateTime.parse(json['extendedAt'] ?? DateTime.now().toIso8601String()),
//       extendDeliveryDate: json['extendDeliveryDate'],
//       extendDeliveryTime: json['extendDeliveryTime'],
//     );
//   }
// }

// class Booking {
//   final String id;
//   final String userId;
//   final Car car;
//   final DateTime rentalStartDate;
//   final DateTime rentalEndDate;
//   final DateTime deliveryDate;
//   final String deliveryTime;
//   final int totalPrice;
//   final String status;
//   final String paymentStatus;
//   final String from;
//   final String to;
//   final String deposit;
//   final String? depositPDF;
//   final String? finalBookingPDF;
//   final int otp;
//   final int amount;
//   final String? returnOTP;
//   final bool advancePaidStatus;
//   final List<DepositProof> depositeProof;
//   final List<CarImage> carImagesBeforePickup;
//   final List<CarImage> carReturnImages;
//   final List<ReturnDetail> returnDetails;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final Branch branch;
//   final BookingLocation? pickupLocation;
//   final BookingLocation? dropLocation;
//   final List<BookingExtension> extensions;

//   Booking({
//     required this.id,
//     required this.userId,
//     required this.car,
//     required this.rentalStartDate,
//     required this.rentalEndDate,
//     required this.deliveryDate,
//     required this.deliveryTime,
//     required this.totalPrice,
//     required this.status,
//     required this.paymentStatus,
//     required this.from,
//     required this.to,
//     required this.deposit,
//     this.depositPDF,
//     this.finalBookingPDF,
//     required this.otp,
//     required this.amount,
//     this.returnOTP,
//     required this.advancePaidStatus,
//     required this.depositeProof,
//     required this.carImagesBeforePickup,
//     required this.carReturnImages,
//     required this.returnDetails,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.branch,
//     this.pickupLocation,
//     this.dropLocation,
//     required this.extensions,
//   });

//   bool get isCompleted => status.toLowerCase() == 'completed';
//   bool get isCancelled => status.toLowerCase() == 'cancelled';
//   bool get isPending => status.toLowerCase() == 'confirmed';
//   bool get isActive => status.toLowerCase() == 'active';

//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['_id'] ?? '',
//       userId: json['userId'] is Map ? json['userId']['_id'] : json['userId'] ?? '',
//       car: Car.fromJson(json['carId'] ?? {}),
//       rentalStartDate: DateTime.parse(json['rentalStartDate']),
//       rentalEndDate: DateTime.parse(json['rentalEndDate']),
//       deliveryDate: DateTime.parse(json['deliveryDate']),
//       deliveryTime: json['deliveryTime'] ?? '',
//       totalPrice: json['totalPrice'] ?? 0,
//       status: json['status'] ?? 'confirmed',
//       paymentStatus: json['paymentStatus'] ?? 'pending',
//       from: json['from'] ?? '',
//       to: json['to'] ?? '',
//       deposit: json['deposit'] ?? '',
//       depositPDF: json['depositPDF'],
//       finalBookingPDF: json['finalBookingPDF'],
//       otp: json['otp'] ?? 0,
//       amount: json['amount'] ?? 0,
//       returnOTP: json['returnOTP'] ?? "",
//       advancePaidStatus: json['advancePaidStatus'] ?? false,
//       depositeProof: (json['depositeProof'] as List<dynamic>?)?.map((e) => DepositProof.fromJson(e)).toList() ?? [],
//       carImagesBeforePickup: (json['carImagesBeforePickup'] as List<dynamic>?)?.map((e) => CarImage.fromJson(e)).toList() ?? [],
//       carReturnImages: (json['carReturnImages'] as List<dynamic>?)?.map((e) => CarImage.fromJson(e)).toList() ?? [],
//       returnDetails: (json['returnDetails'] as List<dynamic>?)?.map((e) => ReturnDetail.fromJson(e)).toList() ?? [],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       branch: Branch.fromJson(json['carId']?['branch'] ?? json['branch'] ?? {}),
//       pickupLocation: json['pickupLocation'] != null ? BookingLocation.fromJson(json['pickupLocation']) : null,
//       dropLocation: json['dropLocation'] != null ? BookingLocation.fromJson(json['dropLocation']) : null,
//       extensions: (json['extensions'] as List<dynamic>?)?.map((e) => BookingExtension.fromJson(e)).toList() ?? [],
//     );
//   }

//   @override
//   String toString() {
//     return '''
// Booking(
//   id: $id,
//   userId: $userId,
//   car: ${car.toString()},
//   rentalStartDate: $rentalStartDate,
//   rentalEndDate: $rentalEndDate,
//   from: $from,
//   to: $to,
//   deliveryDate: $deliveryDate,
//   deliveryTime: $deliveryTime,
//   totalPrice: $totalPrice,
//   status: $status,
//   paymentStatus: $paymentStatus,
//   deposit: $deposit,
//   otp: $otp,
//   amount: $amount,
//   returnOTP: $returnOTP,
//   advancePaidStatus: $advancePaidStatus,
//   depositPDF: $depositPDF,
//   finalBookingPDF: $finalBookingPDF,
//   carImagesBeforePickup: $carImagesBeforePickup,
//   carReturnImages: $carReturnImages,
//   returnDetails: $returnDetails,
//   pickupLocation: $pickupLocation,
//   dropLocation: $dropLocation,
//   branch: $branch,
//   createdAt: $createdAt,
//   updatedAt: $updatedAt,
//   extensions: $extensions,
// )
// ''';
//   }
// }

// class BookingLocation {
//   final String address;
//   final List<double> coordinates;

//   BookingLocation({required this.address, required this.coordinates});

//   factory BookingLocation.fromJson(Map<String, dynamic> json) {
//     return BookingLocation(
//       address: json['address'] ?? '',
//       coordinates: List<double>.from(json['coordinates']?.map((x) => x.toDouble()) ?? [0.0, 0.0]),
//     );
//   }
// }

// class DepositProof {
//   final String id;
//   final String url;
//   final String label;

//   DepositProof({required this.id, required this.url, required this.label});

//   factory DepositProof.fromJson(Map<String, dynamic> json) {
//     return DepositProof(
//       id: json['_id'] ?? '',
//       url: json['url'] ?? '',
//       label: json['label'] ?? '',
//     );
//   }
// }

// class CarImage {
//   final String id;
//   final String url;
//   final DateTime uploadedAt;

//   CarImage({required this.id, required this.url, required this.uploadedAt});

//   factory CarImage.fromJson(Map<String, dynamic> json) {
//     return CarImage(
//       id: json['_id'] ?? '',
//       url: json['url'] ?? '',
//       uploadedAt: DateTime.parse(json['uploadedAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }
// }

// class ReturnDetail {
//   final String id;
//   final String name;
//   final String email;
//   final String mobile;
//   final String alternativeMobile;
//   final String returnTime;
//   final DateTime returnDate;
//   final int delayTime;
//   final int delayDay;
//   final DateTime createdAt;

//   ReturnDetail({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.mobile,
//     required this.alternativeMobile,
//     required this.returnTime,
//     required this.returnDate,
//     required this.delayTime,
//     required this.delayDay,
//     required this.createdAt,
//   });

//   factory ReturnDetail.fromJson(Map<String, dynamic> json) {
//     return ReturnDetail(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       mobile: json['mobile'] ?? '',
//       alternativeMobile: json['alternativeMobile'] ?? '',
//       returnTime: json['returnTime'] ?? '',
//       returnDate: DateTime.parse(json['returnDate'] ?? DateTime.now().toIso8601String()),
//       delayTime: json['delayTime'] ?? 0,
//       delayDay: json['delayDay'] ?? 0,
//       createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }
// }











import 'package:nupura_cars/models/CarModel/car_model.dart';

class Branch {
  final String name;
  final List<double> coordinates;

  Branch({required this.name, required this.coordinates});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      name: json['name'] ?? 'Unknown Branch',
      coordinates: List<double>.from(
        (json['location']?['coordinates'] ?? [0.0, 0.0]).map((x) => (x as num).toDouble()),
      ),
    );
  }
}

class BookingExtension {
  final int? hours;
  final int amount;
  final String transactionId;
  final String id;
  final DateTime extendedAt;
  final String? extendDeliveryDate;
  final String? extendDeliveryTime;

  BookingExtension({
    this.hours,
    required this.amount,
    required this.transactionId,
    required this.id,
    required this.extendedAt,
    this.extendDeliveryDate,
    this.extendDeliveryTime,
  });

  factory BookingExtension.fromJson(Map<String, dynamic> json) {
    return BookingExtension(
      hours: json['hours'],
      amount: json['amount'] ?? 0,
      transactionId: json['transactionId'] ?? '',
      id: json['_id'] ?? '',
      extendedAt: DateTime.parse(json['extendedAt'] ?? DateTime.now().toIso8601String()),
      extendDeliveryDate: json['extendDeliveryDate'],
      extendDeliveryTime: json['extendDeliveryTime'],
    );
  }
}

class Booking {
  final String id;
  final String userId;
  final Car car;
  final DateTime rentalStartDate;
  final DateTime rentalEndDate;
  final DateTime deliveryDate;
  final String deliveryTime;
  final int totalPrice;
  final String status;
  final String paymentStatus;
  final String from;
  final String to;
  final String deposit;
  final String? depositPDF;
  final String? finalBookingPDF;
  final int otp;
  final int amount;
  final String? returnOTP;
  final bool advancePaidStatus;
  final List<DepositProof> depositeProof;
  final List<CarImage> carImagesBeforePickup;
  final List<CarImage> carReturnImages;
  final List<ReturnDetail> returnDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Branch branch;
  final BookingLocation? pickupLocation;
  final BookingLocation? dropLocation;
  final List<BookingExtension> extensions;

  // NEW optional fields from API response
  final bool? isCarWash;
  final int? carWashAmount;
  final int? totalRemainingPayment;
  final bool? isAnyDepositeProof;
  final int? advancePaymentAmount;
  final bool? isAdvancePayment;
  final bool? completePayment;
  final int? advancePayment;
  final int? remainingAmount;
  final int? depositAmount;
  final int? totalPaidNow;

  Booking({
    required this.id,
    required this.userId,
    required this.car,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.from,
    required this.to,
    required this.deposit,
    this.depositPDF,
    this.finalBookingPDF,
    required this.otp,
    required this.amount,
    this.returnOTP,
    required this.advancePaidStatus,
    required this.depositeProof,
    required this.carImagesBeforePickup,
    required this.carReturnImages,
    required this.returnDetails,
    required this.createdAt,
    required this.updatedAt,
    required this.branch,
    this.pickupLocation,
    this.dropLocation,
    required this.extensions,
    // new fields
    this.isCarWash,
    this.carWashAmount,
    this.totalRemainingPayment,
    this.isAnyDepositeProof,
    this.advancePaymentAmount,
    this.isAdvancePayment,
    this.completePayment,
    this.advancePayment,
    this.remainingAmount,
    this.depositAmount,
    this.totalPaidNow,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isPending => status.toLowerCase() == 'confirmed';
  bool get isActive => status.toLowerCase() == 'active';

  factory Booking.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? s) {
      if (s == null || s.isEmpty) return DateTime.now();
      return DateTime.parse(s);
    }

    return Booking(
      id: json['_id'] ?? '',
      userId: json['userId'] is Map ? (json['userId']['_id'] ?? '') : (json['userId'] ?? ''),
      car: Car.fromJson(json['carId'] ?? {}),
      rentalStartDate: parseDate(json['rentalStartDate']),
      rentalEndDate: parseDate(json['rentalEndDate']),
      deliveryDate: parseDate(json['deliveryDate']),
      deliveryTime: json['deliveryTime'] ?? '',
      totalPrice: (json['totalPrice'] is num) ? (json['totalPrice'] as num).toInt() : (json['totalPrice'] ?? 0),
      status: json['status'] ?? 'confirmed',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      deposit: json['deposit'] ?? '',
      depositPDF: json['depositPDF'],
      finalBookingPDF: json['finalBookingPDF'],
      otp: (json['otp'] is num) ? (json['otp'] as num).toInt() : (json['otp'] ?? 0),
      amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : (json['amount'] ?? 0),
      returnOTP: json['returnOTP'] ?? '',
      advancePaidStatus: json['advancePaidStatus'] ?? false,
      depositeProof: (json['depositeProof'] as List<dynamic>?)?.map((e) => DepositProof.fromJson(e)).toList() ?? [],
      carImagesBeforePickup: (json['carImagesBeforePickup'] as List<dynamic>?)?.map((e) => CarImage.fromJson(e)).toList() ?? [],
      carReturnImages: (json['carReturnImages'] as List<dynamic>?)?.map((e) => CarImage.fromJson(e)).toList() ?? [],
      returnDetails: (json['returnDetails'] as List<dynamic>?)?.map((e) => ReturnDetail.fromJson(e)).toList() ?? [],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      branch: Branch.fromJson(json['carId']?['branch'] ?? json['branch'] ?? {}),
      pickupLocation: json['pickupLocation'] != null ? BookingLocation.fromJson(json['pickupLocation']) : null,
      dropLocation: json['dropLocation'] != null ? BookingLocation.fromJson(json['dropLocation']) : null,
      extensions: (json['extensions'] as List<dynamic>?)?.map((e) => BookingExtension.fromJson(e)).toList() ?? [],

      // NEW optional fields
      isCarWash: json['isCarWash'] is bool ? json['isCarWash'] as bool : (json['isCarWash'] == 'true'),
      carWashAmount: (json['carWashAmount'] is num) ? (json['carWashAmount'] as num).toInt() : (json['carWashAmount'] ?? null),
      totalRemainingPayment: (json['totalRemainingPayment'] is num) ? (json['totalRemainingPayment'] as num).toInt() : (json['totalRemainingPayment'] ?? null),
      isAnyDepositeProof: json['isAnyDepositeProof'] ?? json['isAnyDepositeProof'] == true,
      advancePaymentAmount: (json['advancePaymentAmount'] is num) ? (json['advancePaymentAmount'] as num).toInt() : (json['advancePaymentAmount'] ?? null),
      isAdvancePayment: json['isAdvancePayment'] ?? (json['isAdvancePayment'] == true),
      completePayment: json['completePayment'] ?? (json['completePayment'] == true),
      advancePayment: (json['advancePayment'] is num) ? (json['advancePayment'] as num).toInt() : (json['advancePayment'] ?? null),
      remainingAmount: (json['remainingAmount'] is num) ? (json['remainingAmount'] as num).toInt() : (json['remainingAmount'] ?? null),
      depositAmount: (json['depositAmount'] is num) ? (json['depositAmount'] as num).toInt() : (json['depositAmount'] ?? null),
      totalPaidNow: (json['totalPaidNow'] is num) ? (json['totalPaidNow'] as num).toInt() : (json['totalPaidNow'] ?? null),
    );
  }

  @override
  String toString() {
    return '''
Booking(
  id: $id,
  userId: $userId,
  car: ${car.toString()},
  rentalStartDate: $rentalStartDate,
  rentalEndDate: $rentalEndDate,
  deliveryDate: $deliveryDate,
  deliveryTime: $deliveryTime,
  totalPrice: $totalPrice,
  status: $status,
  paymentStatus: $paymentStatus,
  from: $from,
  to: $to,
  deposit: $deposit,
  depositPDF: $depositPDF,
  finalBookingPDF: $finalBookingPDF,
  otp: $otp,
  amount: $amount,
  returnOTP: $returnOTP,
  advancePaidStatus: $advancePaidStatus,
  depositeProof: $depositeProof,
  carImagesBeforePickup: $carImagesBeforePickup,
  carReturnImages: $carReturnImages,
  returnDetails: $returnDetails,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
  branch: $branch,
  pickupLocation: $pickupLocation,
  dropLocation: $dropLocation,
  extensions: $extensions,
  // New fields:
  isCarWash: $isCarWash,
  carWashAmount: $carWashAmount,
  totalRemainingPayment: $totalRemainingPayment,
  isAnyDepositeProof: $isAnyDepositeProof,
  advancePaymentAmount: $advancePaymentAmount,
  isAdvancePayment: $isAdvancePayment,
  completePayment: $completePayment,
  advancePayment: $advancePayment,
  remainingAmount: $remainingAmount,
  depositAmount: $depositAmount,
  totalPaidNow: $totalPaidNow,
)
''';
  }
}

class BookingLocation {
  final String address;
  final List<double> coordinates;

  BookingLocation({required this.address, required this.coordinates});

  factory BookingLocation.fromJson(Map<String, dynamic> json) {
    return BookingLocation(
      address: json['address'] ?? '',
      coordinates: List<double>.from(
        (json['coordinates'] ?? [0.0, 0.0]).map((x) => (x as num).toDouble()),
      ),
    );
  }
}

class DepositProof {
  final String id;
  final String url;
  final String label;

  DepositProof({required this.id, required this.url, required this.label});

  factory DepositProof.fromJson(Map<String, dynamic> json) {
    return DepositProof(
      id: json['_id'] ?? '',
      url: json['url'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

class CarImage {
  final String id;
  final String url;
  final DateTime uploadedAt;

  CarImage({required this.id, required this.url, required this.uploadedAt});

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      id: json['_id'] ?? '',
      url: json['url'] ?? '',
      uploadedAt: DateTime.parse(json['uploadedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ReturnDetail {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String alternativeMobile;
  final String returnTime;
  final DateTime returnDate;
  final int delayTime;
  final int delayDay;
  final DateTime createdAt;

  ReturnDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.alternativeMobile,
    required this.returnTime,
    required this.returnDate,
    required this.delayTime,
    required this.delayDay,
    required this.createdAt,
  });

  factory ReturnDetail.fromJson(Map<String, dynamic> json) {
    return ReturnDetail(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      alternativeMobile: json['alternativeMobile'] ?? '',
      returnTime: json['returnTime'] ?? '',
      returnDate: DateTime.parse(json['returnDate'] ?? DateTime.now().toIso8601String()),
      delayTime: json['delayTime'] ?? 0,
      delayDay: json['delayDay'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
