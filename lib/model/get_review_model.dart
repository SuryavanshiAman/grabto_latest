class GetReviewModel {
  String? res;
  String? message;
  List<Data>? data;

  GetReviewModel({this.res, this.message, this.data});

  GetReviewModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
 dynamic id;
 dynamic userId;
 dynamic storeId;
  dynamic caption;
 dynamic noRating;
 dynamic turnOfComment;
 dynamic hideFireCount;
 dynamic hideShareCountPage;
 dynamic status;
 dynamic date;
  List<ReviewImage>? image;

  Data(
      {this.id,
        this.userId,
        this.storeId,
        this.caption,
        this.noRating,
        this.turnOfComment,
        this.hideFireCount,
        this.hideShareCountPage,
        this.status,
        this.date,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    caption = json['caption'];
    noRating = json['no_rating'];
    turnOfComment = json['turn_of_comment'];
    hideFireCount = json['hide_fire_count'];
    hideShareCountPage = json['hide_share_count_page'];
    status = json['status'];
    date = json['date'];
    if (json['image'] != null) {
      image = <ReviewImage>[];
      json['image'].forEach((v) {
        image!.add(new ReviewImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['caption'] = this.caption;
    data['no_rating'] = this.noRating;
    data['turn_of_comment'] = this.turnOfComment;
    data['hide_fire_count'] = this.hideFireCount;
    data['hide_share_count_page'] = this.hideShareCountPage;
    data['status'] = this.status;
    data['date'] = this.date;
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewImage {
  int? id;
  int? reviId;
  String? image;
  String? status;
  String? date;

  ReviewImage({this.id, this.reviId, this.image, this.status, this.date});

  ReviewImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviId = json['revi_id'];
    image = json['image'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['revi_id'] = this.reviId;
    data['image'] = this.image;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
