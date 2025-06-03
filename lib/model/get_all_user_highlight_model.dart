class GetAllUserHighlightModel {
  String? res;
  String? message;
  List<Data>? data;

  GetAllUserHighlightModel({this.res, this.message, this.data});

  GetAllUserHighlightModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['res'] = res;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic userId;
  dynamic image;
  dynamic status;
  dynamic date;
  dynamic userName;
  dynamic profileImage;
  dynamic exist;

  Data(
      {this.id,
        this.userId,
        this.image,
        this.status,
        this.date,
        this.userName,
        this.profileImage,
        this.exist,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    image = json['image'];
    status = json['status'];
    date = json['date'];
    userName = json['user_name'];
    profileImage = json['profile_image'];
    exist = json['exist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['image'] = image;
    data['status'] = status;
    data['date'] = date;
    data['user_name'] = userName;
    data['profile_image'] = profileImage;
    data['exist'] = exist;
    return data;
  }
}
