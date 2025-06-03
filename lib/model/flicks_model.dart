class FlicksModel {
  String? res;
  Data? data;

  FlicksModel({this.res, this.data});

  FlicksModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['res'] = res;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic  currentPage;
  List<FlicksData>? data;
  dynamic  firstPageUrl;
  dynamic  from;
  dynamic  lastPage;
  dynamic  lastPageUrl;
  List<Links>? links;
  dynamic  nextPageUrl;
  dynamic  path;
  dynamic  perPage;
  dynamic  prevPageUrl;
  dynamic  to;
  dynamic  total;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class FlicksData {
  dynamic  id;
  dynamic  userId;
  dynamic  storeId;
  dynamic  videoLink;
  dynamic  thumbnailLink;
  dynamic  caption;
  dynamic  turnOfComment;
  dynamic  hideFireCount;
  dynamic  hideShareCountPage;
  dynamic  status;
  dynamic  date;
  dynamic  name;
  dynamic  userName;
  dynamic  coverPhoto;
  dynamic  profileImage;
  dynamic  bio;
  dynamic  storeName;
  dynamic  image;
  dynamic  address;
  dynamic  mapLink;
  dynamic  likesCount;
  dynamic  favoritesCount;
  dynamic  commentsCount;
  dynamic  sharesCount;
  dynamic  isLiked;
  dynamic  isFavorited;
  dynamic  isCommented;
  dynamic  isShared;
  dynamic  isFollowingCreator;
  dynamic  followerCount;
  dynamic  followingCount;
  dynamic  userPostCount;

  FlicksData(
      {this.id,
        this.userId,
        this.storeId,
        this.videoLink,
        this.thumbnailLink,
        this.caption,
        this.turnOfComment,
        this.hideFireCount,
        this.hideShareCountPage,
        this.status,
        this.date,
        this.name,
        this.userName,
        this.coverPhoto,
        this.profileImage,
        this.bio,
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
        this.followingCount,
        this.userPostCount,
        });

  FlicksData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    videoLink = json['video_link'];
    thumbnailLink = json['thumbnail_link'];
    caption = json['caption'];
    turnOfComment = json['turn_of_comment'];
    hideFireCount = json['hide_fire_count'];
    hideShareCountPage = json['hide_share_count_page'];
    status = json['status'];
    date = json['date'];
    name = json['name'];
    userName = json['user_name'];
    coverPhoto = json['cover_photo'];
    profileImage = json['profile_image'];
    bio = json['bio'];
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
    followingCount = json['following_count'];
    userPostCount = json['user_post_count'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['video_link'] = videoLink;
    data['thumbnail_link'] = thumbnailLink;
    data['caption'] = caption;
    data['turn_of_comment'] = turnOfComment;
    data['hide_fire_count'] = hideFireCount;
    data['hide_share_count_page'] = hideShareCountPage;
    data['status'] = status;
    data['date'] = date;
    data['name'] = name;
    data['user_name'] = userName;
    data['cover_photo'] = coverPhoto;
    data['profile_image'] = profileImage;
    data['bio'] = bio;
    data['store_name'] = storeName;
    data['image'] = image;
    data['address'] = address;
    data['map_link'] = mapLink;
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
    data['following_count'] = followingCount;
    data['user_post_count'] = userPostCount;

    return data;
  }
}

class Links {
  dynamic  url;
  dynamic  label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
