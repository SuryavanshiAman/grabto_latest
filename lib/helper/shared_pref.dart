import 'dart:convert';

import 'package:grabto/model/user_model.dart';
import 'package:grabto/ui/intro_screen.dart';
import 'package:grabto/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String SHARED_PREF_NAME = "digicodersapp";

  static const String KEY_ID = "id";
  static const String REFFREE = "reffree";
  static const String KEY_CURRENT_MONTH = "current_month";
  static const String KEY_PREMIUM = "premium";
  static const String KEY_STATUS = "status";
  static const String KEY_NAME = "name";
  static const String KEY_EMAIL = "email";
  static const String KEY_MOBILE = "mobile";
  static const String KEY_DOB = "dob";
  static const String KEY_OTP = "otp";
  static const String KEY_IMAGE = "image";
  static const String KEY_HOME_LOCATION = "home_location";
  static const String KEY_CURRENT_LOCATION = "current_location";
  static const String ADDRESS = "address";
  static const String KEY_LAT = "lat";
  static const String KEY_LONG = "long";
  static const String REASON = "reason";
  static const String KEY_CREATED_AT = "created_at";
  static const String KEY_UPDATED_AT = "updated_at";
  static const String KEY_FIRST_RECHARGE = "first_reachage";
  static const String KEY_COVER_PHOTO = "cover_photo";
  static const String KEY_USER_NAME = "user_name";
  static const String KEY_BIO = "bio";
  static const String KEY_POST = "post";
  static const String KEY_FOLLOWER = "follower";
  static const String KEY_FOLLOWING = "following";
  static const String WALLET = "wallet";
  static const String REFERRALLINK = "refrral_link";
  static const String KEY_TOKEN = "token";
  static const String KEY_BANNER = 'banner';
  static const String KEY_GATEWAY_STATUS = "gateway_status";
  static const String KEY_EXTERNAL_LINK = "external";
  static const String KEY_ABOUT_EXTERNAL_STATUS= "about_external_status";

  static Future<void> userLogin(Map<String, dynamic> userData) async {
    print("🐬🐬🐬🐬🐬🐬🫠🫠🫠🫠🫠");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_ID, userData[KEY_ID] ?? 0);
    await prefs.setString(REFFREE, userData[REFFREE] ?? "");
    await prefs.setString(KEY_CURRENT_MONTH, userData[KEY_CURRENT_MONTH] ?? '');
    await prefs.setString(KEY_PREMIUM, userData[KEY_PREMIUM] ?? '');
    await prefs.setString(KEY_STATUS, userData[KEY_STATUS] ?? '');
    await prefs.setString(KEY_NAME, userData[KEY_NAME] ?? '');
    await prefs.setString(KEY_EMAIL, userData[KEY_EMAIL] ?? '');
    await prefs.setString(KEY_MOBILE, userData[KEY_MOBILE] ?? '');
    await prefs.setString(KEY_DOB, userData[KEY_DOB] ?? '');
    await prefs.setString(KEY_OTP, userData[KEY_OTP] ?? '');
    await prefs.setString(KEY_IMAGE, userData[KEY_IMAGE] ?? '');
    await prefs.setString(KEY_HOME_LOCATION, userData[KEY_HOME_LOCATION] ?? '');
    await prefs.setString(KEY_CURRENT_LOCATION, userData[KEY_CURRENT_LOCATION] ?? '');
    await prefs.setString(ADDRESS, userData[ADDRESS] ?? '');
    await prefs.setString(KEY_LAT, userData[KEY_LAT] ?? '');
    await prefs.setString(KEY_LONG, userData[KEY_LONG] ?? '');
    await prefs.setString(REASON, userData[REASON] ?? '');
    await prefs.setString(KEY_CREATED_AT, userData[KEY_CREATED_AT] ?? '');
    await prefs.setString(KEY_UPDATED_AT, userData[KEY_UPDATED_AT] ?? '');
    await prefs.setString(KEY_FIRST_RECHARGE, userData[KEY_FIRST_RECHARGE] ?? '');
    await prefs.setString(KEY_COVER_PHOTO, userData[KEY_COVER_PHOTO] ?? '');
    await prefs.setString(KEY_USER_NAME, userData[KEY_USER_NAME] ?? '');
    await prefs.setString(KEY_BIO, userData[KEY_BIO] ?? '');
    await prefs.setString(KEY_POST, userData[KEY_POST] ?? '');
    await prefs.setString(KEY_FOLLOWER, userData[KEY_FOLLOWER] ?? '');
    await prefs.setString(KEY_FOLLOWING, userData[KEY_FOLLOWING] ?? '');
    await prefs.setString(WALLET, userData[WALLET] ?? '');
    await prefs.setString(REFERRALLINK, userData[REFERRALLINK] ?? '');
    String bannerJson = jsonEncode(userData[KEY_BANNER]);
    await prefs.setString(KEY_BANNER, bannerJson);
  }

  static Future<int> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt(KEY_ID) ?? 0;
    return id;
  }

  // static Future<void> logout(BuildContext context) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginScreen(token: "",)),
  //   );
  // }

  static Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => IntroScreen()),
      (Route<dynamic> route) => false, // Remove all routes
    );
  }

  // static Future<UserModel> getUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? bannerJson = prefs.getString(KEY_BANNER);
  //   List<BannerModel> banners = [];
  //
  //   if (bannerJson != null && bannerJson.isNotEmpty) { // Fix: Check if not empty
  //     List<dynamic> decodedBanners = jsonDecode(bannerJson??"");
  //     banners = decodedBanners.map((e) => BannerModel.fromMap(e)).toList();
  //   }
  //   return UserModel(
  //     id: prefs.getInt(KEY_ID) ?? 0,
  //     current_month: prefs.getString(KEY_CURRENT_MONTH) ?? '',
  //     premium: prefs.getString(KEY_PREMIUM) ?? '',
  //     status: prefs.getString(KEY_STATUS) ?? '',
  //     name: prefs.getString(KEY_NAME) ?? '',
  //     email: prefs.getString(KEY_EMAIL) ?? '',
  //     mobile: prefs.getString(KEY_MOBILE) ?? '',
  //     dob: prefs.getString(KEY_DOB) ?? '',
  //     otp: prefs.getString(KEY_OTP) ?? '',
  //     image: prefs.getString(KEY_IMAGE) ?? '',
  //     home_location: prefs.getString(KEY_HOME_LOCATION) ?? '',
  //     current_location: prefs.getString(KEY_CURRENT_LOCATION) ?? '',
  //     lat: prefs.getString(KEY_LAT) ?? '',
  //     long: prefs.getString(KEY_LONG) ?? '',
  //     created_at: prefs.getString(KEY_CREATED_AT) ?? '',
  //     updated_at: prefs.getString(KEY_UPDATED_AT) ?? '',
  //     banners: banners, reffree: '', address: '', reason: '',
  //   );
  // }
  static Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bannerJson = prefs.getString(KEY_BANNER);
    List<BannerModel> banners = [];

    if (bannerJson != null && bannerJson.isNotEmpty) {
      try {
        var decoded = jsonDecode(bannerJson);
        if (decoded is List) {
          // banners = decoded.map((e) => BannerModel.fromMap(e)).toList();
          banners = decoded.map((e) => BannerModel.fromMap(e)).toList();
        }
      } catch (e) {
        print("Error decoding banner JSON: $e");
        // You can log or handle invalid JSON here
      }
    }

    return UserModel(
      id: prefs.getInt(KEY_ID) ?? 0,
      reffree: prefs.getString(REFFREE) ?? '',
      current_month: prefs.getString(KEY_CURRENT_MONTH) ?? '',
      premium: prefs.getString(KEY_PREMIUM) ?? '',
      status: prefs.getString(KEY_STATUS) ?? '',
      name: prefs.getString(KEY_NAME) ?? '',
      email: prefs.getString(KEY_EMAIL) ?? '',
      mobile: prefs.getString(KEY_MOBILE) ?? '',
      dob: prefs.getString(KEY_DOB) ?? '',
      otp: prefs.getString(KEY_OTP) ?? '',
      image: prefs.getString(KEY_IMAGE) ?? '',
      home_location: prefs.getString(KEY_HOME_LOCATION) ?? '',
      current_location: prefs.getString(KEY_CURRENT_LOCATION) ?? '',
      address: prefs.getString(ADDRESS) ?? '',
      lat: prefs.getString(KEY_LAT) ?? '',
      long: prefs.getString(KEY_LONG) ?? '',
      reason: prefs.getString(REASON) ?? '',
      created_at: prefs.getString(KEY_CREATED_AT) ?? '',
      updated_at: prefs.getString(KEY_UPDATED_AT) ?? '',
      firstReachage: prefs.getString(KEY_FIRST_RECHARGE) ?? '',
      coverPhoto: prefs.getString(KEY_COVER_PHOTO) ?? '',
      userName: prefs.getString(KEY_USER_NAME) ?? '',
      bio: prefs.getString(KEY_BIO) ?? '',
      post: prefs.getString(KEY_POST) ?? '',
      follower: prefs.getString(KEY_FOLLOWER) ?? '',
      following: prefs.getString(KEY_FOLLOWING) ?? '',
      wallet: prefs.getString(WALLET) ?? '',
      referralLink: prefs.getString(REFERRALLINK) ?? '',
      banners: banners,


    );
  }

  static Future<void> updateHomeLocation(String homeLocation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_HOME_LOCATION, homeLocation);
  }

  static Future<void> updateCurrentLocation(String currentLocation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_CURRENT_LOCATION, currentLocation);
  }

  static Future<String> getHomeLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_HOME_LOCATION) ?? '';
  }

  static Future<void> updateToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_TOKEN, token);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_TOKEN) ?? '';
  }

  static Future<void> updateGatewayStatus(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_GATEWAY_STATUS, token);
  }

  static Future<String> getGatewayStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_GATEWAY_STATUS) ?? '';
  }

  static Future<void> updateExternalLinkStatus(String status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_EXTERNAL_LINK, status);
  }

  static Future<String> getExternalLinkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_EXTERNAL_LINK) ?? '';
  }

  static Future<void> updateAboutExternalLinkStatus(String status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_ABOUT_EXTERNAL_STATUS, status);
  }

  static Future<String> getAboutExternalLinkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_ABOUT_EXTERNAL_STATUS) ?? '';
  }
}
