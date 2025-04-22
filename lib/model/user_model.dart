//
// class UserModel {
//   final int id;
//   final String current_month;
//   final String premium;
//   final String status;
//   final String name;
//   final String email;
//   final String mobile;
//   final String dob;
//   final String otp;
//   final String image;
//   final String home_location;
//   final String current_location;
//   final String lat;
//   final String long;
//   final String created_at;
//   final String updated_at;
//
//   UserModel({
//     required this.id,
//     required this.current_month,
//     required this.premium,
//     required this.status,
//     required this.name,
//     required this.email,
//     required this.mobile,
//     required this.dob,
//     required this.otp,
//     required this.image,
//     required this.home_location,
//     required this.current_location,
//     required this.lat,
//     required this.long,
//     required this.created_at,
//     required this.updated_at,
//   });
//
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] ?? 0,
//       current_month: map['current_month'] ?? '',
//       premium: map['premium'] ?? '',
//       status: map['status'] ?? '',
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       mobile: map['mobile'] ?? '',
//       dob: map['dob'] ?? '',
//       otp: map['otp'] ?? '',
//       image: map['image'] ?? '',
//       home_location: map['home_location'] ?? '',
//       current_location: map['current_location'] ?? '',
//       lat: map['lat'] ?? '',
//       long: map['long'] ?? '',
//       created_at: map['created_at'] ?? '',
//       updated_at: map['updated_at'] ?? '',
//     );
//   }
// }
import 'dart:convert';

class UserModel {
  final dynamic id;
  final dynamic reffree; // Added
  final dynamic current_month;
  final dynamic premium;
  final dynamic status;
  final dynamic name;
  final dynamic email;
  final dynamic mobile;
  final dynamic dob;
  final dynamic otp;
  final dynamic image;
  final dynamic home_location;
  final dynamic current_location;
  final dynamic address; // Added
  final dynamic lat;
  final dynamic long;
  final dynamic reason; // Added
  final dynamic created_at;
  final dynamic updated_at;
  final List<BannerModel> banners;

  UserModel({
    required this.id,
    required this.reffree,
    required this.current_month,
    required this.premium,
    required this.status,
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.otp,
    required this.image,
    required this.home_location,
    required this.current_location,
    required this.address,
    required this.lat,
    required this.long,
    required this.reason,
    required this.created_at,
    required this.updated_at,
    required this.banners,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      reffree: map['reffree'] ?? '',
      current_month: map['current_month'] ?? '',
      premium: map['premium'] ?? '',
      status: map['status'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      dob: map['dob'] ?? '',
      otp: map['otp'] ?? '',
      image: map['image'] ?? '',
      home_location: map['home_location'] ?? '',
      current_location: map['current_location'] ?? '',
      address: map['address'] ?? '',
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
      reason: map['reason'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
      banners: map['banner'] != null
          ? List<BannerModel>.from(
          (map['banner'] as List).map((e) => BannerModel.fromMap(e)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reffree': reffree,
      'current_month': current_month,
      'premium': premium,
      'status': status,
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'otp': otp,
      'image': image,
      'home_location': home_location,
      'current_location': current_location,
      'address': address,
      'lat': lat,
      'long': long,
      'reason': reason,
      'created_at': created_at,
      'updated_at': updated_at,
      'banner': banners.map((e) => e.toMap()).toList(),
    };
  }
}

class BannerModel {
  final dynamic id;
  final dynamic type;
  final dynamic url;
  final dynamic image;
  final dynamic status;
  final dynamic category_id;
  final dynamic subcategory_name;
  final dynamic created_at;
  final dynamic updated_at;

  BannerModel({
    required this.id,
    required this.type,
    required this.url,
    required this.image,
    required this.status,
    required this.category_id,
    required this.subcategory_name,
    required this.created_at,
    required this.updated_at,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    print(map['image']);
    print("bannerImage");
    return BannerModel(
      id: map['id'] ?? 0,
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? '',
      category_id: map['category_id'] ?? '',
      subcategory_name: map['subcategory_name'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    print(image);
    print("bannerImage");
    return {
      'id': id,
      'type': type,
      'url': url,
      'image': image,
      'status': status,
      'category_id': category_id,
      'subcategory_name': subcategory_name,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

