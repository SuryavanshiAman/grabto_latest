// class AddressModel {
//   bool? error;
//   String? message;
//   List<Data>? data;
//
//   AddressModel({this.error, this.message, this.data});
//
//   AddressModel.fromJson(Map<String, dynamic> json) {
//     error = json['error'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['error'] = this.error;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class AddressModel {
  int? id;
  int? userId;
  String? address;
  String? lat;
  String? long;
  String? status;
  String? date;

  AddressModel(
      {this.id,
        this.userId,
        this.address,
        this.lat,
        this.long,
        this.status,
        this.date});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
