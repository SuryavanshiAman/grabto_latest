class ExploreModel {
  String? res;
  String? message;
  Data? data;

  ExploreModel({this.res, this.message, this.data});

  ExploreModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['res'] = res;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic currentPage;
  List<ExploreData>? exploreData;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  Data(
      {this.currentPage,
        this.exploreData,
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
      exploreData = <ExploreData>[];
      json['data'].forEach((v) {
        exploreData!.add(ExploreData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['current_page'] = currentPage;
    if (exploreData != null) {
      data['data'] = exploreData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ExploreData {
  dynamic id;
  dynamic userId;
  dynamic storeId;
  dynamic caption;
  dynamic turnOfComment;
  dynamic hideFireCount;
  dynamic hideShareCountPage;
  dynamic status;
  dynamic createdAt;
  dynamic userName;
  dynamic profileImg;
  dynamic likesCount;
  dynamic favoritesCount;
  dynamic commentsCount;
  dynamic sharesCount;
  dynamic isLiked;
  dynamic isFavorited;
  dynamic isCommented;
  dynamic isShared;
  dynamic isFollowingCreator;
  dynamic followerCount;
  List<Image>? image;

  ExploreData(
      {this.id,
        this.userId,
        this.storeId,
        this.caption,
        this.turnOfComment,
        this.hideFireCount,
        this.hideShareCountPage,
        this.status,
        this.createdAt,
        this.userName,
        this.profileImg,
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
        this.image});

  ExploreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    caption = json['caption'];
    turnOfComment = json['turn_of_comment'];
    hideFireCount = json['hide_fire_count'];
    hideShareCountPage = json['hide_share_count_page'];
    status = json['status'];
    createdAt = json['created_at'];
    userName = json['user_name'];
    profileImg = json['profile_img'];
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
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image!.add(Image.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['caption'] = caption;
    data['turn_of_comment'] = turnOfComment;
    data['hide_fire_count'] = hideFireCount;
    data['hide_share_count_page'] = hideShareCountPage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['user_name'] = userName;
    data['profile_img'] = profileImg;
    data['likes_count'] = likesCount;
    data['favorites_count'] = favoritesCount;
    data['comments_count'] = commentsCount;
    data['shares_count'] = sharesCount;
    data['is_liked'] = isLiked;
    data['is_favorited'] = isFavorited;
    data['is_commented'] = isCommented;
    data['is_shared'] = isShared;
    data['is_following_creator'] = isFollowingCreator;
    data['follower_count'] = followerCount;
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Image {
  dynamic url;

  Image({this.url});

  Image.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    return data;
  }
}

class Links {
  dynamic url;
  dynamic label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
