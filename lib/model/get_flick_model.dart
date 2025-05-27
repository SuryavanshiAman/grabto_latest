class GetFlickModel {
  String? res;
  String? message;
  List<GetFlickData>? data;

  GetFlickModel({this.res, this.message, this.data});

  GetFlickModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetFlickData>[];
      json['data'].forEach((v) {
        data!.add(new GetFlickData.fromJson(v));
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

class GetFlickData {
  dynamic id;
  dynamic userId;
  dynamic storeId;
  dynamic videoLink;
  dynamic caption;
  dynamic turnOfComment;
  dynamic hideFireCount;
  dynamic hideShareCountPage;
  dynamic status;
  dynamic date;

  GetFlickData(
      {this.id,
        this.userId,
        this.storeId,
        this.videoLink,
        this.caption,
        this.turnOfComment,
        this.hideFireCount,
        this.hideShareCountPage,
        this.status,
        this.date});

  GetFlickData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    videoLink = json['video_link'];
    caption = json['caption'];
    turnOfComment = json['turn_of_comment'];
    hideFireCount = json['hide_fire_count'];
    hideShareCountPage = json['hide_share_count_page'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['video_link'] = this.videoLink;
    data['caption'] = this.caption;
    data['turn_of_comment'] = this.turnOfComment;
    data['hide_fire_count'] = this.hideFireCount;
    data['hide_share_count_page'] = this.hideShareCountPage;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
