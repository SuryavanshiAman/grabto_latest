class FlicksModel {
  String? res;
  Data? data;

  FlicksModel({this.res, this.data});

  FlicksModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = this.res;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<FlicksData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <FlicksData>[];
      json['data'].forEach((v) {
        data!.add(new FlicksData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class FlicksData {
  int? id;
  int? userId;
  int? storeId;
  String? videoLink;
  String? caption;
  String? turnOfComment;
  String? hideFireCount;
  String? hideShareCountPage;
  String? status;
  String? date;
  String? userName;
  String? profileImage;
  String? storeName;
  String? image;
  String? address;
  String? mapLink;
  int? likesCount;
  int? favoritesCount;
  int? commentsCount;
  int? sharesCount;
  int? isLiked;
  int? isFavorited;
  int? isCommented;
  int? isShared;
  int? isFollowingCreator;
  int? followerCount;
  // List<Null>? comments;

  FlicksData(
      {this.id,
        this.userId,
        this.storeId,
        this.videoLink,
        this.caption,
        this.turnOfComment,
        this.hideFireCount,
        this.hideShareCountPage,
        this.status,
        this.date,
        this.userName,
        this.profileImage,
        this.storeName,
        this.image,
        this.address,
        this.mapLink,
        this.likesCount,
        this.favoritesCount,
        this.commentsCount,
        this.sharesCount,
        this.isLiked,
        this.isFavorited,
        this.isCommented,
        this.isShared,
        this.isFollowingCreator,
        this.followerCount,
        // this.comments
      });


  FlicksData.fromJson(Map<String, dynamic> json) {
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
    userName = json['user_name'];
    profileImage = json['profile_image'];
    storeName = json['store_name'];
    image = json['image'];
    address = json['address'];
    mapLink = json['map_link'];
    likesCount = json['likes_count'];
    favoritesCount = json['favorites_count'];
    commentsCount = json['comments_count'];
    sharesCount = json['shares_count'];
    isLiked = json['is_liked'];
    isFavorited = json['is_favorited'];
    isCommented = json['is_commented'];
    isShared = json['is_shared'];
    isFollowingCreator = json['is_following_creator'];
    followerCount = json['follower_count'];
    // if (json['comments'] != null) {
    //   comments = <Null>[];
    //   json['comments'].forEach((v) {
    //     comments!.add(new Null.fromJson(v));
    //   });
    // }
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
    data['user_name'] = this.userName;
    data['profile_image'] = this.profileImage;
    data['likes_count'] = this.likesCount;
    data['favorites_count'] = this.favoritesCount;
    data['comments_count'] = this.commentsCount;
    data['shares_count'] = this.sharesCount;
    data['is_liked'] = this.isLiked;
    data['is_favorited'] = this.isFavorited;
    data['is_commented'] = this.isCommented;
    data['is_shared'] = this.isShared;
    data['is_following_creator'] = this.isFollowingCreator;
    data['follower_count'] = this.followerCount;
    // if (this.comments != null) {
    //   data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
