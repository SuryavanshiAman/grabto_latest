


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/my_follower_model.dart';
import 'package:grabto/model/my_following_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class MyFollowingRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MyFollowingModel> myFollowingApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/get-following?user_id=$data' );
      return MyFollowingModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during myFollowingApi: $e');
      }
      rethrow;
    }
  }

}