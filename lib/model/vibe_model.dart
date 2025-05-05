class VibeModel {
  String? res;
  List<VibeData>? data;

  VibeModel({this.res, this.data});

  VibeModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    if (json['data'] != null) {
      data = <VibeData>[];
      json['data'].forEach((v) {
        data!.add(new VibeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = res;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VibeData {
  dynamic id;
  dynamic storeId;
  dynamic foodType;
  dynamic image;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  VibeData(
      {this.id,
        this.storeId,
        this.foodType,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  VibeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    foodType = json['food_type'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['store_id'] = storeId;
    data['food_type'] = foodType;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
