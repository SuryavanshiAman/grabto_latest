


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_all_user_highlight_model.dart';
import 'package:grabto/model/get_hightlight_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class GetAllUserHighlightRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GetAllUserHighlightModel> getAllUserHighlightApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/get-all-user-highlight?user_id=1633' );
      return GetAllUserHighlightModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getAllUserHighlightApi: $e');
      }
      rethrow;
    }
  }

}