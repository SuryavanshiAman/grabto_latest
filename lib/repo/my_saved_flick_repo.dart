


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/my_save_flick_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class MySavedFlickRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MySaveFlickModel> mySaveFlickApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/showBookmarkReel',data );
      return MySaveFlickModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during mySaveFlickApi: $e');
      }
      rethrow;
    }
  }

}