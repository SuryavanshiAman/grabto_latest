class MenuDataModel {
  String? res;
  List<Data>? data;

  MenuDataModel({this.res, this.data});

  MenuDataModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? storeId;
  String? image;
  String? menuType;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.storeId,
        this.image,
        this.menuType,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    image = json['image'];
    menuType = json['menu_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['store_id'] = storeId;
    data['image'] = image;
    data['menu_type'] = menuType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
