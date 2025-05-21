class GetPostModel {
  String? res;
  String? message;
  List<Data>? data;

  GetPostModel({this.res, this.message, this.data});

  GetPostModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? userId;
  int? storeId;
  String? caption;
  String? turnOfComment;
  String? hideFireCount;
  String? hideShareCountPage;
  String? status;
  String? createdAt;
  List<PostImage>? postImage;

  Data(
      {this.id,
        this.userId,
        this.storeId,
        this.caption,
        this.turnOfComment,
        this.hideFireCount,
        this.hideShareCountPage,
        this.status,
        this.createdAt,
        this.postImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    caption = json['caption'];
    turnOfComment = json['turn_of_comment'];
    hideFireCount = json['hide_fire_count'];
    hideShareCountPage = json['hide_share_count_page'];
    status = json['status'];
    createdAt = json['created_at'];
    if (json['image'] != null) {
      postImage = <PostImage>[];
      json['image'].forEach((v) {
        postImage!.add(new PostImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['caption'] = caption;
    data['turn_of_comment'] = turnOfComment;
    data['hide_fire_count'] = hideFireCount;
    data['hide_share_count_page'] = hideShareCountPage;
    data['status'] = status;
    data['created_at'] = createdAt;
    if (postImage != null) {
      data['image'] = postImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostImage {
  int? id;
  int? postId;
  String? image;
  String? status;
  String? createdAt;

  PostImage({this.id, this.postId, this.image, this.status, this.createdAt});

  PostImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
