// // car_api_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:nupura_cars/models/MyCarModel/car_models.dart';


// class CarApiService {
//   // You can change this to use env depending on dev/prod, etc.
//   static const String _baseUrl = 'http://31.97.206.144:4072';

//   final http.Client _client;

//   CarApiService({http.Client? client}) : _client = client ?? http.Client();

//   Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
//     return Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
//   }

//   /// GET /api/admin/allbrands
//   Future<List<Brand>> fetchBrands() async {
//     final uri = _buildUri('/api/admin/allbrands');
//     final response = await _client.get(uri);

//     if (response.statusCode != 200) {
//       throw Exception('Failed to load brands: ${response.statusCode}');
//     }

//     final Map<String, dynamic> data = json.decode(response.body);
//     final List<dynamic> list = data['brands'] as List<dynamic>;

//     return list
//         .map((e) => Brand.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// GET /api/admin/allservicecarsbyfilter?brandName=TATA
//   Future<List<ServiceCar>> fetchServiceCarsByBrand(String brandName) async {
//     final uri = _buildUri(
//       '/api/admin/allservicecarsbyfilter',
//       {"brandName": brandName},
//     );
//     final response = await _client.get(uri);

//     if (response.statusCode != 200) {
//       throw Exception(
//           'Failed to load service cars: ${response.statusCode}');
//     }

//     final Map<String, dynamic> data = json.decode(response.body);
//     final List<dynamic> list = data['serviceCars'] as List<dynamic>;

//     return list
//         .map((e) => ServiceCar.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// GET /api/users/mycars/:userId
//   Future<List<UserCar>> fetchMyCars(String userId) async {
//     final uri = _buildUri('/api/users/mycars/$userId');
//     final response = await _client.get(uri);

//     if (response.statusCode != 200) {
//       throw Exception('Failed to load my cars: ${response.statusCode}');
//     }

//     final Map<String, dynamic> data = json.decode(response.body);

//     final bool isSuccessfull = data['isSuccessfull'] == true;
//     if (!isSuccessfull) {
//       throw Exception(data['message'] ?? 'Failed to load my cars');
//     }

//     final List<dynamic> list = data['myCars'] as List<dynamic>;

//     return list
//         .map((e) => UserCar.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// POST /api/users/createmycar/:userId
//   Future<UserCar> createMyCar(String userId, UserCarRequest payload) async {
//     final uri = _buildUri('/api/users/createmycar/$userId');
//     final response = await _client.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(payload.toJson()),
//     );

//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception('Failed to create car: ${response.statusCode}');
//     }

//     final Map<String, dynamic> data = json.decode(response.body);

//     final bool isSuccessfull = data['isSuccessfull'] == true;
//     if (!isSuccessfull) {
//       throw Exception(data['message'] ?? 'Failed to create car');
//     }

//     return UserCar.fromJson(data['userCar'] as Map<String, dynamic>);
//   }

//   /// PUT /api/users/editusercar/:userId/:userCarId
//   Future<UserCar> editUserCar(
//       String userId, String userCarId, UserCarRequest payload) async {
//     final uri = _buildUri('/api/users/editusercar/$userId/$userCarId');
//     final response = await _client.put(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(payload.toJson()),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update car: ${response.statusCode}');
//     }

//     final Map<String, dynamic> data = json.decode(response.body);

//     final bool isSuccessfull = data['isSuccessfull'] == true;
//     if (!isSuccessfull) {
//       throw Exception(data['message'] ?? 'Failed to update car');
//     }

//     return UserCar.fromJson(data['userCar'] as Map<String, dynamic>);
//   }

//   /// DELETE /api/users/deleteusercar/:userId/:userCarId
//   Future<void> deleteUserCar(String userId, String userCarId) async {
//     // Assuming same base URL; adjust if your backend really uses 0.0.0.0 only in dev.
//     final uri = _buildUri('/api/users/deleteusercar/$userId/$userCarId');
//     final response = await _client.delete(uri);

//     if (response.statusCode != 200 && response.statusCode != 204) {
//       throw Exception('Failed to delete car: ${response.statusCode}');
//     }

//     // If backend returns JSON with message/isSuccessfull, you can parse it here
//     if (response.body.isNotEmpty) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       final bool isSuccessfull = data['isSuccessfull'] == true;
//       if (!isSuccessfull) {
//         throw Exception(data['message'] ?? 'Failed to delete car');
//       }
//     }
//   }
// }




















// car_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/models/MyCarModel/car_models.dart';

class CarApiService {
  // You can change this to use env depending on dev/prod, etc.
  static const String _baseUrl = 'http://31.97.206.144:4072';

  final http.Client _client;

  CarApiService({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
  }

  /// GET /api/admin/allbrands
  Future<List<Brand>> fetchBrands() async {
    final uri = _buildUri('/api/admin/allbrands');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load brands: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> list = data['brands'] as List<dynamic>;

    return list
        .map((e) => Brand.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/admin/allservicecarsbyfilter?brandName=TATA
  Future<List<ServiceCar>> fetchServiceCarsByBrand(String brandName) async {
    final uri = _buildUri(
      '/api/admin/allservicecarsbyfilter',
      {"brandName": brandName},
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load service cars: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> list = data['serviceCars'] as List<dynamic>;

    return list
        .map((e) => ServiceCar.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/users/mycars/:userId
  Future<List<UserCar>> fetchMyCars(String userId) async {
    final uri = _buildUri('/api/users/mycars/$userId');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load my cars: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);

    final bool isSuccessfull = data['isSuccessfull'] == true;
    if (!isSuccessfull) {
      throw Exception(data['message'] ?? 'Failed to load my cars');
    }

    final List<dynamic> list = data['myCars'] as List<dynamic>;

    return list
        .map((e) => UserCar.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/users/createmycar/:userId
  Future<UserCar> createMyCar(String userId, UserCarRequest payload) async {
    final uri = _buildUri('/api/users/createmycar/$userId');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create car: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);

    final bool isSuccessfull = data['isSuccessfull'] == true;
    if (!isSuccessfull) {
      throw Exception(data['message'] ?? 'Failed to create car');
    }

    return UserCar.fromJson(data['userCar'] as Map<String, dynamic>);
  }

  /// PUT /api/users/editusercar/:userId/:userCarId
  Future<UserCar> editUserCar(
    String userId,
    String userCarId,
    UserCarRequest payload,
  ) async {
    final uri = _buildUri('/api/users/editusercar/$userId/$userCarId');
    final response = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);

    final bool isSuccessfull = data['isSuccessfull'] == true;
    if (!isSuccessfull) {
      throw Exception(data['message'] ?? 'Failed to update car');
    }

    return UserCar.fromJson(data['userCar'] as Map<String, dynamic>);
  }

  /// DELETE /api/users/deleteusercar/:userId/:userCarId
  Future<void> deleteUserCar(String userId, String userCarId) async {
    final uri = _buildUri('/api/users/deleteusercar/$userId/$userCarId');
    final response = await _client.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete car: ${response.statusCode}');
    }

    if (response.body.isNotEmpty) {
      final Map<String, dynamic> data = json.decode(response.body);
      final bool isSuccessfull = data['isSuccessfull'] == true;
      if (!isSuccessfull) {
        throw Exception(data['message'] ?? 'Failed to delete car');
      }
    }
  }

  // ================== 🔥 NEW APIs ==================

  /// POST /api/users/set-current-car
  /// Body: { "userId": "...", "carId": "..." }
  /// Response: { "message": "...", "isSuccessfull": true, "currentCar": "carId" }
  Future<String> setCurrentCar(String userId, String carId) async {
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$userId");
        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$carId");

    final uri = _buildUri('/api/users/set-current-car');
    final response = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'carId': carId,
      }),
    );

    print("Responae body; ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to set current car: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final bool isSuccessfull = data['isSuccessfull'] == true;

    if (!isSuccessfull) {
      throw Exception(data['message'] ?? 'Failed to set current car');
    }

    // This is just the carId string from response
    return data['currentCar'] as String;
  }

  /// GET /api/users/mycurrentcar/:userId
  /// Response:
  /// {
  ///   "message": "...",
  ///   "isSuccessfull": true,
  ///   "currentCar": { ... },
  ///   "plans": []
  /// }
  Future<UserCar?> fetchMyCurrentCar(String userId) async {
    final uri = _buildUri('/api/users/mycurrentcar/$userId');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch current car: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final bool isSuccessfull = data['isSuccessfull'] == true;

    if (!isSuccessfull) {
      throw Exception(data['message'] ?? 'Failed to fetch current car');
    }

    if (data['currentCar'] == null) {
      // user might not have a current car set yet
      return null;
    }

    return UserCar.fromJson(data['currentCar'] as Map<String, dynamic>);
  }
}
