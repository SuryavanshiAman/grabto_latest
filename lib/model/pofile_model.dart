class ProfileModel {
  String? res;
  String? msg;
  Data? data;

  ProfileModel({this.res, this.msg, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = res;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic reffree;
  dynamic referral;
  dynamic currentMonth;
  dynamic premium;
  dynamic status;
  dynamic name;
  dynamic email;
  dynamic mobile;
  dynamic dob;
  dynamic otp;
  dynamic image;
  dynamic homeLocation;
  dynamic currentLocation;
  dynamic address;
  dynamic lat;
  dynamic long;
  dynamic reason;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic firstReachage;
  dynamic coverPhoto;
  dynamic userName;
  dynamic bio;
  dynamic post;
  dynamic follower;
  dynamic following;
  dynamic wallet;
  dynamic refrralLink;
  List<Banner>? banner;

  Data(
      {this.id,
        this.reffree,
        this.referral,
        this.currentMonth,
        this.premium,
        this.status,
        this.name,
        this.email,
        this.mobile,
        this.dob,
        this.otp,
        this.image,
        this.homeLocation,
        this.currentLocation,
        this.address,
        this.lat,
        this.long,
        this.reason,
        this.createdAt,
        this.updatedAt,
        this.firstReachage,
        this.coverPhoto,
        this.userName,
        this.bio,
        this.post,
        this.follower,
        this.following,
        this.wallet,
        this.refrralLink,
        this.banner});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reffree = json['reffree'];
    referral = json['referral'];
    currentMonth = json['current_month'];
    premium = json['premium'];
    status = json['status'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    dob = json['dob'];
    otp = json['otp'];
    image = json['image'];
    homeLocation = json['home_location'];
    currentLocation = json['current_location'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firstReachage = json['first_reachage'];
    coverPhoto = json['cover_photo'];
    userName = json['user_name'];
    bio = json['bio'];
    post = json['post'];
    follower = json['follower'];
    following = json['following'];
    wallet = json['wallet'];
    refrralLink = json['refrral_link'];
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(new Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['reffree'] = reffree;
    data['referral'] = referral;
    data['current_month'] = currentMonth;
    data['premium'] = premium;
    data['status'] = status;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['dob'] = dob;
    data['otp'] = otp;
    data['image'] = image;
    data['home_location'] = homeLocation;
    data['current_location'] = currentLocation;
    data['address'] = address;
    data['lat'] = lat;
    data['long'] = long;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['first_reachage'] = firstReachage;
    data['cover_photo'] = coverPhoto;
    data['user_name'] = userName;
    data['bio'] = bio;
    data['post'] = post;
    data['follower'] = follower;
    data['following'] = following;
    data['wallet'] = wallet;
    data['refrral_link'] = refrralLink;
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  dynamic type;
  dynamic url;
  dynamic image;
  dynamic status;
  dynamic id;
  dynamic categoryId;
  dynamic subcategoryName;
  dynamic createdAt;
  dynamic updatedAt;

  Banner(
      {this.type,
        this.url,
        this.image,
        this.status,
        this.id,
        this.categoryId,
        this.subcategoryName,
        this.createdAt,
        this.updatedAt});

  Banner.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    image = json['image'];
    status = json['status'];
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryName = json['subcategory_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['url'] = url;
    data['image'] = image;
    data['status'] = status;
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory_name'] = subcategoryName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
