
class FilteredDataModel {
  String? res;
  String? msg;
  List<Data>? data;

  FilteredDataModel({this.res,this.msg, this.data});

  FilteredDataModel.fromJson(Map<String, dynamic> json) {
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
    data['res'] = res;
    data['msg'] = msg;
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
  dynamic postcode;
  dynamic location;
  dynamic otp;
  dynamic email;
  dynamic alternateMobile;
  dynamic position;
  dynamic commission;
  dynamic subCategoriesName;
  dynamic name;
  dynamic discountPercentage;
  dynamic availableSeat;
  dynamic amount;
  dynamic avgRating;
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
        this.postcode,
        this.location,
        this.otp,
        this.email,
        this.alternateMobile,
        this.position,
        this.commission,
        this.subCategoriesName,
        this.name,
        this.discountPercentage,
        this.availableSeat,
        this.amount,
        this.avgRating,
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
    postcode = json['postcode'];
    location = json['location'];
    otp = json['otp'];
    email = json['email'];
    alternateMobile = json['alternate_mobile'];
    position = json['position'];
    commission = json['commission'];
    subCategoriesName = json['subcategory_name'];
    name = json['name'];
    discountPercentage = json['discount_percentage'];
    availableSeat = json['available_seat'];
    amount = json['amount'];
    avgRating = json['avg_rating'];
    if (json['image'] != null) {
      image = <BannerImage>[];
      json['image'].forEach((v) {
        image!.add(new BannerImage.fromJson(v));
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
    data['postcode'] = postcode;
    data['location'] = location;
    data['otp'] = otp;
    data['email'] = email;
    data['alternate_mobile'] = alternateMobile;
    data['position'] = position;
    data['commission'] = commission;
    data['subcategory_name'] = subCategoriesName;
    data['name'] = name;
    data['discount_percentage'] = discountPercentage;
    data['available_seat'] = availableSeat;
    data['amount'] = amount;
    data['avg_rating'] = avgRating;
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
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
    data['url'] = url;
    return data;
  }
}
