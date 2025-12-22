class AuthModel {
  final String id;
  final String mobile;
  final String name;
  final String? email;
  final List<String> myBookings;
  String? profileImage;
  final String code;
  final List<dynamic>? wallet;

  AuthModel({
    required this.id,
    required this.mobile,
    required this.name,
    this.email,
    required this.myBookings,
    this.profileImage,
    required this.code,
    this.wallet,
  });

factory AuthModel.fromJson(Map<String, dynamic> json) {
  final id = json['_id'] ?? json['id'];
  
  return AuthModel(
    id: id,
    mobile: json['mobile'],
    name: json['name'],
    email: json['email'],
    myBookings: json['myBookings'] != null
        ? List<String>.from(json['myBookings'])
        : [],
    profileImage: json['profileImage'],
    code: json['code'] ?? '',
    wallet: json['wallet'],
  );
}
  Map<String, dynamic> toJson() {
    final data = {
      '_id': id,
      'mobile': mobile,
      'name': name,
      'myBookings': myBookings,
    };

    if (email != null && email!.isNotEmpty) {
      data['email'] = email!;
    }
    
    if (profileImage != null && profileImage!.isNotEmpty) {
      data['profileImage'] = profileImage!;
    }
    
    
    if (wallet != null) {
      data['wallet'] = wallet!;
    }

    return data;
  }

  AuthModel copyWith({
    String? id,
    String? mobile,
    String? name,
    String? email,
    List<String>? myBookings,
    String? profileImage,
    String? code,
    List<dynamic>? wallet,
  }) {
    return AuthModel(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      email: email ?? this.email,
      myBookings: myBookings ?? this.myBookings,
      profileImage: profileImage ?? this.profileImage,
      code: code ?? this.code,
      wallet: wallet ?? this.wallet,
    );
  }
}