
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationFetchService {
//   static Future<String?> getCurrentAddress() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return 'Location services are disabled.';
//     }

//     // Check location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return 'Location permission denied.';
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return 'Location permissions are permanently denied.';
//     }

//     try {
//       // Get current position with timeout
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 30),
//       );

//       // Reverse geocode to get address
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude, 
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final place = placemarks[0];
        
//         // Build address string with null checks
//         List<String> addressParts = [];
        
//         if (place.street != null && place.street!.isNotEmpty) {
//           addressParts.add(place.street!);
//         }
//         if (place.locality != null && place.locality!.isNotEmpty) {
//           addressParts.add(place.locality!);
//         }
//         if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
//           addressParts.add(place.administrativeArea!);
//         }
//         if (place.country != null && place.country!.isNotEmpty) {
//           addressParts.add(place.country!);
//         }
        
//         return addressParts.isNotEmpty ? addressParts.join(', ') : 'Address not found';
//       }

//       return 'Address not found';
//     } catch (e) {
//       print('Error getting location: $e');
//       return 'Failed to get location: ${e.toString()}';
//     }
//   }

//   static Future<List<double>?> getCurrentCoordinates() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       return null;
//     }

//     // Check location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permission denied.');
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       print('Location permissions are permanently denied.');
//       return null;
//     }

//     try {
//                   print("Location Cordinateseeeeeeeeeeeeeeeee");

//       // Get current position with timeout
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10),
//       );

//       print("Location Cordinates: ${position.latitude}");
//             print("Location Cordinates: ${position.longitude}");


//       // Return as [latitude, longitude] for consistency with manual selection
//       return [position.latitude, position.longitude];
//     } catch (e) {
//             print("Location Cordinateseeeeeeeeeeeeeeeee");
//       print('Error getting coordinates: $e');
//       return null;
//     }
//   }

//   // Helper method to check if location services are available
//   static Future<bool> isLocationAvailable() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return false;

//       LocationPermission permission = await Geolocator.checkPermission();
//       return permission != LocationPermission.denied && 
//              permission != LocationPermission.deniedForever;
//     } catch (e) {
//       return false;
//     }
//   }
// }















import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationFetchService {
  /// Get the current address as a string
  static Future<String?> getCurrentAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permission denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    try {
      // ✅ Use LocationSettings instead of deprecated fields
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best, // replaces desiredAccuracy
          timeLimit: Duration(seconds: 30), // replaces timeLimit
        ),
      );

      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        List<String> addressParts = [];

        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        return addressParts.isNotEmpty
            ? addressParts.join(', ')
            : 'Address not found';
      }

      return 'Address not found';
    } catch (e) {
      print('Error getting location: $e');

      // ✅ fallback: try last known location
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          lastPosition.latitude,
          lastPosition.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks[0];
          return "${place.locality}, ${place.country}";
        }
      }

      return 'Failed to get location: ${e.toString()}';
    }
  }

  /// Get the current coordinates as [latitude, longitude]
  static Future<List<double>?> getCurrentCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    try {
      print("Fetching current coordinates...");

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 15),
        ),
      );

      print("Location Coordinates: ${position.latitude}, ${position.longitude}");
      return [position.latitude, position.longitude];
    } catch (e) {
      print('Error getting coordinates: $e');

      // ✅ fallback: use last known position
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        print("Using last known coordinates.");
        return [lastPosition.latitude, lastPosition.longitude];
      }

      return null;
    }
  }

  /// Helper method to check if location services are available
  static Future<bool> isLocationAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      return permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }
}
