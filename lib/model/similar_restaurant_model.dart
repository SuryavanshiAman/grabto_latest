class SimilarRestaurantModel {
  String? res;
  String? msg;
  List<RestData>? data;

  SimilarRestaurantModel({this.res, this.data});

  SimilarRestaurantModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <RestData>[];
      json['data'].forEach((v) {
        data!.add(new RestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res'] = res;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestData {
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
  dynamic description;
  dynamic subcategoryName;
  dynamic featureNames;
  dynamic discountPercentage;
  dynamic availableSeat;
  dynamic avgRating;
  dynamic amount;
  List<SimilarImage>? image;

  RestData(
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
        this.description,
        this.subcategoryName,
        this.featureNames,
        this.discountPercentage,
        this.availableSeat,
        this.avgRating,
        this.amount,
        this.image});

  RestData.fromJson(Map<String, dynamic> json) {
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
    description = json['description'];
    subcategoryName = json['subcategory_name'];
    featureNames = json['feature_names'];
    discountPercentage = json['discount_percentage'];
    availableSeat = json['available_seat'];
    avgRating = json['avg_rating'];
    amount = json['amount'];
    if (json['image'] != null) {
      image = <SimilarImage>[];
      json['image'].forEach((v) {
        image!.add(new SimilarImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['store_type'] = storeType;
    data['owner_mobile'] = ownerMobile;
    data['store_name'] = storeName;
    data['dish'] = dish;
    data['mobile'] = mobile;
    data['password'] = password;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['qrcode'] = qrcode;
    data['logo'] = logo;
    data['banner'] = banner;
    data['trendding'] = trendding;
    data['address'] = address;
    data['map_link'] = mapLink;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['distance'] = distance;
    data['lat'] = lat;
    data['long'] = long;
    data['offers'] = offers;
    data['rating'] = rating;
    data['redem'] = redem;
    data['offer_id'] = offerId;
    data['topcollection_id'] = topcollectionId;
    data['trending_status'] = trendingStatus;
    data['recent_status'] = recentStatus;
    data['topcollection_status'] = topcollectionStatus;
    data['owner_fname'] = ownerFname;
    data['owner_lname'] = ownerLname;
    data['address2'] = address2;
    data['country'] = country;
    data['state'] = state;
    data['locality_id'] = localityId;
    data['locality_name'] = localityName;
    data['postcode'] = postcode;
    data['location'] = location;
    data['otp'] = otp;
    data['email'] = email;
    data['alternate_mobile'] = alternateMobile;
    data['position'] = position;
    data['commission'] = commission;
    data['description'] = description;
    data['subcategory_name'] = subcategoryName;
    data['feature_names'] = featureNames;
    data['discount_percentage'] = discountPercentage;
    data['available_seat'] = availableSeat;
    data['avg_rating'] = avgRating;
    data['amount'] = amount;
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SimilarImage {
  String? url;

  SimilarImage({this.url});

  SimilarImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = url;
    return data;
  }
}
