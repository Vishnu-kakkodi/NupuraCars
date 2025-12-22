class ApiConstants {
  static const String baseUrl = 'http://31.97.206.144:4072/api';

  // Auth Endpoints
  static const String loginEndpoint = '/users/loginuser';
  static const String registerEndpoint = '/users/register';

  // Booking Endpoints
  static const String fetchBookings = '/users/bookings';
  static const String fetchRecentBooking = '/users/recent-booking';
  static const String bookingSummary = '/users/booking-summary';
  static const String createBooking = '/users/create-booking';

  // Car endpoints
  static const String getAllCars = '/car/allcars';
  static const String getCarById = '/car/getcar';

  // User endpoints
  static const String getUser = '/users/get-user';
  static const String editProfile = '/users/edit-profile';

  // Wallet endpoints
  static const String getWallet = '/users/getwallet';
  static const String addAmount = '/users/addamount';

  // Document endpoints
  static String getDocuments(String userId) => '$baseUrl/users/documents/$userId';
static String uploadDocuments(String userId, bool isEdit) =>
    '$baseUrl/users/${isEdit ? "updatedocuments" : "uploaddocuments"}/$userId';

  //Location endpoints
  static String addUserLocation() => '$baseUrl/users/add-location';





  // Common headers
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}