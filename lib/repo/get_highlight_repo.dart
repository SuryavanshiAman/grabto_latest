


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_hightlight_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class GetHighlightRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GetHighlightModel> getHighlightApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/get-user-highlight',data );
      return GetHighlightModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getHighlightApi: $e');
      }
      rethrow;
    }
  }

}