


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/my_follower_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class MyFollowrsRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MyFollowersModel> myFollowerApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/get-follower?user_id=$data' );
      return MyFollowersModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during myFollowerApi: $e');
      }
      rethrow;
    }
  }

}