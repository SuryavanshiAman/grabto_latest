class MyFollowersModel {
  String? res;
  String? message;
  List<Data>? data;

  MyFollowersModel({this.res, this.message, this.data});

  MyFollowersModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
  dynamic followerId;
  dynamic followingId;
  dynamic status;
 dynamic createdAt;
 dynamic updatedAt;
 dynamic name;
 dynamic image;
 dynamic userName;
  dynamic isFollowedByCurrentUser;

  Data(
      {this.id,
        this.followerId,
        this.followingId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.image,
        this.userName,
        this.isFollowedByCurrentUser});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerId = json['follower_id'];
    followingId = json['following_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    image = json['image'];
    userName = json['user_name'];
    isFollowedByCurrentUser = json['is_followed_by_current_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['follower_id'] = followerId;
    data['following_id'] = followingId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['image'] = image;
    data['user_name'] = userName;
    data['is_followed_by_current_user'] = isFollowedByCurrentUser;
    return data;
  }
}
