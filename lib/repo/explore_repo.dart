


import 'package:flutter/foundation.dart';
import 'package:grabto/model/explore_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class ExploreRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<ExploreModel> exploreApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/get-explore');
      return ExploreModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during exploreApi: $e');
      }
      rethrow;
    }
  }

}