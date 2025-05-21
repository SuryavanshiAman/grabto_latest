


import 'package:flutter/foundation.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../model/restaurants_flickes_model.dart';
import '../model/similar_restaurant_model.dart';

class RestaurantsFlicksRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<RestaurantsFlicksModel> restaurantsFlicksApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/api-flicks-store',data);
      return RestaurantsFlicksModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during flicksApi: $e');
      }
      rethrow;
    }
  }

}