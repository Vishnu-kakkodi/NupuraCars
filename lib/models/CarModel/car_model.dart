


class ExtendedPrice {
  final int perHour;
  final int perDay;

  ExtendedPrice({
    required this.perHour,
    required this.perDay,
  });

  factory ExtendedPrice.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse int
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? defaultValue;
      }
      if (value is double) return value.toInt();
      return defaultValue;
    }

    return ExtendedPrice(
      perHour: parseInt(json['perHour'], defaultValue: 0),
      perDay: parseInt(json['perDay'], defaultValue: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perHour': perHour,
      'perDay': perDay,
    };
  }
}

class Branch {
  final String name;
  final List<double> coordinates; // [longitude, latitude]

  Branch({required this.name, required this.coordinates});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      name: json['name'] ?? 'Unknown Branch',
      coordinates: List<double>.from(json['location']['coordinates'] ?? [0.0, 0.0]),
    );
  }
}


class Car {
  final String id;
  final String name;
  final String model;
  final int year;
  final int pricePerHour;
  final int pricePerDay;
  final String description;
  final bool availabilityStatus;
  final List<String> image;
  final List<String> carDocs;
  final String location;
  final String carType;
  final String fuel;
  final int seats;
  final String type;
  final ExtendedPrice extendedPrice; // New field added
  final Branch branch;


  Car({
    required this.id,
    required this.name,
    required this.model,
    required this.year,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.description,
    required this.availabilityStatus,
    required this.image,
    required this.carDocs,
    required this.location,
    required this.carType,
    required this.fuel,
    required this.seats,
    required this.type,
    required this.extendedPrice, // New field added
    required this.branch,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    try {
      // Helper function to safely parse list
      List<String> parseImageList(dynamic imageData) {
        if (imageData == null) return [];
        if (imageData is List) {
          return imageData.map((item) => item?.toString() ?? '').where((item) => item.isNotEmpty).toList();
        }
        if (imageData is String) {
          return [imageData];
        }
        return [];
      }

      // Helper function to safely parse int
      int parseInt(dynamic value, {int defaultValue = 0}) {
        if (value == null) return defaultValue;
        if (value is int) return value;
        if (value is String) {
          return int.tryParse(value) ?? defaultValue;
        }
        if (value is double) return value.toInt();
        return defaultValue;
      }

      // Helper function to safely parse string
      String parseString(dynamic value, {String defaultValue = ''}) {
        if (value == null) return defaultValue;
        return value.toString();
      }

      // Helper function to safely parse bool
      bool parseBool(dynamic value, {bool defaultValue = false}) {
        if (value == null) return defaultValue;
        if (value is bool) return value;
        if (value is String) {
          return value.toLowerCase() == 'true' || value == '1';
        }
        if (value is int) return value == 1;
        return defaultValue;
      }

      // Helper function to parse ExtendedPrice
      ExtendedPrice parseExtendedPrice(dynamic extendedPriceData) {
        if (extendedPriceData == null || extendedPriceData is! Map<String, dynamic>) {
          // Return default values if extendedPrice is missing or invalid
          return ExtendedPrice(perHour: 0, perDay: 0);
        }
        return ExtendedPrice.fromJson(extendedPriceData);
      }

      
  Branch parseBranch(dynamic branchData) {
  if (branchData == null || branchData is! Map<String, dynamic>) {
    return Branch(name: 'Unknown Branch', coordinates: [0.0, 0.0]);
  }
  return Branch.fromJson(branchData);
}

      print('🔧 Parsing car JSON: ${json['carName'] ?? 'Unknown'}');
      
      final car = Car(
        id: parseString(json['_id'], defaultValue: ''),
        name: parseString(json['carName'], defaultValue: 'Unknown Car'),
        model: parseString(json['model'], defaultValue: 'Unknown Model'),
        year: parseInt(json['year'], defaultValue: 2020),
        pricePerHour: parseInt(json['pricePerHour'], defaultValue: 0),
        pricePerDay: parseInt(json['pricePerDay'], defaultValue: 0),
        description: parseString(json['description'], defaultValue: ''),
        availabilityStatus: parseBool(json['availabilityStatus'], defaultValue: true),
        image: parseImageList(json['carImage']),
        carDocs: parseImageList(json['carDocs']),
        location: parseString(json['location'], defaultValue: 'Unknown Location'),
        carType: parseString(json['carType'], defaultValue: 'Unknown Type'),
        fuel: parseString(json['fuel'], defaultValue: 'Unknown Fuel'),
        seats: parseInt(json['seats'], defaultValue: 4),
        type: parseString(json['type'], defaultValue: 'Unknown'),
        extendedPrice: parseExtendedPrice(json['extendedPrice']), // New field parsing
        branch: parseBranch(json['branch']),
      );

      // Validation logging
      print('✅ Successfully parsed car: ${car.name}');
      print('   - Images: ${car.image.length}');
      print('   - Price: ₹${car.pricePerHour}/hr');
      print('   - Extended Price: ₹${car.extendedPrice.perHour}/hr, ₹${car.extendedPrice.perDay}/day');
      print('   - Location: ${car.location}');
      
      return car;
      
    } catch (e) {
      print('❌ Error parsing car JSON: $e');
      print('Raw JSON: $json');
      
      // Return a default car object to prevent crashes
      return Car(
        id: '',
        name: 'Error Loading Car',
        model: 'Unknown',
        year: 2020,
        pricePerHour: 0,
        pricePerDay: 0,
        description: 'Failed to load car data',
        availabilityStatus: false,
        image: [],
        carDocs: [],
        location: 'Unknown',
        carType: 'Unknown',
        fuel: 'Unknown',
        seats: 4,
        type: 'Unknown',
        extendedPrice: ExtendedPrice(perHour: 0, perDay: 0), // Default extended price
        branch: Branch(name: 'Unknown', coordinates: [0.0, 0.0]),
      );
    }
  }



  // Helper method to check if car has valid data
  bool get isValid {
    return id.isNotEmpty && name.isNotEmpty && name != 'Error Loading Car';
  }

  // Helper method to get safe first image
  String get firstImageUrl {
    return image.isNotEmpty ? image.first : '';
  }

  // Helper method to check if car has images
  bool get hasImages {
    return image.isNotEmpty;
  }

  // Helper method to check if extended price is available
  bool get hasExtendedPrice {
    return extendedPrice.perHour > 0 || extendedPrice.perDay > 0;
  }
}