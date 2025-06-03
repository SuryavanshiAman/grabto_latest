class GetHighlightModel {
  String? res;
  String? message;
  List<Data>? data;

  GetHighlightModel({this.res, this.message, this.data});

  GetHighlightModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['res'] = res;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? image;
  String? status;
  String? date;

  Data({this.id, this.userId, this.image, this.status, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    image = json['image'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['image'] = image;
    data['status'] = status;
    data['date'] = date;
    return data;
  }
}
