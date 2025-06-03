class LikeModel {
  String? res;
  String? message;
  Data? data;

  LikeModel({this.res, this.message, this.data});

  LikeModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['res'] = res;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic likesCount;
  dynamic isLiked;

  Data({this.likesCount, this.isLiked});

  Data.fromJson(Map<String, dynamic> json) {
    likesCount = json['likes_count'];
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes_count'] = likesCount;
    data['is_liked'] = isLiked;
    return data;
  }
}
