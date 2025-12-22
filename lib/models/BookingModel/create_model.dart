




// class CreateBookingModel {
//   final String message;
//   final String payUrl;
//   final BookingCreate booking;
//   final CarCreate car;
//   final UserData user;

//   CreateBookingModel({
//     required this.message,
//     required this.payUrl,
//     required this.booking,
//     required this.car,
//     required this.user,
//   });

//   factory CreateBookingModel.fromJson(Map<String, dynamic> json) {
//     return CreateBookingModel(
//       message: json['message'] ?? '',
//       payUrl: json['payUrl'] ?? '',
//       booking: BookingCreate.fromJson(json['booking']),
//       car: CarCreate.fromJson(json['car']),
//       user: UserData.fromJson(json['user']),
//     );
//   }
// }

// class BookingCreate {
//   final String id;
//   final String userId;
//   final String carId;
//   final String rentalStartDate;
//   final String rentalEndDate;
//   final String from;
//   final String to;
//   final String deposit;
//   final int totalPrice;
//   final int amount;
//   final int otp;
//   final String paymentStatus;
//   final String deliveryDate;
//   final String deliveryTime;
//   final String status;

//   BookingCreate({
//     required this.id,
//     required this.userId,
//     required this.carId,
//     required this.rentalStartDate,
//     required this.rentalEndDate,
//     required this.from,
//     required this.to,
//     required this.deposit,
//     required this.totalPrice,
//     required this.amount,
//     required this.otp,
//     required this.paymentStatus,
//     required this.deliveryDate,
//     required this.deliveryTime,
//     required this.status,
//   });

//   factory BookingCreate.fromJson(Map<String, dynamic> json) {
//     return BookingCreate(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       carId: json['carId'] ?? '',
//       rentalStartDate: json['rentalStartDate'] ?? '',
//       rentalEndDate: json['rentalEndDate'] ?? '',
//       from: json['from'] ?? '',
//       to: json['to'] ?? '',
//       deposit: json['deposit'] ?? '',
//       totalPrice: json['totalPrice'] ?? 0,
//       amount: json['amount'] ?? 0,
//       otp: json['otp'] ?? 0,
//       paymentStatus: json['paymentStatus'] ?? '',
//       deliveryDate: json['deliveryDate'] ?? '',
//       deliveryTime: json['deliveryTime'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }

// class CarCreate {
//   final String id;
//   final String carName;
//   final String model;
//   final int pricePerHour;
//   final String location;
//   final List<String> carImage;
//   final String runningStatus;
//   final BookingDetails bookingDetails;

//   CarCreate({
//     required this.id,
//     required this.carName,
//     required this.model,
//     required this.pricePerHour,
//     required this.location,
//     required this.carImage,
//     required this.runningStatus,
//     required this.bookingDetails,
//   });

//   factory CarCreate.fromJson(Map<String, dynamic> json) {
//     return CarCreate(
//       id: json['_id'] ?? '',
//       carName: json['carName'] ?? '',
//       model: json['model'] ?? '',
//       pricePerHour: json['pricePerHour'] ?? 0,
//       location: json['location'] ?? '',
//       carImage: List<String>.from(json['carImage'] ?? []),
//       runningStatus: json['runningStatus'] ?? '',
//       bookingDetails: BookingDetails.fromJson(json['bookingDetails']),
//     );
//   }
// }

// class BookingDetails {
//   final String rentalStartDate;
//   final String rentalEndDate;

//   BookingDetails({
//     required this.rentalStartDate,
//     required this.rentalEndDate,
//   });

//   factory BookingDetails.fromJson(Map<String, dynamic> json) {
//     return BookingDetails(
//       rentalStartDate: json['rentalStartDate'] ?? '',
//       rentalEndDate: json['rentalEndDate'] ?? '',
//     );
//   }
// }

// class UserData {
//   final String id;
//   final String name;
//   final String email;
//   final String mobile;
//   final List<String> myBookings;

//   UserData({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.mobile,
//     required this.myBookings,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       mobile: json['mobile'] ?? '',
//       myBookings: List<String>.from(json['myBookings'] ?? []),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'email': email,
//       'mobile': mobile,
//       'myBookings': myBookings,
//     };
//   }
// }








class CreateBookingModel {
  final String message;
  final BookingCreate booking;

  CreateBookingModel({
    required this.message,
    required this.booking,
  });

  factory CreateBookingModel.fromJson(Map<String, dynamic> json) {
    return CreateBookingModel(
      message: json['message'] ?? '',
      booking: BookingCreate.fromJson(json['booking']),
    );
  }
}



class BookingCreate {
  final String id;
  final String userId;
  final String carId;
  final String rentalStartDate;
  final String rentalEndDate;
  final String from;
  final String to;
  final String deliveryDate;
  final String deliveryTime;
  final int totalPrice;
  final String status;
  final String deposit;
  final String paymentStatus;
  final String? depositPDF;
  final String? finalBookingPDF;
  final int otp;
  final int amount;
  final String? returnOTP;
  final String transactionId;
  final bool advancePaidStatus;
  final List<dynamic> depositeProof;
  final List<dynamic> carImagesBeforePickup;
  final List<dynamic> carReturnImages;
  final List<dynamic> returnDetails;
  final String createdAt;
  final String updatedAt;
  final int v;

  BookingCreate({
    required this.id,
    required this.userId,
    required this.carId,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.from,
    required this.to,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.totalPrice,
    required this.status,
    required this.deposit,
    required this.paymentStatus,
    this.depositPDF,
    this.finalBookingPDF,
    required this.otp,
    required this.amount,
    this.returnOTP,
    required this.transactionId,
    required this.advancePaidStatus,
    required this.depositeProof,
    required this.carImagesBeforePickup,
    required this.carReturnImages,
    required this.returnDetails,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory BookingCreate.fromJson(Map<String, dynamic> json) {
    return BookingCreate(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      carId: json['carId'] ?? '',
      rentalStartDate: json['rentalStartDate'] ?? '',
      rentalEndDate: json['rentalEndDate'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      deliveryDate: json['deliveryDate'] ?? '',
      deliveryTime: json['deliveryTime'] ?? '',
      totalPrice: json['totalPrice'] ?? 0,
      status: json['status'] ?? '',
      deposit: json['deposit'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      depositPDF: json['depositPDF'],
      finalBookingPDF: json['finalBookingPDF'],
      otp: json['otp'] ?? 0,
      amount: json['amount'] ?? 0,
      returnOTP: json['returnOTP'],
      transactionId: json['transactionId'] ?? '',
      advancePaidStatus: json['advancePaidStatus'] ?? false,
      depositeProof: json['depositeProof'] ?? [],
      carImagesBeforePickup: json['carImagesBeforePickup'] ?? [],
      carReturnImages: json['carReturnImages'] ?? [],
      returnDetails: json['returnDetails'] ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
