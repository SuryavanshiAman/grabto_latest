


import 'package:flutter/foundation.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../model/similar_restaurant_model.dart';

class SimilarRestrRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<SimilarRestaurantModel> similarRestroApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/api-similar-restorent',data);
      return SimilarRestaurantModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during similarRestroApi: $e');
      }
      rethrow;
    }
  }

}