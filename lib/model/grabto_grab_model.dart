class GrabtoGrabModel {
  String? res;
  String? msg;
  List<Data>? data;

  GrabtoGrabModel({this.res, this.msg, this.data});

  GrabtoGrabModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
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
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic storeType;
  dynamic ownerMobile;
  dynamic storeName;
  dynamic dish;
  dynamic mobile;
  dynamic password;
  dynamic categoryId;
  dynamic subcategoryId;
  dynamic qrcode;
  dynamic logo;
  dynamic banner;
  dynamic trendding;
  dynamic address;
  dynamic mapLink;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic distance;
  dynamic lat;
  dynamic long;
  dynamic offers;
  dynamic rating;
  dynamic redem;
  dynamic offerId;
  dynamic topcollectionId;
  dynamic trendingStatus;
  dynamic recentStatus;
  dynamic topcollectionStatus;
  dynamic ownerFname;
  dynamic ownerLname;
  dynamic address2;
  dynamic country;
  dynamic state;
  dynamic localityId;
  dynamic localityName;
  dynamic postcode;
  dynamic location;
  dynamic otp;
  dynamic email;
  dynamic alternateMobile;
  dynamic position;
  dynamic commission;
  dynamic backgroundimage;
  dynamic latestGrabId;
  dynamic subcategoryName;
  dynamic featureNames;
  dynamic discountPercentage;
  dynamic availableSeat;
  List<BannerImage>? image;

  Data(
      {this.id,
        this.storeType,
        this.ownerMobile,
        this.storeName,
        this.dish,
        this.mobile,
        this.password,
        this.categoryId,
        this.subcategoryId,
        this.qrcode,
        this.logo,
        this.banner,
        this.trendding,
        this.address,
        this.mapLink,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.distance,
        this.lat,
        this.long,
        this.offers,
        this.rating,
        this.redem,
        this.offerId,
        this.topcollectionId,
        this.trendingStatus,
        this.recentStatus,
        this.topcollectionStatus,
        this.ownerFname,
        this.ownerLname,
        this.address2,
        this.country,
        this.state,
        this.localityId,
        this.localityName,
        this.postcode,
        this.location,
        this.otp,
        this.email,
        this.alternateMobile,
        this.position,
        this.commission,
        this.backgroundimage,
        this.latestGrabId,
        this.subcategoryName,
        this.featureNames,
        this.discountPercentage,
        this.availableSeat,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeType = json['store_type'];
    ownerMobile = json['owner_mobile'];
    storeName = json['store_name'];
    dish = json['dish'];
    mobile = json['mobile'];
    password = json['password'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    qrcode = json['qrcode'];
    logo = json['logo'];
    banner = json['banner'];
    trendding = json['trendding'];
    address = json['address'];
    mapLink = json['map_link'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
    lat = json['lat'];
    long = json['long'];
    offers = json['offers'];
    rating = json['rating'];
    redem = json['redem'];
    offerId = json['offer_id'];
    topcollectionId = json['topcollection_id'];
    trendingStatus = json['trending_status'];
    recentStatus = json['recent_status'];
    topcollectionStatus = json['topcollection_status'];
    ownerFname = json['owner_fname'];
    ownerLname = json['owner_lname'];
    address2 = json['address2'];
    country = json['country'];
    state = json['state'];
    localityId = json['locality_id'];
    localityName = json['locality_name'];
    postcode = json['postcode'];
    location = json['location'];
    otp = json['otp'];
    email = json['email'];
    alternateMobile = json['alternate_mobile'];
    position = json['position'];
    commission = json['commission'];
    backgroundimage = json['backgroundimage'];
    latestGrabId = json['latest_grab_id'];
    subcategoryName = json['subcategory_name'];
    featureNames = json['feature_names'];
    discountPercentage = json['discount_percentage'];
    availableSeat = json['available_seat'];
    if (json['image'] != null) {
      image = <BannerImage>[];
      json['image'].forEach((v) {
        image!.add(new BannerImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_type'] = this.storeType;
    data['owner_mobile'] = this.ownerMobile;
    data['store_name'] = this.storeName;
    data['dish'] = this.dish;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['qrcode'] = this.qrcode;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['trendding'] = this.trendding;
    data['address'] = this.address;
    data['map_link'] = this.mapLink;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance'] = this.distance;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['offers'] = this.offers;
    data['rating'] = this.rating;
    data['redem'] = this.redem;
    data['offer_id'] = this.offerId;
    data['topcollection_id'] = this.topcollectionId;
    data['trending_status'] = this.trendingStatus;
    data['recent_status'] = this.recentStatus;
    data['topcollection_status'] = this.topcollectionStatus;
    data['owner_fname'] = this.ownerFname;
    data['owner_lname'] = this.ownerLname;
    data['address2'] = this.address2;
    data['country'] = this.country;
    data['state'] = this.state;
    data['locality_id'] = this.localityId;
    data['locality_name'] = this.localityName;
    data['postcode'] = this.postcode;
    data['location'] = this.location;
    data['otp'] = this.otp;
    data['email'] = this.email;
    data['alternate_mobile'] = this.alternateMobile;
    data['position'] = this.position;
    data['commission'] = this.commission;
    data['backgroundimage'] = this.backgroundimage;
    data['latest_grab_id'] = this.latestGrabId;
    data['subcategory_name'] = this.subcategoryName;
    data['feature_names'] = this.featureNames;
    data['discount_percentage'] = this.discountPercentage;
    data['available_seat'] = this.availableSeat;
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerImage {
  String? url;

  BannerImage({this.url});

  BannerImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
